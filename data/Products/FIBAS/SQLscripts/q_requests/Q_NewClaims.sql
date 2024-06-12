DROP VIEW IF EXISTS `Q_NewClaims`;
CREATE VIEW `Q_NewClaims` AS
SELECT 
    `Claims`.`claim_id`,
    `Claims`.`gebeurtenis_datum`,
    `ClaimsPrevious`.`claim_id`,
    `ClaimsPrevious`.`reserveringen_openstaand`,
    `Claims`.`reserveringen_openstaand`,
    `Claims`.`betaling_eind_datum`,
    `Policies`.`Quantum status`
FROM 
    (`Claims`
    LEFT JOIN `ClaimsPrevious` ON `Claims`.`claim_id` = `ClaimsPrevious`.`claim_id`)
    LEFT JOIN `Policies` ON `Claims`.`eerste_polis_nummer` = `Policies`.`policy number`
WHERE 
    ((`ClaimsPrevious`.`claim_id` IS NULL AND `Claims`.`reserveringen_openstaand` > 0 AND `Policies`.`Quantum status` = "Active")
    OR (`ClaimsPrevious`.`reserveringen_openstaand` <= 0 AND `Claims`.`reserveringen_openstaand` > 0 AND `Policies`.`Quantum status` = "Active"));