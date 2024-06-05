DROP VIEW IF EXISTS `Copy Of Q_ChangeReserveReversePolicy`;
CREATE VIEW `Copy Of Q_ChangeReserveReversePolicy` AS
SELECT 
    `MonetResultsAllPrevious`.`PolNo`, 
    `MonetResultsAllPrevious`.`ReserveCalcValDat`,
    IF(`MonetResultsAllPrevious`.`PeriodDisable` > `MthNoLSA` - 1, 0, `MonetResultsAllPrevious`.`ReserveCalcValDat`) AS `ReserveNew`
FROM 
    `MonetResultsAllPrevious` 
    LEFT JOIN `MonetResultsAll` ON `MonetResultsAllPrevious`.`PolNo` = `MonetResultsAll`.`PolNo`
WHERE 
    `MonetResultsAllPrevious`.`Status` = "disable" AND 
    (`MonetResultsAll`.`Status` = "active" OR `MonetResultsAll`.`Status` IS NULL);