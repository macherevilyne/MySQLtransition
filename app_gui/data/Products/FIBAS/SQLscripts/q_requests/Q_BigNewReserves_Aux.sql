DROP VIEW IF EXISTS `Q_BigNewReserves_Aux`;
CREATE VIEW `Q_BigNewReserves_Aux` AS
SELECT 
    `Q_ChangeReserveHulp`.`PolNo` AS `PolNoAux`,
    MAX(STR_TO_DATE(`ClaimsBasic`.`eigen_risico_start_datum`, '%d-%m-%Y')) AS `Maxvoneigen_risico_start_datum`
FROM 
    `Q_ChangeReserveHulp` 
    LEFT JOIN `ClaimsBasic` ON `Q_ChangeReserveHulp`.`PolNo` = `ClaimsBasic`.`eerste_polis_nummer`
GROUP BY 
    `Q_ChangeReserveHulp`.`PolNo`
ORDER BY 
    `Q_ChangeReserveHulp`.`PolNo`;