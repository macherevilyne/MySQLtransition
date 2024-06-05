DROP VIEW IF EXISTS `Q_BigNewNAReserves_Aux`;
CREATE VIEW `Q_BigNewNAReserves_Aux` AS
SELECT 
    `Q_ChangeReserveNAHulp`.`PolNo`,
    MAX(STR_TO_DATE(`ClaimsBasic`.`eigen_risico_start_datum`, '%d-%m-%Y')) AS `Maxvoneigen_risico_start_datum`
FROM 
    `Q_ChangeReserveNAHulp`
    INNER JOIN `ClaimsBasic` ON `Q_ChangeReserveNAHulp`.`PolNo` = `ClaimsBasic`.`eerste_polis_nummer`
GROUP BY 
    `Q_ChangeReserveNAHulp`.`PolNo`
ORDER BY 
    `Q_ChangeReserveNAHulp`.`PolNo` DESC;