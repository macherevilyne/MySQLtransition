INSERT INTO DBCBErrorTable(`Claim ID`,`Error`,`Variable`,`Value`,`Status`)
SELECT `ClaimsBasic`.`claim_id`,
IF(ISNULL(`gebeurtenis_datum`),"gebeurtenis_datum empty","Invalid gebeurtenis_datum") AS `Error`,
"gebeurtenis_datum" AS `Variable`,
`ClaimsBasic`.`gebeurtenis_datum` AS `Value`,
`ClaimsBasic`.`claim_status` AS `Status`
FROM `ClaimsBasic`
WHERE (((`ClaimsBasic`.`gebeurtenis_datum`) Is Null
    Or (STR_TO_DATE(`ClaimsBasic`.`gebeurtenis_datum`, '%d-%m-%Y'))<STR_TO_DATE(`polis_ingangs_datum`, '%d-%m-%Y')));