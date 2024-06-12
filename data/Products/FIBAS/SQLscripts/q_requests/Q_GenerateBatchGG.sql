DROP VIEW IF EXISTS `Q_GenerateBatchGG`;
CREATE VIEW `Q_GenerateBatchGG` AS
SELECT 
    `Policies`.`policy number`,
    `Policies`.`product`,
    `Policies`.`Quantum status`,
    `Policies`.`insurance_amount`,
    YEAR(STR_TO_DATE(`commencement date`, '%d-%m-%Y')) - YEAR(STR_TO_DATE(`date of birth`, '%d-%m-%Y')) - IF(MONTH(STR_TO_DATE(`commencement date`, '%d-%m-%Y')) < MONTH(STR_TO_DATE(`date of birth`, '%d-%m-%Y')), 1, 0) - IF(MONTH(STR_TO_DATE(`commencement date`, '%d-%m-%Y')) = MONTH(STR_TO_DATE(`date of birth`, '%d-%m-%Y')) AND DAY(STR_TO_DATE(`date of birth`, '%d-%m-%Y')) > 1, 1, 0) AS `Age`,
    ROUND(`total_term` / 12 + 0.49, 0) AS `Term`,
    `Policies`.`benefit_duration`,
    `Policies`.`professional class`,
    `Policies`.`waiting time`,
    IF(InStr(`Policies`.`cover code`, "Passend") > 0, "Suitable", IF(InStr(`Policies`.`cover code`, "Eigen") > 0, "Own", "Any")) AS `OccupationDef`,
    IF(InStr(`Policies`.`cover code`, "80%") > 0, "P80", IF(InStr(`Policies`.`cover code`, "65%") > 0, "P65", IF(InStr(`Policies`.`cover code`, "55%") > 0, "P55", IF(InStr(`Policies`.`cover code`, "45%") > 0, "P45", IF(InStr(`Policies`.`cover code`, "35%") > 0, "P35", IF(InStr(`Policies`.`cover code`, "25%") > 0, "P25", "ERROR")))))) AS `BenefitDef`,
    IF(`indexation type` = "NO_INDEXATION", "No", "Yes") AS `Index`, 
    `Policies`.`mental diseases`,
    `Policies`.`premium payment`,
    TIMESTAMPDIFF(MONTH, STR_TO_DATE(`commencement date`, '%d-%m-%Y'), STR_TO_DATE('{ValDat}', '%d-%m-%Y')) AS `PeriodIF`,
    `Policies`.`RP net premium`
FROM 
    `Policies`
WHERE 
    (((`Policies`.`product`) = "TAF GoedGezekerd AOV") AND ((`Policies`.`Quantum status`) = "Active"));