DROP VIEW IF EXISTS `Q_BigReleasedReserves`;
CREATE VIEW `Q_BigReleasedReserves` AS
SELECT 
    (SELECT `claim_id` FROM `ClaimsBasic` ORDER BY `claim_id` LIMIT 1) AS `Claim No`,
    MAX(YEAR(STR_TO_DATE(`eigen_risico_start_datum`, '%d-%m-%Y'))) AS `OY`,
    `MonetResultsAllPrevious`.`ReserveCalcValDat` AS `Amount`,
    `MonetResultsAll`.`Status`,
    `MonetResultsAll`.`PolNo`,
    `MonetResultsAllPrevious`.`Status`
FROM 
    (`MonetResultsAllPrevious`
        LEFT JOIN `MonetResultsAll` ON `MonetResultsAllPrevious`.`PolNo` = `MonetResultsAll`.`PolNo`)
        LEFT JOIN `ClaimsBasic` ON `MonetResultsAllPrevious`.`PolNo` = `ClaimsBasic`.`eerste_polis_nummer`
GROUP BY 
    `MonetResultsAllPrevious`.`ReserveCalcValDat`,
    `MonetResultsAll`.`Status`,
    `MonetResultsAll`.`PolNo`,
    `MonetResultsAllPrevious`.`Status`
HAVING 
    (((`MonetResultsAll`.`Status`)="active")
    AND ((`MonetResultsAllPrevious`.`Status`)="disable")) 
    OR (((`MonetResultsAll`.`PolNo`) Is Null)
    AND ((`MonetResultsAllPrevious`.`Status`)="disable"))
ORDER BY 
    `MonetResultsAllPrevious`.`ReserveCalcValDat` DESC;