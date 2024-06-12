INSERT INTO DBCErrorTable(`Claim ID`,`Error`,`Variable`,`Value`,`Status`)
SELECT `Claims`.`claim_id`,
IF(ISNULL(`Claims`.`gebeurtenis_datum`),"gebeurtenis_datum empty","Invalid gebeurtenis_datum") AS `Error`,
"gebeurtenis_datum" AS Variable,
`Claims`.`gebeurtenis_datum` AS `Value`,
`Claims`.`status` AS `Status`
FROM `Claims` LEFT JOIN `ClaimsBasic` ON `Claims`.`claim_id` = `ClaimsBasic`.`claim_id`
WHERE (((STR_TO_DATE(`Claims`.`gebeurtenis_datum`, '%d-%m-%Y')) Is Null
    Or (STR_TO_DATE(`Claims`.`gebeurtenis_datum`, '%d-%m-%Y'))<STR_TO_DATE(`polis_ingangs_datum`, '%d-%m-%Y')));