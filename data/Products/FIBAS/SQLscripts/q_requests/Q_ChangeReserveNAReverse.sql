DROP VIEW IF EXISTS `Q_ChangeReserveNAReverse`;
CREATE VIEW `Q_ChangeReserveNAReverse` AS
SELECT 
    COUNT(`MonetResultsNotAcceptPrevious`.`PolNo`) AS `CountOfPolNo`,
    SUM(`MonetResultsNotAcceptPrevious`.`ReserveCalcValDat`) AS `SumOfReserveCalcValDat`,
    SUM(IF(`MonetResultsNotAcceptPrevious`.`PeriodDisable` > `MthNotLSA`-1, 0, `MonetResultsNotAcceptPrevious`.`ReserveCalcValDat`)) AS `ReserveNew`
FROM 
    `MonetResultsNotAcceptPrevious`
    LEFT JOIN `MonetResultsNotAccept` ON `MonetResultsNotAcceptPrevious`.`PolNo` = `MonetResultsNotAccept`.`PolNo`
WHERE 
    (`MonetResultsNotAcceptPrevious`.`Status`="disable" AND (`MonetResultsNotAccept`.`Status`="active" OR `MonetResultsNotAccept`.`Status` IS NULL));