DROP VIEW IF EXISTS `Q_ClaimsNoReserve`;
CREATE VIEW `Q_ClaimsNoReserve` AS
SELECT 
    `Claims`.`claim_id`,
    `ClaimsPrevious`.`claim_id`,
    `ClaimsPrevious`.`reserveringen_openstaand`,
    `ClaimsPrevious`.`betaling_eind_datum`,
    `ClaimsPrevious`.`reserveringen_betaald`,
    `Policies`.`Quantum status`,
    `Claims`.`reserveringen_openstaand`,
    `Claims`.`betaling_eind_datum`,
    `Claims`.`reserveringen_betaald`
FROM 
    (`Claims`
    LEFT JOIN `ClaimsPrevious` ON `Claims`.`claim_id` = `ClaimsPrevious`.`claim_id`)
    LEFT JOIN `Policies` ON `Claims`.`eerste_polis_nummer` = `Policies`.`policy number`
WHERE 
    (((`ClaimsPrevious`.`claim_id`) Is Null)
    AND ((`Policies`.`Quantum status`)="Active")
    AND ((`Claims`.`reserveringen_openstaand`)<=0)
    AND (STR_TO_DATE(`Claims`.`betaling_eind_datum`, '%d-%m-%Y') < STR_TO_DATE('04.01.2011', '%d.%m.%Y')))
    OR 
    (((`ClaimsPrevious`.`reserveringen_openstaand`)<=0)
    AND (STR_TO_DATE(`ClaimsPrevious`.`betaling_eind_datum`, '%d-%m-%Y') >= STR_TO_DATE('01.01.2011', '%d.%m.%Y'))
    AND ((`Policies`.`Quantum status`)="Active")
    AND ((`Claims`.`reserveringen_openstaand`)<=0)
    AND (STR_TO_DATE(`Claims`.`betaling_eind_datum`, '%d-%m-%Y') < STR_TO_DATE('04.01.2011', '%d.%m.%Y'))));