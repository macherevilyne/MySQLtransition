DROP VIEW IF EXISTS `Q_PoliciesSeveralClaims`;
CREATE VIEW `Q_PoliciesSeveralClaims` AS
SELECT 
    `Temp`.`PolNo`,
    `Temp`.`NoOfClaims`,
    `ClaimsPolicy`.`claim_id`,
    `ClaimsBasic`.`eigen_risico_start_datum`,
    `ClaimsBasic`.`betaling_start_datum`,
    `ClaimsBasic`.`betaling_eind_datum`,
    `ClaimsBasic`.`laatste_betaling`,
    `Claims`.`reserveringen_betaald`
FROM 
    (
        (
            SELECT 
                `ClaimsPolicy`.`policy_id` AS `PolNo`,
                COUNT(`Claims`.`claim_id`) AS `NoOfClaims`
            FROM 
                `ClaimsPolicy` 
                LEFT JOIN `Claims` ON `ClaimsPolicy`.`claim_id` = `Claims`.`claim_id`
            WHERE 
                ((`Claims`.`reserveringen_betaald`)<0)
            GROUP BY 
                `ClaimsPolicy`.`policy_id`
            HAVING 
                ((COUNT(`Claims`.`claim_id`)) > 1)
        )  AS `Temp`
        LEFT JOIN `ClaimsPolicy` ON `Temp`.`PolNo` = `ClaimsPolicy`.`policy_id`
    )
    LEFT JOIN `ClaimsBasic` ON `ClaimsPolicy`.`claim_id` = `ClaimsBasic`.`claim_id`
    LEFT JOIN `Claims` ON `ClaimsBasic`.`claim_id` = `Claims`.`claim_id`
WHERE 
    ((`Claims`.`reserveringen_betaald`)<0)
ORDER BY 
    `Temp`.`PolNo`;