DROP TABLE IF EXISTS MonetInputsClaimsUpdated;
CREATE TABLE IF NOT EXISTS MonetInputsClaimsUpdated AS
SELECT
    `Policies`.`policy number` AS `PolNo`,
    `Policies`.`Quantum status` AS `FibStat`,
    TIMESTAMPDIFF(MONTH,STR_TO_DATE(`Policies`.`commencement date`, '%d-%m-%Y'),STR_TO_DATE('{ValDat}', '%d-%m-%Y')) AS `PeriodIF`,
    1 AS `Count`,
    `Policies`.`commencement date`,
    IF(ISNULL(`Claims`.`eerste_polis_nummer`),"active",
        IF((`Claims`.`status` Like "PAYMENT%" Or `Claims`.`status`="EMPLOYMENT_REEVALUATION" Or `Claims`.`status`="INSURER_ASSESSMENT" Or `Claims`.`status`="INSURER_REASSESSMENT" Or `Claims`.`status`="PREPARED_FOR_ACCEPTANCE")
        And `Claims`.`claim_type`="DISABILITY"
        And (ISNULL(STR_TO_DATE(`ClaimsBasic`.`betaling_eind_datum`, '%d-%m-%Y')) Or STR_TO_DATE(`ClaimsBasic`.`betaling_eind_datum`, '%d-%m-%Y')>=STR_TO_DATE('{ValDat}', '%d-%m-%Y')),"disable","active")) AS `Status`,
    `ClaimsBasic`.`betaling_eind_datum`,
    `Policies`.`product group` AS `product`,
    "Netherlands" AS `Country`,
    YEAR(STR_TO_DATE(`Policies`.`commencement date`, '%d-%m-%Y'))-YEAR(STR_TO_DATE(`Policies`.`date of birth`, '%d-%m-%Y')) AS `AgeEnt1`,
    0 AS `AgeEnt2`,
    `Policies`.`sex` AS `Sex1`,
    "" AS Sex2,
    "NonSmoker" AS `Smoker1`,
    "" AS `Smoker2`,
    `Policies`.`work situation` AS `WorkSituation`,
    `Policies`.`house holder` AS `ProperHouse`,
    `Policies`.`professional class` AS `ProfessionalClass`,
    IF(`total_term`<TIMESTAMPDIFF(MONTH, STR_TO_DATE(`Policies`.`commencement date`, '%d-%m-%Y'),STR_TO_DATE(`ClaimsBasic`.`betaling_eind_datum`, '%d-%m-%Y')),
                    TIMESTAMPDIFF(MONTH, STR_TO_DATE(`Policies`.`commencement date`, '%d-%m-%Y'),STR_TO_DATE(`ClaimsBasic`.`betaling_eind_datum`, '%d-%m-%Y')),`total_term`) AS `Term`,
    IF(`Premium payment`="Combination postponed",TIMESTAMPDIFF(MONTH, STR_TO_DATE(`Policies`.`commencement date`, '%d-%m-%Y'),STR_TO_DATE(`Policies`.`RP_commencement_date`, '%d-%m-%Y')),0) AS `StartMthMP`,
    "AS" AS `BenefitType`,
    `Policies`.`waiting time` AS `WaitingTime`,
    IF(InStr(`Policies`.`benefit_duration`,"12 months")>0 Or InStr(`Policies`.`benefit_duration`,"24 months")>0,"Short",
        IF(InStr(`Policies`.`benefit_duration`,"36 months")>0 Or InStr(`Policies`.`benefit_duration`,"48 months")>0 Or InStr(`Policies`.`benefit_duration`,"60 months")>0 Or InStr(`Policies`.`benefit_duration`,"72 months")>0 Or InStr(`Policies`.`benefit_duration`,"84 months")>0,"Basic",
            IF(InStr(`Policies`.`benefit_duration`,"96 months")>0 Or InStr(`Policies`.`benefit_duration`,"108 months")>0 Or InStr(`Policies`.`benefit_duration`,"120 months")>0 Or `Policies`.`benefit_duration`="Enddate","Extended",`Policies`.`benefit_duration`))) AS `BeneDuration`,
    IF(`Policies`.`benefit_duration`="Extended" Or `Policies`.`benefit_duration`="Enddate", (SELECT `Term`),
        IF(`Policies`.`benefit_duration`="Basic",60,
            IF(`Policies`.`benefit_duration`="Short",24,
                IF(ROUND(Left(`Policies`.`benefit_duration`,2))<12 Or Left(`Policies`.`benefit_duration`,3)="120",ROUND(Left(`Policies`.`benefit_duration`,3)),ROUND(Left(`Policies`.`benefit_duration`,2)))))) AS `BeneDurMth`,
    `Policies`.`insurance_amount` AS `SumAssuredEnt`,
    IF(ISNULL(`Policies`.`SP net premium`),0,`Policies`.`SP net premium`) AS `SPadd`,
    IF(ISNULL(`RP net premium`),0,
        IF(`Premium payment`="Yearly premium",`Policies`.`RP net premium`/12,`Policies`.`RP net premium`))+IF(ISNULL(`En Block 2011`),0,`En Block 2011`) AS `MonthlyPremium`,
    IF(`Premium payment`="Single premium",99,12) AS `PremFreq`,
    IF(InStr(`Policies`.`cover code`,"Passend"),"Suitable",
        IF(InStr(`Policies`.`cover code`,"Eigen"),"Own","Any")) AS `DisableDef`,
    IF(InStr(`Policies`.`cover code`,"80%")>0,"P80",
        IF(InStr(`Policies`.`cover code`,"65%")>0,"P65",
            IF(InStr(`Policies`.`cover code`,"55%")>0,"P55",
                IF(InStr(`Policies`.`cover code`,"45%")>0,"P45",
                    IF(InStr(`Policies`.`cover code`,"volledige")>0,
                        IF(InStr(`Policies`.`cover code`,"25%")>0,"F25","F35"),
                            IF(InStr(`Policies`.`cover code`,"25%")>0,"P25","P35")))))) AS `BenefitDef`,
    `Policies`.`cover code`,
    0 AS `MortgageRate`,
    "new" AS `producttype`,
    0 AS `CalcPremium`,
    IF(PERIOD_DIFF(DATE_FORMAT(STR_TO_DATE('{ValDat}', '%d-%m-%Y'), "%Y%m"), DATE_FORMAT(STR_TO_DATE(`ClaimsBasic`.`eigen_risico_start_datum`, '%d-%m-%Y'), "%Y%m"))>120,120,PERIOD_DIFF(DATE_FORMAT(STR_TO_DATE('{ValDat}', '%d-%m-%Y'), "%Y%m"), DATE_FORMAT(STR_TO_DATE(`ClaimsBasic`.`eigen_risico_start_datum`, '%d-%m-%Y'), "%Y%m"))) AS `PeriodDisable`,
    IF(ISNULL(`ClaimsBasic`.`AO-%`) Or `ClaimsBasic`.`AO-%`=0,100,`ClaimsBasic`.`AO-%`) AS `PercentageDisable`,
    `ClaimsBasic`.`totaal_uit_te_keren_bedrag` AS `MonthlyBenefit`,
    `Claims`.`reserveringen_openstaand` AS `ClaimReserveValDate`,
    YEAR(STR_TO_DATE(`ClaimsBasic`.`eigen_risico_start_datum`, '%d-%m-%Y')) AS `OccurrenceYear`,
    "Unused" AS `RIModel`
FROM (`Policies` LEFT JOIN `Claims` ON `Policies`.`policy number` = `Claims`.`eerste_polis_nummer`)
    LEFT JOIN `ClaimsBasic` ON `Claims`.`claim_id` = `ClaimsBasic`.`claim_id`
WHERE (((STR_TO_DATE(`Policies`.`commencement date`, '%d-%m-%Y'))<STR_TO_DATE('{ValDat}', '%d-%m-%Y'))
    And ((IF(ISNULL(`Claims`.`eerste_polis_nummer`),"active",
            IF((`Claims`.`status` Like "PAYMENT%" Or
                `Claims`.`status`="EMPLOYMENT_REEVALUATION" Or
                `Claims`.`status`="INSURER_ASSESSMENT" Or
                `Claims`.`status`="INSURER_REASSESSMENT" Or
                `Claims`.`status`="PREPARED_FOR_ACCEPTANCE")
                And `Claims`.`claim_type`="DISABILITY"
                And (ISNULL(STR_TO_DATE(`Claims`.`betaling_eind_datum`, '%d-%m-%Y'))
                    Or STR_TO_DATE(`Claims`.`betaling_eind_datum`, '%d-%m-%Y')>=STR_TO_DATE('{ValDat}', '%d-%m-%Y')),"disable","active")))="disable")
    And ((`Policies`.`product group`)<>"WW"));