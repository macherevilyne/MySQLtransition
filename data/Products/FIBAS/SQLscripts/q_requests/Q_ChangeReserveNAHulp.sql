DROP VIEW IF EXISTS `Q_ChangeReserveNAHulp`;
CREATE VIEW `Q_ChangeReserveNAHulp` AS
SELECT 
    `MonetResultsNotAccept`.`PolNo`,
    `MonetResultsNotAccept`.`Status`,
    IF(`MonetResultsNotAcceptPrevious`.`Status`="disable","increased","new") AS `Code`,
    `MonetResultsNotAccept`.`ReserveCalcValDat` AS `ResCurrent`,
    IF(`MonetResultsNotAcceptPrevious`.`Status`="disable",`MonetResultsNotAcceptPrevious`.`ReserveCalcValDat`,0) AS `ResPrevious`,
    IF(`MonetResultsNotAccept`.`PeriodDisable`>`MthNotLSA`,"old","new") AS `ClaimYear`,
    IF(`ClaimYear`="New",`ResCurrent`,0) AS `ResCurrentNew`,
    IF(`ClaimYear`="New",`ResPrevious`,0) AS `ResPreviousNew`
FROM 
    `MonetResultsNotAccept` 
    LEFT JOIN `MonetResultsNotAcceptPrevious` ON `MonetResultsNotAccept`.`PolNo` = `MonetResultsNotAcceptPrevious`.`PolNo`
WHERE 
    (`MonetResultsNotAccept`.`Status`="disable");