DROP TABLE IF EXISTS `MonetInputsPossClaims`;
CREATE TABLE IF NOT EXISTS `MonetInputsPossClaims` AS
SELECT `Policies`.`policy number` AS `PolNo`,
CAST(Right(`Claims`.`claim_id`,4)AS SIGNED) AS `ClaimNr`,
`Policies`.`Quantum status` AS `FibStat`,
TIMESTAMPDIFF(MONTH,STR_TO_DATE(`Policies`.`commencement date`, '%d-%m-%Y'),STR_TO_DATE('{ValDat}', '%d-%m-%Y')) AS `PeriodIF`,
0.75 AS `Count`, 
`Policies`.`commencement date`, 
IF(ISNULL(`Claims`.`eerste_polis_nummer`),"active",
    IF((`Claims`.`status`="ENTERED"
        Or `Claims`.`status`="WAITING_FOR_INFORMATION"
        Or `Claims`.`status`="OWN_RISK_PERIOD"
        Or `Claims`.`status`="EMPLOYMENT_EVALUATION"
        Or `Claims`.`status`="PRE_SCREENING")
    And `Claims`.`claim_type`="DISABILITY"
    And (ISNULL(STR_TO_DATE(`Claims`.`betaling_eind_datum`, '%d-%m-%Y')) Or STR_TO_DATE(`Claims`.`betaling_eind_datum`, '%d-%m-%Y')>=STR_TO_DATE('{ValDat}', '%d-%m-%Y')),"disable","active")) AS `Status`,
`Claims`.`betaling_eind_datum`,
`Policies`.`product group` AS `product`,
IF(`Policies`.`product`="TAF GoedGezekerd AOV",
    IF(`Policies`.`policy terms`="QL_GG_03_2015",2015,
        IF(`Policies`.`policy terms`="QL_GG_2020_06" Or `Policies`.`policy terms`="QL_MLBZ_2022_02",2020,2012)),
            IF(`Policies`.`product` Like "%2010",2010,
                IF(`Policies`.`product` Like "%2011" Or `Policies`.`policy terms`="QL_MLB_12_2012",2011,
                    IF(`Policies`.`policy terms`="QL_MLBK_03_2014" Or `Policies`.`policy terms`="QL_MLBK_11_2015",2014,
                        IF(`Policies`.`policy terms`="QL_MLB_06_2019" Or `Policies`.`policy terms`="QL_MLB_2021_02" Or `Policies`.`policy terms`="QL_MLB_2021_11",2019,200809))))) AS `book`,
"Netherlands" AS `Country`,
YEAR(STR_TO_DATE(`Policies`.`commencement date`, '%d-%m-%Y'))-YEAR(STR_TO_DATE(`Policies`.`date of birth`, '%d-%m-%Y')) AS `AgeEnt1`,
0 AS `AgeEnt2`, 
`Policies`.`sex` AS `Sex1`, 
"" AS `Sex2`, 
"NonSmoker" AS `Smoker1`, 
"" AS `Smoker2`, 
`Policies`.`work situation` AS `WorkSituation`, 
`Policies`.`house holder` AS `ProperHouse`, 
IF(ISNULL(`professional class`),5,`professional class`) AS `ProfessionalClass`, 
IF(ISNULL(`total_term`) Or `total_term`=0,12*65-TIMESTAMPDIFF(MONTH,STR_TO_DATE(`Date of birth`, '%d-%m-%Y'),STR_TO_DATE(`Commencement date`, '%d-%m-%Y')),`total_term`) AS `Term`,
IF(`Premium payment`="Combination postponed",TIMESTAMPDIFF(MONTH,`Policies`.`commencement date`,`Policies`.`RP_commencement_date`),0) AS `StartMthMP`,
"AS" AS `BenefitType`, 
`Policies`.`waiting time` AS `WaitingTime`, 
IF(InStr(`Policies`.`benefit_duration`,"12 months")>0 Or InStr(`Policies`.`benefit_duration`,"24 months")>0,"Short",
    IF(InStr(`Policies`.`benefit_duration`,"36 months")>0
        Or InStr(`Policies`.`benefit_duration`,"48 months")>0
        Or InStr(`Policies`.`benefit_duration`,"60 months")>0
        Or InStr(`Policies`.`benefit_duration`,"72 months")>0
        Or InStr(`Policies`.`benefit_duration`,"84 months")>0,"Basic",
            IF(InStr(`Policies`.`benefit_duration`,"96 months")>0
                Or InStr(`Policies`.`benefit_duration`,"108 months")>0
                Or InStr(`Policies`.`benefit_duration`,"120 months")>0
                Or `Policies`.`benefit_duration`="Enddate","Extended",`Policies`.`benefit_duration`))) AS `BeneDuration`,
IF(`Policies`.`benefit_duration`="Extended" Or `Policies`.`benefit_duration`="Enddate", (SELECT `Term`),
    IF(`Policies`.`benefit_duration`="Basic",60,
        IF(`Policies`.`benefit_duration`="Short",24,
            IF(ROUND(Left(`Policies`.`benefit_duration`,2))<12 Or Left(`Policies`.`benefit_duration`,3)="120",ROUND(Left(`Policies`.`benefit_duration`,3)),ROUND(Left(`Policies`.`benefit_duration`,2)))))) AS `BeneDurMth`,
`Policies`.`insurance_amount` AS `SumAssuredEnt`,
IF(ISNULL(`SP net premium`),0,`SP net premium`) AS `SPadd`,
IF(ISNULL(`RP net premium`),0,
    IF(`Premium payment`="Yearly premium",`RP net premium`/12,`RP net premium`)+IF(ISNULL(`En Block 2011`),0,`En Block 2011`)) AS `MonthlyPremium`,
IF(`Premium payment`="Single premium",99,12) AS `PremFreq`,
IF(InStr(`Cover code`,"Passend") Or '{producttype}'="old","Suitable",
    IF(InStr(`Cover code`,"Eigen")>0,"Own","Any")) AS `DisableDef`,
IF('{producttype}'="old",Right(`Policies`.`Cover code`,3),
    IF(InStr(`Policies`.`Cover code`,"80%")>0,"P80",
        IF(InStr(`Policies`.`Cover code`,"65%")>0,"P65",
            IF(InStr(`Policies`.`Cover code`,"55%")>0,"P55",
                IF(InStr(`Policies`.`Cover code`,"45%")>0,"P45",
                    IF(InStr(`Policies`.`Cover code`,"volledige")>0,
                        IF(InStr(`Policies`.`Cover code`,"25%")>0,"F25","F35"),
                            IF(InStr(`Policies`.`Cover code`,"25%")>0,"P25","P35"))))))) AS `BenefitDef`,
IF((SELECT `book`)=200809 And `Policies`.`product group`="ZSP" And STR_TO_DATE(`eigen_risico_start_datum`, '%d-%m-%Y')>STR_TO_DATE('01.09.2011', '%d.%m.%Y'),12,
    IF((SELECT `book`)=2012 Or (SELECT `book`)=2015 Or (SELECT `book`)=2020,12,24)) AS `MthOwnOccupation`,
IF((SELECT `book`)=2010 Or (`Policies`.`product group`="MLB" And ((SELECT `book`)<2019 Or (SELECT `book`)=200809)) Or STR_TO_DATE(`eigen_risico_start_datum`, '%d-%m-%Y')<=STR_TO_DATE('01.09.2011', '%d.%m.%Y'),"Occupation","Immediate") AS `MethPartial`,
`Policies`.`mental diseases`,
    IF((SELECT `book`)=200809,
        IF(`Policies`.`product group`="MLB","Yes","Restricted"),
            IF((SELECT `book`)=2010,"Yes",`mental diseases`)) AS `Mental`,
IF((SELECT `book`)=2011 Or (SELECT `book`)=2012 Or (SELECT `book`)=2014 Or (SELECT `book`)=2015 Or (SELECT `book`)=2019 Or (SELECT `book`)=2020,"Yes","No") AS `WoP`,
`Policies`.`cover code`, 0 AS `MortgageRate`,
"new" AS `producttype`,
IF(ISNULL(`indexation percentage`),0,`indexation percentage`) AS `Index`,
0 AS `CalcPremium`,
IF((SELECT `book`)=2012 Or (SELECT `book`)=2015,
    IF((SELECT `PeriodIF`)<12,0.7,
        IF((SELECT `PeriodIF`)<24,0.8,
            IF((SELECT `PeriodIF`)<36,0.9,1))),
                IF((SELECT `book`)=2020,
                    IF((SELECT `PeriodIF`)<12,0.8,1),1)) AS `Discount`,
TIMESTAMPDIFF(MONTH,STR_TO_DATE(`eigen_risico_start_datum`, '%d-%m-%Y'),STR_TO_DATE('{ValDat}', '%d-%m-%Y')) AS `PeriodDisable`,
IF(ISNULL(`ClaimsBasic`.`arbeidsongeschiktheid_percentage` Or `ClaimsBasic`.`arbeidsongeschiktheid_percentage`=0),100,`ClaimsBasic`.`arbeidsongeschiktheid_percentage`) AS `PercentageDisable`,
`ClaimsBasic`.`totaal_uit_te_keren_bedrag` AS `MonthlyBenefit`,
`Claims`.`reserveringen_openstaand` AS `ClaimReserveValDate`,
`Claims`.`status` AS `ClaimsStat`,
IF(ISNULL(`Claims`.`eerste_polis_nummer`),"active",
    IF((`Claims`.`status`="ENTERED" Or `Claims`.`status`="WAITING_FOR_INFORMATION" Or `Claims`.`status`="OWN_RISK_PERIOD" Or `Claims`.`status`="EMPLOYMENT_EVALUATION" Or `Claims`.`status`="PRE_SCREENING") And `Claims`.`claim_type`="DISABILITY","disable","active")) AS `Expr1`,
Year(STR_TO_DATE(`eigen_risico_start_datum`, '%d-%m-%Y')) AS `OccurrenceYear`,
IF((SELECT `OccurrenceYear`)>=2016,
    IF((SELECT `book`)=2019 Or (SELECT `book`)=2020,"FIBAS18_q85_int15","FIBAS14_q85_int15"),"NotReinsured") AS `RIModel`,
IF(`rate_type`="Combi","Yes","No") AS `CombiRate`

FROM `Policies` LEFT JOIN (
    `Claims` LEFT JOIN `ClaimsBasic` ON `Claims`.`claim_id` = `ClaimsBasic`.`claim_id`) ON `Policies`.`policy number` = `Claims`.`eerste_polis_nummer`
WHERE (((
    `Policies`.`Quantum status`)="Active")
    And ((STR_TO_DATE(`Policies`.`commencement date`, '%d-%m-%Y'))<STR_TO_DATE('{ValDat}', '%d-%m-%Y'))
    And ((`Policies`.`product group`)<>"WW")
    And ((IF(ISNULL(`Claims`.`eerste_polis_nummer`),"active",
        IF((`Claims`.`status`="ENTERED" Or `Claims`.`status`="WAITING_FOR_INFORMATION" Or `Claims`.`status`="OWN_RISK_PERIOD" Or `Claims`.`status`="EMPLOYMENT_EVALUATION" Or `Claims`.`status`="PRE_SCREENING")
    And `Claims`.`claim_type`="DISABILITY"
    And (ISNULL(`Claims`.`betaling_eind_datum`) Or STR_TO_DATE(`Claims`.`betaling_eind_datum`, '%d-%m-%Y')>=STR_TO_DATE('{ValDat}', '%d-%m-%Y')),"disable","active")))="disable"
    And (IF(ISNULL(`Claims`.`eerste_polis_nummer`),"active",
        IF((`Claims`.`status`="ENTERED" Or `Claims`.`status`="WAITING_FOR_INFORMATION" Or `Claims`.`status`="OWN_RISK_PERIOD" Or `Claims`.`status`="EMPLOYMENT_EVALUATION" Or `Claims`.`status`="PRE_SCREENING")
    And `Claims`.`claim_type`="DISABILITY"
    And (ISNULL(`Claims`.`betaling_eind_datum`) Or STR_TO_DATE(`Claims`.`betaling_eind_datum`, '%d-%m-%Y')>=STR_TO_DATE('{ValDat}', '%d-%m-%Y')),"disable","active")))="disable"));