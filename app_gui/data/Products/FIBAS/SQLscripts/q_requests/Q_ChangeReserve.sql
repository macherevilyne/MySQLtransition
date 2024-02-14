DROP VIEW IF EXISTS `Q_ChangeReserve`;
CREATE VIEW `Q_ChangeReserve` AS
SELECT 
    `Q_ChangeReserveHulp`.`Code` AS `Выражение1`,
    COUNT(`Q_ChangeReserveHulp`.`PolNo`) AS `CountOfPolNo`,
    SUM(`ResCurrent` - `ResPrevious`) AS `AllReserves`,
    SUM(`ResCurrentNew` - `ResPreviousNew`) AS `NewReserves`
FROM 
    `Q_ChangeReserveHulp`
GROUP BY 
    `Q_ChangeReserveHulp`.`Code`
ORDER BY 
    `Q_ChangeReserveHulp`.`Code` DESC;