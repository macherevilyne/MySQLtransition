DROP VIEW IF EXISTS `Q_GenerateBatchMLB`;
CREATE VIEW `Q_GenerateBatchMLB` AS
SELECT 
    `Policies`.`policy number`,
    `Policies`.`product group`,
    `Policies`.`Quantum status`,
    YEAR(STR_TO_DATE(`commencement date`, '%d-%m-%Y')) - YEAR(STR_TO_DATE(`date of birth`, '%d-%m-%Y')) - IF(MONTH(STR_TO_DATE(`commencement date`, '%d-%m-%Y')) < MONTH(STR_TO_DATE(`date of birth`, '%d-%m-%Y')), 1, 0) - IF(MONTH(STR_TO_DATE(`commencement date`, '%d-%m-%Y')) = MONTH(STR_TO_DATE(`date of birth`, '%d-%m-%Y')) AND DAY(STR_TO_DATE(`date of birth`, '%d-%m-%Y')) > 1, 1, 0) AS `Age`,
    ROUND(`total_term` / 12 + 0.49, 0) AS `Term`,
    `Policies`.`insurance_amount`,
    CONCAT(`Policies`.`waiting time`, ' days') AS `waiting time`,
    IF(`Policies`.`benefit_duration` = "Enddate", "Extended", `Policies`.`benefit_duration`) AS `benefit_duration`,
    IF(InStr(`Policies`.`cover code`, "Passend") > 0, "Suitable", IF(InStr(`Policies`.`cover code`, "Eigen") > 0, "Own", "Any")) AS `OccupationDef`,
    IF(InStr(`Policies`.`cover code`, "80%") > 0, "F80", IF(InStr(`Policies`.`cover code`, "volledig") > 0, "F35", "P35")) AS `BenefitDef`,
    `Policies`.`mental diseases`,
    IF(`premium payment` = "Monthly Premium", 1, 3) AS `Freq`,
    IF(`premium payment` = "Single premium", `SP net premium`, `RP net premium`) AS `QP`
FROM 
    `Policies`
WHERE 
    (((`Policies`.`product group`) = "MLB")
    AND ((`Policies`.`Quantum status`) = "Active")
    AND ((`Policies`.`policy terms`) = `AVB: `));