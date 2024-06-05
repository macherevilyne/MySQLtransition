DROP VIEW IF EXISTS `Q_NewClaimsEY`;
CREATE VIEW `Q_NewClaimsEY` AS
SELECT 
    `Claims`.*,
    `ClaimsBasic`.`eigen_risico_start_datum`
FROM 
    `Claims` 
    LEFT JOIN `ClaimsBasic` ON `Claims`.`claim_id` = `ClaimsBasic`.`claim_id`
WHERE 
    (STR_TO_DATE(`ClaimsBasic`.`eigen_risico_start_datum`, '%d-%m-%Y') >= STR_TO_DATE('01.01.2018', '%d.%m.%Y'));