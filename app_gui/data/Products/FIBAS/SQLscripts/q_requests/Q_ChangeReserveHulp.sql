DROP VIEW IF EXISTS `Q_ChangeReserveHulp`;
CREATE VIEW `Q_ChangeReserveHulp` AS
SELECT 
    `MonetResultsAll`.`PolNo`,
    `MonetResultsAll`.`Status`,
    IF(`MonetResultsAllPrevious`.`Status`="disable","increased","new") AS `Code`,
    `MonetResultsAll`.`ReserveCalcValDat` AS `ResCurrent`,
    IF(`MonetResultsAllPrevious`.`Status`="disable",`MonetResultsAllPrevious`.`ReserveCalcValDat`,0) AS `ResPrevious`,
    IF(`MonetResultsAll`.`PeriodDisable`>`MthNotLSA`,"old","new") AS `ClaimYear`,
    IF(`ClaimYear`="New",`ResCurrent`,0) AS `ResCurrentNew`,
    IF(`ClaimYear`="New",`ResPrevious`,0) AS `ResPreviousNew`
FROM 
    `MonetResultsAll`
    LEFT JOIN `MonetResultsAllPrevious` ON `MonetResultsAll`.`PolNo` = `MonetResultsAllPrevious`.`PolNo`
WHERE 
    (`MonetResultsAll`.`Status`="disable");