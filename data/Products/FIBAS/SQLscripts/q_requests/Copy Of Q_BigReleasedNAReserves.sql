DROP VIEW IF EXISTS `Copy Of Q_BigReleasedNAReserves`;
CREATE VIEW `Copy Of Q_BigReleasedNAReserves` AS
SELECT 
    (SELECT `claim_id` FROM `ClaimsBasic` ORDER BY `claim_id` LIMIT 1) AS `Claim No`,
    MAX(YEAR(STR_TO_DATE(`eigen_risico_start_datum`, '%d-%m-%Y'))) AS `OY`,
    `MonetResultsNotAcceptPrevious`.`ReserveCalcValDat` AS `Amount`,
    `MonetResultsNotAccept`.`Status`, 
    `MonetResultsNotAccept`.`PolNo`, 
    `MonetResultsNotAcceptPrevious`.`Status`
FROM 
    (`MonetResultsNotAcceptPrevious`
        LEFT JOIN `MonetResultsNotAccept` ON `MonetResultsNotAcceptPrevious`.`PolNo` = `MonetResultsNotAccept`.`PolNo`)
        LEFT JOIN `ClaimsBasic` ON `MonetResultsNotAcceptPrevious`.`PolNo` = `ClaimsBasic`.`eerste_polis_nummer`
GROUP BY 
    `MonetResultsNotAcceptPrevious`.`ReserveCalcValDat`, 
    `MonetResultsNotAccept`.`Status`, 
    `MonetResultsNotAccept`.`PolNo`, 
    `MonetResultsNotAcceptPrevious`.`Status`
HAVING 
    (((`MonetResultsNotAccept`.`Status`)="active") AND ((`MonetResultsNotAcceptPrevious`.`Status`)="disable")) OR 
    (((`MonetResultsNotAccept`.`PolNo`) Is Null) AND ((`MonetResultsNotAcceptPrevious`.`Status`)="disable"))
ORDER BY 
    `MonetResultsNotAcceptPrevious`.`ReserveCalcValDat` DESC;