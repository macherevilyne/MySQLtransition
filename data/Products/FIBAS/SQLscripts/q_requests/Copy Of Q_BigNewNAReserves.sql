DROP VIEW IF EXISTS `Copy Of Q_BigNewNAReserves`;
CREATE VIEW `Copy Of Q_BigNewNAReserves` AS
SELECT 
    `ClaimsBasic`.`claim_id` AS `Claim No`,
    YEAR(STR_TO_DATE(`eigen_risico_start_datum`, '%d-%m-%Y')) AS `OY`,
    (`ResCurrent`-`ResPrevious`) AS `Amount`
FROM 
    `Q_ChangeReserveNAHulp` 
    LEFT JOIN `ClaimsBasic` ON `Q_ChangeReserveNAHulp`.`PolNo` = `ClaimsBasic`.`eerste_polis_nummer`
WHERE 
    `Q_ChangeReserveNAHulp`.`Code` = "new"
ORDER BY 
    `Amount` DESC;