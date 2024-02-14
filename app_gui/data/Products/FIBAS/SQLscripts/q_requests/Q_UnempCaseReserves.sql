DROP VIEW IF EXISTS `Q_UnempCaseReserves`;
CREATE VIEW `Q_UnempCaseReserves` AS
SELECT 
    `ClaimsBasic`.`claim_id`,
    `ClaimsBasic`.`claim_type`,
    ClaimsStatus(`ClaimsBasic`.`claim_status`) AS `Status`,
    `ClaimsBasic`.`polis_voorwaarden`,
    YEAR(STR_TO_DATE(`eigen_risico_start_datum`, '%d-%m-%Y')) AS `OY`,
    `Policies`.`Benefit Duration WW`,
    `Policies`.`policy terms`,
    `ClaimsBasic`.`totaal_verzekerd_bedrag`,
    `Claims`.`reserveringen_betaald`
FROM 
    `ClaimsBasic`
LEFT JOIN 
    `Policies` ON `ClaimsBasic`.`eerste_polis_nummer` = `Policies`.`policy number`
LEFT JOIN 
    `Claims` ON `ClaimsBasic`.`claim_id` = `Claims`.`claim_id`
WHERE 
    `ClaimsBasic`.`claim_type` = "UNEMPLOYMENT" AND ClaimsStatus(`claim_status`) <> "Terminated";