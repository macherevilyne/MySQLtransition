DROP VIEW IF EXISTS `Q_TotalPaidOY_NewOY_UNEMP`;
CREATE VIEW `Q_TotalPaidOY_NewOY_UNEMP` AS
SELECT 
    COUNT(`Claims`.`claim_id`) AS `CountOfclaim_id`,
    MAX(`Claims`.`claim_type`) AS `MaxOfclaim_type`,
    YEAR(STR_TO_DATE(`ClaimsBasic`.`eigen_risico_start_datum`, '%d-%m-%Y')) AS `OY`,
    SUM(`Claims`.`reserveringen_betaald`) AS `SumOfreserveringen_betaald`,
    SUM(`Claims`.`reserveringen_openstaand`) AS `Summevonreserveringen_openstaand`
FROM 
    `Claims` 
    LEFT JOIN `ClaimsBasic` ON `Claims`.`claim_id` = `ClaimsBasic`.`claim_id`
WHERE 
    ((`Claims`.`claim_type` = "UNEMPLOYMENT"))
GROUP BY 
    YEAR(STR_TO_DATE(`ClaimsBasic`.`eigen_risico_start_datum`, '%d-%m-%Y'))
HAVING 
    ((MAX(`Claims`.`claim_type`) = "UNEMPLOYMENT"));