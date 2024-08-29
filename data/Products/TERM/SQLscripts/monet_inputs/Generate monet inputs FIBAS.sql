DROP TABLE IF EXISTS `Monet Inputs FIBAS`;

CREATE TABLE IF NOT EXISTS `Monet Inputs FIBAS` AS
SELECT
    `policy number` AS PolNo,
    TIMESTAMPDIFF(MONTH, STR_TO_DATE(`commencement date`, '%d-%m-%Y'), STR_TO_DATE('{date_data_extract}', '%d-%m-%Y')) AS PeriodIF,
    "Term" AS Product,
    "No" AS Joined,
    sex AS Sex1,
    sex AS Sex2,
    "Netherlands" AS Country,
    AgeNearest(STR_TO_DATE(`date of birth`, '%d-%m-%Y'), STR_TO_DATE(`commencement date`, '%d-%m-%Y')) AS AgeEnt1,
    0 AS AgeEnt2,
    "NonSmoker" AS Smoker1,
    "NonSmoker" AS Smoker2,
    CASE
        WHEN `Premium payment` IN ("Single Premium", "Combination postponed") THEN 99
        ELSE 12
    END AS PremFreq,
    IFNULL(`SP net premium FIB`, 0) AS SPadd,
    (CASE
        WHEN `Premium payment` = "Combination direct" THEN `RP insurance amount`
        ELSE `insurance_amount`
    END) *
    (CASE
        WHEN ISNULL(`benefit_duration_term_life`) OR `benefit_duration_term_life` = "Standard" THEN 0
        WHEN CalcBeneDur(`benefit_duration_term_life`) >=
            (CASE
                WHEN `Premium payment` IN ("Single premium", "Combination postponed") THEN `SP term`
                ELSE `RP term`
            END - 6)
        THEN
            (CASE
                WHEN `Premium payment` IN ("Single premium", "Combination postponed") THEN `SP term`
                ELSE `RP term`
            END)
        WHEN CalcBeneDur(`benefit_duration_term_life`) <
            (CASE
                WHEN `Premium payment` IN ("Single premium", "Combination postponed") THEN `SP term`
                ELSE `RP term`
            END) - TIMESTAMPDIFF(MONTH, STR_TO_DATE(`commencement date`, '%d-%m-%Y'), STR_TO_DATE('{date_data_extract}', '%d-%m-%Y'))
        THEN CalcBeneDur(`benefit_duration_term_life`)
        ELSE
            (CASE
                WHEN `Premium payment` IN ("Single premium", "Combination postponed") THEN `SP term`
                ELSE `RP term`
            END) - TIMESTAMPDIFF(MONTH, STR_TO_DATE(`commencement date`, '%d-%m-%Y'), STR_TO_DATE('{date_data_extract}', '%d-%m-%Y'))
    END) AS SumAssuredEnt,
    ROUND(
        (CASE
            WHEN `Premium payment` IN ("Single premium", "Combination postponed") THEN `SP term`
            ELSE `RP term`
        END) / 12, 0
    ) AS Term,
    (CASE
        WHEN CalcBeneDur(`benefit_duration_term_life`) >=
            (CASE
                WHEN `Premium payment` IN ("Single premium", "Combination postponed") THEN `SP term`
                ELSE `RP term`
            END - 6)
        THEN "Reducing"
        ELSE "Level"
    END) AS BenefitType,
    0 AS MortgageRate,
    0 AS SumAssuredEnt2,
    "Level" AS BenefitType2,
    0 AS MortgageRate2,
    1 AS `Count`,
    IFNULL(`RP net premium FIB`, 0) * 12 AS AnnualPremium,
    "False" AS CalcPremium,
    `Quantum status` AS `Internal status`,
    `commencement date` AS DOC,
    3 AS CalcEngine,
    "Yes" AS Guarantee,
    "No" AS TerminalIllness,
    "Std. Term" AS ApplicationType,
    `benefit_duration_term_life`,
    `insurance_amount`,
    `premium payment`
FROM `{new_db_name}`.`Policies`
WHERE
    (
        (CASE
            WHEN `Premium payment` = "Combination direct" THEN `RP insurance amount`
            ELSE `insurance_amount`
        END) *
        (CASE
            WHEN ISNULL(`benefit_duration_term_life`) OR `benefit_duration_term_life` = "Standard" THEN 0
            WHEN CalcBeneDur(`benefit_duration_term_life`) >=
                (CASE
                    WHEN `Premium payment` IN ("Single premium", "Combination postponed") THEN `SP term`
                    ELSE `RP term`
                END - 6)
            THEN
                (CASE
                    WHEN `Premium payment` IN ("Single premium", "Combination postponed") THEN `SP term`
                    ELSE `RP term`
                END)
            WHEN CalcBeneDur(`benefit_duration_term_life`) <
                (CASE
                    WHEN `Premium payment` IN ("Single premium", "Combination postponed") THEN `SP term`
                    ELSE `RP term`
                END) - TIMESTAMPDIFF(MONTH, STR_TO_DATE(`commencement date`, '%d-%m-%Y'), STR_TO_DATE('{date_data_extract}', '%d-%m-%Y'))
            THEN CalcBeneDur(`benefit_duration_term_life`)
            ELSE
                (CASE
                    WHEN `Premium payment` IN ("Single premium", "Combination postponed") THEN `SP term`
                    ELSE `RP term`
                END) - TIMESTAMPDIFF(MONTH, STR_TO_DATE(`commencement date`, '%d-%m-%Y'), STR_TO_DATE('{date_data_extract}', '%d-%m-%Y'))
        END)
    ) > 0
    AND `Quantum status` = "Active"
    AND STR_TO_DATE(`commencement date`, '%d-%m-%Y') < STR_TO_DATE('{date_data_extract}', '%d-%m-%Y')
ORDER BY `policy number`;
