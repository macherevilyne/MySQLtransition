DROP VIEW IF EXISTS `Q_TotalPaidOY`;
CREATE VIEW `Q_TotalPaidOY` AS
SELECT 
    COUNT(`Claims`.`claim_id`) AS `CountOfclaim_id`,
    `Claims`.`claim_type`,
    YEAR(STR_TO_DATE(`Claims`.`gebeurtenis_datum`, '%d-%m-%Y')) AS OY,
    SUM(`Claims`.`reserveringen_betaald`) AS `SumOfreserveringen_betaald`,
    SUM(`Claims`.`reserveringen_openstaand`) AS `Summevonreserveringen_openstaand`
FROM 
    `Claims`
GROUP BY 
    `Claims`.`claim_type`,
    YEAR(STR_TO_DATE(`Claims`.`gebeurtenis_datum`, '%d-%m-%Y'))
HAVING 
    ((`Claims`.`claim_type`="DISABILITY"));