DROP VIEW IF EXISTS `Q_CompareClaims`;
CREATE VIEW `Q_CompareClaims` AS
SELECT 
    COUNT(`Claims`.`claim_id`) AS `CountOfclaim_id`,
    IF(ISNULL(`Claims1`.`reserveringen_openstaand`), "New", IF(`Claims1`.`reserveringen_openstaand` = 0, "Evaluation", "Existing")) AS `Expr1`,
    `Claims1`.`status`,
    YEAR(STR_TO_DATE(`Claims`.`gebeurtenis_datum`, '%d-%m-%Y')) AS OY,
    SUM(`Results_Records`.`ReserveCalcValDat`) AS `SumOfReserveCalcValDat`
FROM 
    ((`Claims`
    LEFT JOIN `Claims1` ON `Claims`.`claim_id` = `Claims1`.`claim_id`)
    LEFT JOIN `Policies` ON `Claims`.`eerste_polis_nummer` = `Policies`.`policy number`)
    LEFT JOIN `Results_Records` ON `Policies`.`policy number` = `Results_Records`.`PolNo`
WHERE 
    (((`Policies`.`Quantum status`) = "Active") AND ((`Claims`.`reserveringen_openstaand`) > 0))
GROUP BY 
    IF(ISNULL(`Claims1`.`reserveringen_openstaand`), "New", IF(`Claims1`.`reserveringen_openstaand` = 0, "Evaluation", "Existing")),
    `Claims1`.`status`,
    YEAR(STR_TO_DATE(`Claims`.`gebeurtenis_datum`, '%d-%m-%Y'));