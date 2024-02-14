DROP VIEW IF EXISTS `Q_AnalyseReserveIncrease`;
CREATE VIEW `Q_AnalyseReserveIncrease` AS
SELECT 
    `Q_ChangeReserveHulp`.`PolNo` AS `Expression1`,
    `Q_ChangeReserveHulp`.`Status` AS `Expression2`,
    `Q_ChangeReserveHulp`.`Code` AS `Expression3`,
    `Q_ChangeReserveHulp`.`ResCurrent` AS `Expression4`,
    `Q_ChangeReserveHulp`.`ResPrevious` AS `Expression5`,
    `Q_ChangeReserveHulp`.`ClaimYear` AS `Expression6`,
    `ResCurrent` - `ResPrevious` AS `Diff`
FROM 
    `Q_ChangeReserveHulp`
WHERE 
    `Q_ChangeReserveHulp`.`Code` = "increased"
ORDER BY 
    `ResCurrent` - `ResPrevious` DESC;