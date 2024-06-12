DROP VIEW IF EXISTS `Q_BigNewReserves`;
CREATE VIEW `Q_BigNewReserves` AS
SELECT 
    `ClaimsBasic`.`claim_id`,
    YEAR(STR_TO_DATE(`eigen_risico_start_datum`, '%d-%m-%Y')) AS `OY`,
    (`ResCurrent` - `ResPrevious`) AS `Amount`
FROM 
    (`Q_BigNewReserves_Aux`
        INNER JOIN `ClaimsBasic` ON 
            (STR_TO_DATE(`Q_BigNewReserves_Aux`.`Maxvoneigen_risico_start_datum`, '%d-%m-%Y') = STR_TO_DATE(`ClaimsBasic`.`eigen_risico_start_datum`, '%d-%m-%Y'))
            AND (`Q_BigNewReserves_Aux`.`PolNoAux` = `ClaimsBasic`.`eerste_polis_nummer`))
    INNER JOIN `Q_ChangeReserveHulp` ON `Q_BigNewReserves_Aux`.`PolNoAux` = `Q_ChangeReserveHulp`.`PolNo`
WHERE 
    (`Q_ChangeReserveHulp`.`Code` = "new")
ORDER BY 
    (`ResCurrent` - `ResPrevious`) DESC;