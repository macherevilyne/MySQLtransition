DROP VIEW IF EXISTS `Q_ChangeReserveNA`;
CREATE VIEW `Q_ChangeReserveNA` AS
SELECT 
    `Q_ChangeReserveNAHulp`.`Code` AS `Expression1`,
    COUNT(`Q_ChangeReserveNAHulp`.`PolNo`) AS `CountOfPolNo`,
    SUM(`ResCurrent` - `ResPrevious`) AS `AllReserves`,
    SUM(`ResCurrentNew` - `ResPreviousNew`) AS `NewReserves`
FROM 
    `Q_ChangeReserveNAHulp`
GROUP BY 
    `Q_ChangeReserveNAHulp`.`Code`
ORDER BY 
    `Q_ChangeReserveNAHulp`.`Code` DESC;