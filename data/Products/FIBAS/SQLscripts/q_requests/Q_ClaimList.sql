DROP VIEW IF EXISTS `Q_ClaimList`;
CREATE VIEW `Q_ClaimList` AS
SELECT 
    `MonetResultsAll`.`PolNo`,
    COUNT(`ClaimsPolicy`.`claim_id`) AS `Anzahlvonclaim_id`
FROM 
    `MonetResultsAll`
    LEFT JOIN `ClaimsPolicy` ON `MonetResultsAll`.`PolNo` = `ClaimsPolicy`.`policy_id`
WHERE 
    (((`MonetResultsAll`.`Status`) = "disable"))
GROUP BY 
    `MonetResultsAll`.`PolNo`;