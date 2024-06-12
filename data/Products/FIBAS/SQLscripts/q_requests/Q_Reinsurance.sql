DROP VIEW IF EXISTS `Q_Reinsurance`;
CREATE VIEW `Q_Reinsurance` AS
SELECT 
    `Claims`.`claim_id`,
    YEAR(STR_TO_DATE(`Claims`.`gebeurtenis_datum`, '%d-%m-%Y')) AS `OccurrenceYear`,
    `Claims`.`reserveringen_openstaand`,
    `Claims20091231`.`reserveringen_openstaand`,
    -`Claims20091231`.`reserveringen_betaald` AS `Paid2009`,
    -`Claims`.`reserveringen_betaald` + `Claims20091231`.`reserveringen_betaald` AS `Paid2010`
FROM 
    `Claims` 
LEFT JOIN 
    `Claims20091231` ON `Claims`.`claim_id` = `Claims20091231`.`claim_id`
WHERE 
    `Claims`.`claim_type` = "DISABILITY";