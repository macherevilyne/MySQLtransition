DROP TABLE IF EXISTS `Monet Inputs Term`;
CREATE TABLE IF NOT EXISTS `Monet Inputs Term` AS
SELECT `Policy Nr` AS PolNo,
    TIMESTAMPDIFF(MONTH, STR_TO_DATE(`DOC`, '%d-%m-%Y'), STR_TO_DATE('{date_data_extract}', '%d-%m-%Y')) AS PeriodIF,
    CASE
        WHEN `CalcEngine` IN (8, 13) THEN 'WholeLife'
        WHEN `CalcEngine` >= 5 OR ISNULL(`CalcEngine`) THEN 'TermNew'
        ELSE 'Term'
    END AS Product,
    CASE
        WHEN `CalcEngine` IN (12, 21) THEN 'No'
        ELSE `Joined lives`
    END AS Joined,
    `Gender1` AS Sex1,
    `Gender2` AS Sex2,
    'Netherlands' AS Country,
    AgeNearest(STR_TO_DATE(`DOB1`, '%d-%m-%Y'), STR_TO_DATE(`DOC`, '%d-%m-%Y')) AS AgeEnt1,
    CASE
        WHEN (SELECT `Joined`) = 'No' THEN 0
        ELSE AgeNearest(STR_TO_DATE(`DOB2`, '%d-%m-%Y'), STR_TO_DATE(`DOC`, '%d-%m-%Y'))
    END AS AgeEnt2,
    CASE
        WHEN `Smoke1` = 'No' THEN 'NonSmoker'
        ELSE 'Smoker'
    END AS Smoker1,
    CASE
        WHEN `Smoke2` = 'No' THEN 'NonSmoker'
        ELSE 'Smoker'
    END AS Smoker2,
    CASE
        WHEN `Freq` = 'Monthly' THEN 12
        WHEN `Freq` = 'Yearly' THEN 1
        WHEN `Freq` = 'Single' THEN 99
        ELSE 99999
    END AS PremFreq,
    IFNULL(`QP Single`, 0) AS SPWithOptions,
    IFNULL(
        IF(`Freq` = 'Single',
            PremWoOptions(
                `QP Single`,
                'Single',
                CASE
                    WHEN `CalcEngine` IN (8, 13) THEN `Term (years)`
                    ELSE `Term Cover`
                END,
                `Joined lives`,
                STR_TO_DATE(`DOC`, '%d-%m-%Y'),
                STR_TO_DATE(`DOB1`, '%d-%m-%Y'),
                IFNULL(STR_TO_DATE(`DOB2`, '%d-%m-%Y'), STR_TO_DATE('{default_date}', '%d-%m-%Y')),
                `optionChild`,
                `optionPremiumWaiver`,
                `optionAccident`,
                'No'
            ),
            `QP Single`
        ),
        0
    ) AS SPWithTI,
    (SELECT `SPWithTI`) / IF(`Terminal Illness` = 'No', 1, 1.03) AS SPadd,
    CASE
        WHEN `CalcEngine` IN (3, 10, 12, 21) THEN 12 * `Insured life 1 SA` *
            CASE
                WHEN `TermOfBenefit` = 0 THEN `Term Cover`
                WHEN `TermOfBenefit` = 99 THEN 85 - TIMESTAMPDIFF(MONTH, STR_TO_DATE(`DOB2`, '%d-%m-%Y'), STR_TO_DATE(`DOC`, '%d-%m-%Y'))
                ELSE `TermOfBenefit`
            END
        ELSE `Insured life 1 SA`
    END AS SumAssuredEnt,
    `Term (years)` AS TermPrem,
    CASE
        WHEN `CalcEngine` IN (8, 13) THEN 100
        ELSE `Term Cover`
    END AS Term,
    CASE
        WHEN `CalcEngine` IN (3, 10, 12, 21) AND `TermOfBenefit` < `Term Cover` AND `TermOfBenefit` > 0 THEN 'Level'
        ELSE
            CASE
                WHEN `Insured life 1 Type` = 'Level' THEN 'Level'
                WHEN `Insured life 1 Type` = 'StraightLine' THEN 'Reducing'
                WHEN `Insured life 1 Type` = 'Annuity' THEN 'Mortgage'
                WHEN `Insured life 1 Type` = 'Annuity Increasing' THEN 'Increasing'
                WHEN `Insured life 1 Type` = 'Linear Increasing' THEN 'Linear'
                ELSE ''
            END
    END AS BenefitType,
    IFNULL(`Policydata_to_Quantum_ORIGINAL`.`Annuity percentage 1`, 0) AS MortgageRate,
    `Insured life 2 SA` AS SumAssuredEnt2,
    CASE
        WHEN `Insured life 2 Type` = 'Level' THEN 'Level'
        WHEN `Insured life 2 Type` = 'StraightLine' THEN 'Reducing'
        WHEN `Insured life 2 Type` = 'Annuity' THEN 'Mortgage'
        WHEN `Insured life 2 Type` = 'Annuity Increasing' THEN 'Increasing'
        WHEN `Insured life 2 Type` = 'Linear Increasing' THEN 'Linear'
        ELSE ''
    END AS BenefitType2,
    IFNULL(`Policydata_to_Quantum_ORIGINAL`.`Annuity percentage 2`, 0) AS MortgageRate2,
    1 AS `Count`,
    IFNULL(`QP` * (SELECT `PremFreq`), 0) AS APWithOptions,
    IFNULL(
        PremWoOptions(
            `QP`,
            `Freq`,
            CASE WHEN `CalcEngine` IN (8, 13) THEN `Term (years)` ELSE `Term Cover` END,
            `Joined lives`,
            STR_TO_DATE(`DOC`, '%d-%m-%Y'),
            STR_TO_DATE(`DOB1`, '%d-%m-%Y'),
            IFNULL(STR_TO_DATE(`DOB2`, '%d-%m-%Y'), STR_TO_DATE('{default_date}', '%d-%m-%Y')),
            `optionChild`,
            `optionPremiumWaiver`,
            `optionAccident`,
            IFNULL(`optionSurrender`, 'No')
        ),
        0
    ) AS APWithTI,
    (SELECT `APWithTI`) / IF(`Terminal Illness` = 'No', 1, 1.03) AS AnnualPremium,
    'False' AS CalcPremium,
    Policydata_to_Quantum_ORIGINAL.`Internal status`,
    Policydata_to_Quantum_ORIGINAL.DOC,
    IFNULL(`Policydata_to_Quantum_ORIGINAL`.`CalcEngine`, 16) AS CalcEngine,
    CASE WHEN `CalcEngine` < 5 THEN 'Yes' ELSE `bGuaranteed Loading` END AS Guarantee,
    Policydata_to_Quantum_ORIGINAL.`Terminal Illness` AS TerminalIllness,
    Policydata_to_Quantum_ORIGINAL.`Type of application` AS ApplicationType,
    CASE
        WHEN `CalcEngine` < 5 OR `CalcEngine` = 6 THEN 0.1
        WHEN `CalcEngine` < 8 THEN 0.06
        WHEN `CalcEngine` IN (14, 15, 16) OR (`CalcEngine` BETWEEN 17 AND 21) THEN 0.03
        WHEN `CalcEngine` IN (22, 23, 25, 26) THEN 0.036
        WHEN `CalcEngine` = 16 OR ISNULL(`CalcEngine`) THEN
            CASE WHEN (SELECT `BenefitType`) = 'Level' THEN 0.03 ELSE 0.05 END
        ELSE 0
    END AS CommissionRP,
    CASE
        WHEN `CalcEngine` < 5 OR `CalcEngine` = 6 THEN 0.12
        WHEN `CalcEngine` < 8 THEN 0.06
        WHEN `CalcEngine` IN (14, 15, 16) OR (`CalcEngine` BETWEEN 17 AND 21) THEN 0.03
        WHEN `CalcEngine` IN (22, 23, 25, 26) THEN 0.036
        WHEN `CalcEngine` = 16 OR ISNULL(`CalcEngine`) THEN
            CASE WHEN (SELECT `BenefitType`) = 'Level' THEN 0.03 ELSE 0.05 END
        ELSE 0
    END AS CommissionSP,
    CASE
        WHEN `CalcEngine` = 5 OR `CalcEngine` = 7 OR (`CalcEngine` BETWEEN 17 AND 26) OR
             ((`CalcEngine` = 16 OR ISNULL(`CalcEngine`)) AND (SELECT `BenefitType`) = 'Level') THEN
            CASE WHEN `Term (years)` < 25 THEN `Term (years)` ELSE 25 END
        ELSE `Term (years)`
    END AS TermComm,
    CASE WHEN `CalcEngine` > 3 OR ISNULL(`CalcEngine`) THEN 0 ELSE 0.025 END AS AddPrem,
    CASE
        WHEN `CalcEngine` < 3 THEN 'HanRe2009_q75r400'
        WHEN `CalcEngine` IN (5, 7, 9) THEN 'NewPricing2010_q75r400'
        WHEN `CalcEngine` = 11 THEN 'NewPricingUnisex_q75r400'
        WHEN `CalcEngine` IN (14, 15, 16) OR ISNULL(`CalcEngine`) THEN 'PricingUnisex2013_q75r400'
        WHEN `CalcEngine` BETWEEN 17 AND 23 THEN 'PricingUnisex2018_q75r400'
        WHEN `CalcEngine` IN (25, 26) THEN 'PricingUnisex2020_q75r400'
        WHEN '{fib_reinsured}' = 'Y' AND (`CalcEngine` IN (3, 10, 12)) THEN
            CASE
                WHEN STR_TO_DATE(`PolicyData_to_Quantum_ORIGINAL`.`DOC`, '%d-%m-%Y') < STR_TO_DATE('01.01.2010', '%d.%m.%Y') THEN 'HanRe2009_q75r400'
                WHEN STR_TO_DATE(`PolicyData_to_Quantum_ORIGINAL`.`DOC`, '%d-%m-%Y') < STR_TO_DATE('01.01.2013', '%d.%m.%Y') THEN 'NewPricing2010_q75r400'
                WHEN STR_TO_DATE(`PolicyData_to_Quantum_ORIGINAL`.`DOC`, '%d-%m-%Y') < STR_TO_DATE('01.01.2014', '%d.%m.%Y') THEN 'NewPricingUnisex_q75r400'
                ELSE 'PricingUnisex2013_q75r400'
            END
        ELSE 'NotReinsured'
    END AS RIModel,
    IFNULL(`Insured Life 1 SA Enddate`, 0) AS SumAssuredEnd,
    CASE WHEN `CalcEngine` IN (8, 13) THEN 0 ELSE IFNULL(`OS 1`, 0) END AS MortLoad1,
    CASE WHEN `CalcEngine` IN (8, 13) THEN 0 ELSE IFNULL(`OS 2`, 0) END AS MortLoad2
FROM Policydata_to_Quantum_ORIGINAL
WHERE
    (Policydata_to_Quantum_ORIGINAL.`Internal status` = 'Issued' OR Policydata_to_Quantum_ORIGINAL.`Internal status` = 'Cleared to issue')
    AND STR_TO_DATE(Policydata_to_Quantum_ORIGINAL.`DOC`, '%d-%m-%Y') < STR_TO_DATE('{date_data_extract}', '%d-%m-%Y')
ORDER BY Policydata_to_Quantum_ORIGINAL.`Policy Nr`;
CREATE INDEX idx_PolNo_Term ON `Monet Inputs Term` (PolNo);