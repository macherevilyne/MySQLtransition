DROP VIEW IF EXISTS `Q_BigNewNAReserves`;
CREATE VIEW `Q_BigNewNAReserves` AS
SELECT 
    `ClaimsBasic`.`claim_id`,
    YEAR(STR_TO_DATE(`eigen_risico_start_datum`, '%d-%m-%Y')) AS `OY`,
    (`ResCurrent` - `ResPrevious`) AS `Amount`
FROM 
    (`Q_ChangeReserveNAHulp`
        INNER JOIN `Q_BigNewNAReserves_Aux` ON `Q_ChangeReserveNAHulp`.`PolNo` = `Q_BigNewNAReserves_Aux`.`PolNo`)
        INNER JOIN `ClaimsBasic` ON (`Q_BigNewNAReserves_Aux`.`PolNo` = `ClaimsBasic`.`eerste_polis_nummer`)
        AND (STR_TO_DATE(`Q_BigNewNAReserves_Aux`.`Maxvoneigen_risico_start_datum`, '%d-%m-%Y') = STR_TO_DATE(`ClaimsBasic`.`eigen_risico_start_datum`, '%d-%m-%Y'))
WHERE 
    (`Q_ChangeReserveNAHulp`.`Code` = "new")
ORDER BY 
    (`ResCurrent` - `ResPrevious`) DESC;