DROP VIEW IF EXISTS `Q_Gothaer`;
CREATE VIEW `Q_Gothaer` AS
SELECT 
    `Policies`.`policy number`,
    `Policies`.`policy terms`,
    `Policies`.`Quantum status`,
    YEAR(STR_TO_DATE('01.04.2020', '%d.%m.%Y')) - YEAR(STR_TO_DATE(`Policies`.`date of birth`, '%d-%m-%Y')) AS `Age`,
    ROUND(TIMESTAMPDIFF(MONTH, STR_TO_DATE('01.04.2020', '%d.%m.%Y'), DATE_ADD(STR_TO_DATE(`Policies`.`commencement date`, '%d-%m-%Y'), INTERVAL `Policies`.`total_term` MONTH)) / 12 + 0.49999, 0) AS `Term`,
    0 AS `amount`,
    `Policies`.`Insured amount WW` AS `amount_unemployment`,
    `Policies`.`waiting time`,
    `Policies`.`benefit_duration`,
    "2 years" AS `bene_duration_unemp`,
    "Suitable" AS `OccupationDef`,
    "P35" AS `CoverageDef`,
    `Policies`.`mental diseases`, 
    1 AS `premium_payment`,
    `Policies`.`WW`,
    `Policies`.`RP net premium WW`
FROM 
    `Policies`
WHERE 
    (((`Policies`.`policy terms`) <> "QL_MLB_06_2019"
    AND (`Policies`.`policy terms`) <> "QL_MLB_2021_02"
    AND (`Policies`.`policy terms`) <> "QL_MLB_2021_11")
    AND (`Policies`.`Quantum status`) = "Active"
    AND (`Policies`.`WW`) = "yes"));