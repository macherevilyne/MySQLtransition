DROP VIEW IF EXISTS `Copy Of Q_BigNewReserves`;
CREATE VIEW `Copy Of Q_BigNewReserves` AS
SELECT 
    `ClaimsBasic`.`claim_id` AS `Claim No`,
    YEAR(STR_TO_DATE(`eigen_risico_start_datum`, '%d-%m-%Y')) AS `OY`,
    (`ResCurrent`-`ResPrevious`) AS `Amount`
FROM 
    `Q_ChangeReserveHulp` 
    LEFT JOIN `ClaimsBasic` ON `Q_ChangeReserveHulp`.`PolNo` = `ClaimsBasic`.`eerste_polis_nummer`
WHERE 
    `Q_ChangeReserveHulp`.`Code` = "new"
ORDER BY 
    `Q_ChangeReserveHulp`.`Code` DESC,
    `Amount` DESC;