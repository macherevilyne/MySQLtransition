DROP VIEW IF EXISTS `Q_AmtPolPerClaim`;
CREATE VIEW `Q_AmtPolPerClaim` AS
SELECT 
    `Claims`.`claim_id`,
    COUNT(`Policies`.`policy number`) AS `Anzahlvonpolicy number`
FROM 
    (`Claims` 
        INNER JOIN `ClaimsPolicy` ON `Claims`.`claim_id` = `ClaimsPolicy`.`claim_id`)
        INNER JOIN `Policies` ON `ClaimsPolicy`.`policy_id` = `Policies`.`policy number`
WHERE 
    `Policies`.`policy terms` IN ("QL_GG_03_2015", "QL_GG_2020_06", "QL_MLB_06_2019")
GROUP BY 
    `Claims`.`claim_id`
ORDER BY 
    COUNT(`Policies`.`policy number`) DESC;