DROP VIEW IF EXISTS `Q_DataRequirements`;
CREATE VIEW `Q_DataRequirements` AS
SELECT 
    `ClaimsBasic`.`claim_id`,
    TIMESTAMPDIFF(DAY, STR_TO_DATE(`ClaimsBasic`.`betaling_start_datum`, '%d-%m-%Y'), STR_TO_DATE(`ClaimsBasic`.`betaling_eind_datum`, '%d-%m-%Y')) / 30 AS `Mnths`,
    TIMESTAMPDIFF(DAY, STR_TO_DATE(`ClaimsBasic`.`betaling_start_datum`, '%d-%m-%Y'), STR_TO_DATE('{ValDat}', '%d-%m-%Y')) / 30 AS `Mnths2`,
    `ClaimsBasic`.`betaling_start_datum`,
    `ClaimsBasic`.`betaling_eind_datum`,
    `Claims`.`reserveringen_betaald`,
    `ClaimsBasic`.`totaal_uit_te_keren_bedrag`,
    IF((SELECT `Mnths`) < (SELECT `Mnths2`), (SELECT `Mnths`), (SELECT `Mnths2`)) * `ClaimsBasic`.`totaal_uit_te_keren_bedrag` AS `Soll`,
    `ClaimsBasic`.`claim_status`,
    `ClaimsBasic`.`type`
FROM 
    `ClaimsBasic`
INNER JOIN 
    `Claims` ON `ClaimsBasic`.`claim_id` = `Claims`.`claim_id`
WHERE 
    (((`ClaimsBasic`.`claim_status`) = "DECLINED") AND ((`ClaimsBasic`.`type`) = "DISABILITY"));