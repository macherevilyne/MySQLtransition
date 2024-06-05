DROP VIEW IF EXISTS `Q_TotalPaidOY_NewOY_DisDeath`;
CREATE VIEW `Q_TotalPaidOY_NewOY_DisDeath` AS
SELECT 
    COUNT(`Claims`.`claim_id`) AS `CountOfclaim_id`,
    MAX(`Claims`.`claim_type`) AS `MaxOfclaim_type`,
    YEAR(STR_TO_DATE(`ClaimsBasic`.`eigen_risico_start_datum`, '%d-%m-%Y')) AS `OY`,
    SUM(`Claims`.`reserveringen_betaald`) AS `SumOfreserveringen_betaald`,
    SUM(IF(STR_TO_DATE(`claims`.`verwachte_herstel_datum`, '%d-%m-%Y') < STR_TO_DATE('{ValDat}', '%d-%m-%Y')
        OR `claims`.`status` = "CLOSED"
        OR `claims`.`status` = "DECLINED"
        OR `claims`.`status` = "CANCELED"
        OR `claims`.`status` = "ENDED", 0, `claims`.`verzekerd_pedrag` * TIMESTAMPDIFF(DAY, STR_TO_DATE('{ValDat}', '%d-%m-%Y'), STR_TO_DATE(`claims`.`verwachte_herstel_datum`, '%d-%m-%Y')) / 365 * 12)) AS `reserveringen_openstaand`
FROM 
    `Claims` 
    LEFT JOIN `ClaimsBasic` ON `Claims`.`claim_id` = `ClaimsBasic`.`claim_id`
WHERE 
    ((`Claims`.`claim_type` = "DISABILITY" OR `Claims`.`claim_type` = "DEATH"))
GROUP BY 
    YEAR(STR_TO_DATE(`ClaimsBasic`.`eigen_risico_start_datum`, '%d-%m-%Y'))
HAVING 
    (MAX(`Claims`.`claim_type`) = "DISABILITY" OR MAX(`Claims`.`claim_type`) = "DEATH");