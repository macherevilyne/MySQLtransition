DROP VIEW IF EXISTS `Q_PoliciesForPremiumCheck`;
CREATE VIEW `Q_PoliciesForPremiumCheck` AS
SELECT 
    `Policies`.`policy number`,
    `Policies`.`policy terms`,
    `Policies`.`Quantum status`,
    `Policies`.`insurance_amount`,
    YEAR(STR_TO_DATE(`commencement date`, '%d-%m-%Y')) - YEAR(STR_TO_DATE(`date of birth`, '%d-%m-%Y')) - IF(MONTH(STR_TO_DATE(`commencement date`, '%d-%m-%Y')) < MONTH(STR_TO_DATE(`date of birth`, '%d-%m-%Y')), 1, IF(MONTH(STR_TO_DATE(`commencement date`, '%d-%m-%Y')) = MONTH(STR_TO_DATE(`date of birth`, '%d-%m-%Y')) AND DAY(STR_TO_DATE(`commencement date`, '%d-%m-%Y')) < DAY(STR_TO_DATE(`date of birth`, '%d-%m-%Y')), 1, 0)) AS `Age`,
    `total_term` / 12 AS `Term`,
    `Policies`.`benefit_duration`,
    `Policies`.`professional class`,
    `Policies`.`waiting time`,
    IF(InStr(`Policies`.`cover code`, "Passend") > 0, "Suitable", IF(InStr(`cover code`, "Eigen") > 0, "Own", `Policies`.`cover code`)) AS `OccupationDef`,
    IF(InStr(`Policies`.`cover code`, "25%") > 0, "P25", IF(InStr(`Policies`.`cover code`, "35%") > 0, "P35", IF(InStr(`Policies`.`cover code`, "45%") > 0, "P45", IF(InStr(`Policies`.`cover code`, "55%") > 0, "P55", IF(InStr(`Policies`.`cover code`, "65%") > 0, "P65", IF(InStr(`Policies`.`cover code`, "80%") > 0, "P80", `Policies`.`cover code`)))))) AS `BenefitDef`,
    `Policies`.`indexation percentage`,
    `Policies`.`mental diseases`,
    `Policies`.`premium payment`,
    TIMESTAMPDIFF(MONTH, STR_TO_DATE(`commencement date`, '%d-%m-%Y'), STR_TO_DATE('{ValDat}', '%d-%m-%Y')) AS `PeriodIF`,
    `Policies`.`RP net premium` AS `NetPremium`
FROM 
    `Policies`
WHERE 
    ((`Policies`.`policy terms`) = "QL_GG_03_2015") AND ((`Policies`.`Quantum status`) = "Active");