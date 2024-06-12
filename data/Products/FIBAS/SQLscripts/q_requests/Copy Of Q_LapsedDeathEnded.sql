DROP VIEW IF EXISTS `Copy Of Q_LapsedDeathEnded`;
CREATE VIEW `Copy Of Q_LapsedDeathEnded` AS
SELECT 
    COUNT(`MonetResultsAllPrevious`.`PolNo`) AS `CountPol`,
    SUM(`MonetResultsAllPrevious`.`ReserveCalcValDat`) AS `SumReserve`
FROM 
    `MonetResultsAllPrevious` 
    LEFT JOIN `MonetResultsAll` ON `MonetResultsAllPrevious`.`PolNo` = `MonetResultsAll`.`PolNo`
WHERE 
    `MonetResultsAll`.`PolNo` IS NULL;