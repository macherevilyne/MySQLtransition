DROP VIEW IF EXISTS `Q_ChangeReserveReverse`;
CREATE VIEW `Q_ChangeReserveReverse` AS
SELECT 
    Count(`MonetResultsAllPrevious`.`PolNo`) AS `CountOfPolNo`,
    Sum(`MonetResultsAllPrevious`.`ReserveCalcValDat`) AS `SumOfReserveCalcValDat`,
    Sum(IF(`MonetResultsAllPrevious`.`PeriodDisable` > `MthNoLSA`-1, 0, `MonetResultsAllPrevious`.`ReserveCalcValDat`)) AS `ReserveNew`
FROM 
    `MonetResultsAllPrevious` 
    LEFT JOIN `MonetResultsAll` ON `MonetResultsAllPrevious`.`PolNo` = `MonetResultsAll`.`PolNo`
WHERE 
    (`MonetResultsAllPrevious`.`Status`="disable" AND (`MonetResultsAll`.`Status`="active" OR `MonetResultsAll`.`Status` IS NULL));