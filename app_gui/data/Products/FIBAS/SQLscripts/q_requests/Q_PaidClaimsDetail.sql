DROP VIEW IF EXISTS `Q_PaidClaimsDetail`;
CREATE VIEW `Q_PaidClaimsDetail` AS
SELECT 
    `Claims`.`claim_id`,
    `Claims`.`status`,
    `Claims`.`gebeurtenis_datum`,
    `Claims`.`eerste_polis_nummer`,
    -`Claims`.`reserveringen_betaald` + IF(ISNULL(`ClaimsPrevious`.`reserveringen_betaald`), 0, `ClaimsPrevious`.`reserveringen_betaald`) AS `Paid2011`
FROM 
    `Claims` 
LEFT JOIN 
    `ClaimsPrevious` ON `Claims`.`claim_id` = `ClaimsPrevious`.`claim_id`
WHERE 
    -`Claims`.`reserveringen_betaald` + IF(ISNULL(`ClaimsPrevious`.`reserveringen_betaald`), 0, `ClaimsPrevious`.`reserveringen_betaald`) <> 0;