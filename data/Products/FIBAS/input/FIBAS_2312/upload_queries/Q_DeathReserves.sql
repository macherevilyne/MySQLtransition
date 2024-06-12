DROP VIEW IF EXISTS `Q_DeathReserves`;
CREATE VIEW `Q_DeathReserves` AS
SELECT 
    `ClaimsBasic`.`claim_id`,
    `ClaimsBasic`.`claim_type`,
    ClaimsStatus(`ClaimsBasic`.`claim_status`) AS `Status`,
    `ClaimsBasic`.`polis_voorwaarden`,
    YEAR(STR_TO_DATE(`ClaimsBasic`.`eigen_risico_start_datum`, '%d-%m-%Y')) AS `OY`,
    `Policies`.`benefit_duration_term_life`,
    `ClaimsBasic`.`totaal_verzekerd_bedrag`,
    `Claims`.`reserveringen_betaald`,
    TIMESTAMPDIFF(MONTH, STR_TO_DATE(`Policies`.`commencement date`, '%d-%m-%Y'), STR_TO_DATE(`ClaimsBasic`.`eigen_risico_start_datum`, '%d-%m-%Y')) AS `TimeToDeath`,
    Policies.total_term
FROM 
    (`ClaimsBasic`
    LEFT JOIN `Policies` ON `ClaimsBasic`.`eerste_polis_nummer` = `Policies`.`policy number`)
    LEFT JOIN `Claims` ON `ClaimsBasic`.`claim_id` = `Claims`.`claim_id`
WHERE 
    (((`ClaimsBasic`.`claim_type`) = "DEATH") AND ((ClaimsStatus(`claim_status`)) <> "Terminated"));