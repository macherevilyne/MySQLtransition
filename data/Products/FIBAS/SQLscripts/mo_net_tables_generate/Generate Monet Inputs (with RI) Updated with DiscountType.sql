DROP TABLE IF EXISTS `MonetInputsUpdated`;
CREATE TABLE IF NOT EXISTS `MonetInputsUpdated` AS
SELECT 
    `Policies`.`policy number` AS `PolNo`,
    `Policies`.`Quantum status` AS `FibStat`,
    @PeriodIF := TIMESTAMPDIFF(MONTH,STR_TO_DATE(`Policies`.`commencement date`, '%d-%m-%Y'),STR_TO_DATE('{ValDat}', '%d-%m-%Y')) AS `PeriodIF`,
    1 AS `Count`,
    `Policies`.`commencement date`,
    @Status := IF(ISNULL(`MonetInputsClaimsUpdated`.`PolNo`),"active","disable") AS `Status`,
    @Product:= IF(`policies`.`product`="TAF Maandlastbeschermer Zelfstandige","ZSP",`policies`.`product group`) AS `product`,
    @book := (
        CASE
            WHEN Policies.product = 'TAF GoedGezekerd AOV' THEN
                CASE
                    WHEN Policies.`policy terms` = 'QL_GG_03_2015' THEN 2015
                    WHEN Policies.`policy terms` IN ('QL_GG_2020_06', 'QL_MLBZ_2022_02') THEN 2020
                    ELSE 2012
                END
            ELSE
                CASE
                    WHEN Policies.product LIKE '%2010' THEN 2010
                    WHEN Policies.product LIKE '%2011' THEN 2011
                    WHEN Policies.`policy terms` = 'QL_MLB_12_2012' THEN 2011
                    WHEN Policies.`policy terms` IN ('QL_MLBK_03_2014', 'QL_MLBK_11_2015') THEN 2014
                    WHEN Policies.`policy terms` IN ('QL_MLB_06_2019', 'QL_MLB_2021_02', 'QL_MLB_2021_11') THEN 2019
                    WHEN Policies.`policy terms` = "QL_MLBZ_2022_02" THEN 2020
                    WHEN Policies.`policy terms` = "QL_MLB_2022_12" THEN 2022
                    WHEN Policies.`policy terms` = "QL_IZ_2023_05" THEN 2023
                    ELSE 200809 
                END 
        END
    ) AS `book`,
    "Netherlands" AS `Country`,
    YEAR(STR_TO_DATE(`Policies`.`commencement date`, '%d-%m-%Y'))-YEAR(STR_TO_DATE(`Policies`.`date of birth`, '%d-%m-%Y')) AS `AgeEnt1`,
    0 AS `AgeEnt2`,
    `Policies`.`sex` AS `Sex1`,
    "" AS `Sex2`,
    "NonSmoker" AS `Smoker1`,
    "" AS `Smoker2`,
    `Policies`.`work situation` AS `WorkSituation`,
    `Policies`.`house holder` AS `ProperHouse`,
    IFNULL(Policies.`professional class`, 5) AS `ProfessionalClass`,
    @Term := (
        CASE
            WHEN @Status = 'disable' THEN MonetInputsClaimsUpdated.Term
            WHEN IFNULL(Policies.`total_term`, 0) = 0 THEN 12 * 65 - TIMESTAMPDIFF(MONTH,STR_TO_DATE(`Date of birth`, '%d-%m-%Y'),STR_TO_DATE(`Policies`.`commencement date`, '%d-%m-%Y'))
            ELSE Policies.`total_term`
        END) AS `Term`,
    IF(`Premium payment`="Combination postponed",TIMESTAMPDIFF(MONTH,STR_TO_DATE(`Policies`.`commencement date`, '%d-%m-%Y'),STR_TO_DATE(`RP_commencement_date`, '%d-%m-%Y')),0) AS `StartMthMP`,
    "AS" AS `BenefitType`,
    `Policies`.`waiting time` AS `WaitingTime`,
    CASE
        WHEN LOCATE('12 months', Policies.`benefit_duration`) > 0 OR LOCATE('24 months', Policies.`benefit_duration`) > 0 THEN 'Short'
        WHEN LOCATE('36 months', Policies.`benefit_duration`) > 0 OR LOCATE('48 months', Policies.`benefit_duration`) > 0 OR LOCATE('60 months', Policies.`benefit_duration`) > 0 OR LOCATE('72 months', Policies.`benefit_duration`) > 0 OR LOCATE('84 months', Policies.`benefit_duration`) > 0 THEN 'Basic'
        ELSE IF(LOCATE('96 months', Policies.`benefit_duration`) > 0 OR LOCATE('108 months', Policies.`benefit_duration`) > 0 OR LOCATE('120 months', Policies.`benefit_duration`) > 0 OR Policies.`benefit_duration` = 'Enddate', 'Extended', Policies.`benefit_duration`)
    END AS `BeneDuration`,
    CASE
        WHEN Policies.`benefit_duration` = 'Extended' OR Policies.`benefit_duration` = 'Enddate' THEN @Term
        WHEN Policies.`benefit_duration` = 'Basic' THEN 60
        WHEN Policies.`benefit_duration` = 'Short' THEN 24
        WHEN CAST(LEFT(Policies.`benefit_duration`, 2) AS SIGNED) < 12 OR LEFT(Policies.`benefit_duration`, 3) = '120' THEN CAST(LEFT(Policies.`benefit_duration`, 3) AS SIGNED)
        ELSE CAST(LEFT(Policies.`benefit_duration`, 2) AS SIGNED)
    END AS BeneDurMth,
    `Policies`.`insurance_amount` AS `SumAssuredEnt`,
    IFNULL(Policies.`SP net premium`, 0) AS `SPadd`,
    ROUND(IF(ISNULL(`Policies`.`RP net premium`),0,IF(`Policies`.`premium payment`="Yearly premium",`Policies`.`RP net premium`/12,`Policies`.`RP net premium`)+IF(ISNULL(`Policies`.`En Block 2011`),0,`Policies`.`En Block 2011`)), 10) AS `MonthlyPremium`,
    CASE
        WHEN Policies.`Premium payment` = 'Single premium' THEN 99
        ELSE 12
    END AS `PremFreq`,
    IF(InStr(`Policies`.`Cover code`,"Passend"),"Suitable",
        IF(InStr(`Policies`.`Cover code`,"Eigen")>0,"Own","Any")) AS `DisableDef`,
    IF(`Policy number`=8087463,"P25",
            IF(InStr(`Policies`.`Cover code`,"80%")>0,"P80",
                IF(InStr(`Policies`.`Cover code`,"65%")>0,"P65",
                    IF(InStr(`Policies`.`Cover code`,"55%")>0,"P55",
                        IF(InStr(`Policies`.`Cover code`,"45%")>0,"P45",
                            IF(InStr(`Policies`.`Cover code`,"volledige")>0,
                                IF(InStr(`Policies`.`Cover code`,"25%")>0,"F25","F35"),
                                    IF(InStr(`Policies`.`Cover code`,"25%")>0,"P25","P35"))))))) AS `BenefitDef`,
    ROUND(IF(@book=200809 And @product="ZSP" And (ISNULL(`MonetInputsClaimsUpdated`.`Status`) Or NOT `MonetInputsClaimsUpdated`.`Status`="disable" Or `MonetInputsClaimsUpdated`.`PeriodDisable`<TIMESTAMPDIFF(MONTH,STR_TO_DATE('01.09.2011', '%d.%m.%Y'),STR_TO_DATE('{ValDat}', '%d-%m-%Y'))),12,IF(@book in (2012, 2015, 2020, 2023),12,24)), 0) AS `MthOwnOccupation`,
    IF(@book=2010 Or (`Policies`.`product group`="MLB" And (@book<2019 Or @book=200809)) Or (@status="disable" And `PeriodDisable`>=TIMESTAMPDIFF(MONTH,STR_TO_DATE('01.09.2011', '%d.%m.%Y'),STR_TO_DATE('{ValDat}', '%d-%m-%Y'))),"Occupation","Immediate") AS `MethPartial`,
    `Policies`.`mental diseases`,
    IF(@book=200809,
        IF(@product="MLB","Yes","Restricted"),
            IF(@book=2010,"Yes",`mental diseases`)) AS Mental,
    IF(@book in (2011, 2012, 2014, 2015, 2019, 2020, 2022, 2023),"Yes","No") AS `WoP`,
     `Policies`.`cover code`,
    0 AS `MortgageRate`,
    "new" AS `producttype`,
    IF(ISNULL(`indexation percentage`),0,`indexation percentage`) AS `Index`,
    0 AS `CalcPremium`,
    IF(@book in (2012, 2015),
            IF(@PeriodIF<12,0.7,
                IF(@PeriodIF<24,0.8,
                    IF(@PeriodIF<36,0.9,1))),
            IF(@book in (2020, 2023),
                IF(@book=2020 AND @PeriodIF<12 AND NOT `policies`.`discount`="ongoing",0.8,
                    IF(@book=2023 AND @PeriodIF<12 AND NOT `policies`.`discount`="ongoing",0.65,1)),1)) AS `Discount`,
    IF(ISNULL(`MonetInputsClaimsUpdated`.`PeriodDisable`),0,`MonetInputsClaimsUpdated`.`PeriodDisable`) AS `PeriodDisable`,
    IF(ISNULL(`MonetInputsClaimsUpdated`.`PercentageDisable`),0,`MonetInputsClaimsUpdated`.`PercentageDisable`) AS `PercentageDisable`,
    IF(ISNULL(`MonetInputsClaimsUpdated`.`MonthlyBenefit`),0,`MonetInputsClaimsUpdated`.`MonthlyBenefit`) AS `MonthlyBenefit`,
    IF(ISNULL(`MonetInputsClaimsUpdated`.`ClaimReserveValDate`),0,`MonetInputsClaimsUpdated`.`ClaimReserveValDate`) AS `ClaimReserveValDate`,
    @OccurrenceYear := IF(ISNULL(`MonetInputsClaimsUpdated`.`OccurrenceYear`),0,`MonetInputsClaimsUpdated`.`OccurrenceYear`) AS `OccurrenceYear`,
    IF(@OccurrenceYear>2015 Or @OccurrenceYear=0,IF(@book in (2019, 2020, 2022, 2023), "FIBAS18_q85","FIBAS14_q85"),"NotReinsured") AS `RIModel`,
    IF(`rate_type`="Combi","Yes","No") AS `CombiRate`,
    CASE
        WHEN Policies.discount = "ongoing" THEN "ongoing"
        ELSE "upfront"
    END AS `DiscountType`
FROM `Policies` LEFT JOIN `MonetInputsClaimsUpdated` ON `Policies`.`policy number` = `MonetInputsClaimsUpdated`.`PolNo`
WHERE ((((`Policies`.`Quantum status`)="Active")
           And ((STR_TO_DATE(`Policies`.`commencement date`, '%d-%m-%Y'))<STR_TO_DATE('{ValDat}', '%d-%m-%Y'))
           And ((IF(`policies`.`product`="TAF Maandlastbeschermer Zelfstandige","ZSP",`policies`.`product group`))<>"WW"))
        Or (((STR_TO_DATE(`Policies`.`commencement date`, '%d-%m-%Y'))<STR_TO_DATE('{ValDat}', '%d-%m-%Y'))
            And ((IF(ISNULL(`MonetInputsClaimsUpdated`.`PolNo`),"active","disable"))="disable")
            And ((IF(`policies`.`product`="TAF Maandlastbeschermer Zelfstandige","ZSP",`policies`.`product group`))<>"WW")))
ORDER BY `Policies`.`policy number`;