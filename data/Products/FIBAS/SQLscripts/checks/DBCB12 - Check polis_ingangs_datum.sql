INSERT INTO DBCBErrorTable(`Claim ID`,`Error`,`Variable`,`Value`,`Status`)
SELECT `ClaimsBasic`.`claim_id`,
IF(ISNULL(`polis_ingangs_datum`),"polis_ingangs_datum empty","Invalid polis_ingangs_datum") AS `Error`,
"polis_ingangs_datum" AS `Variable`,
`ClaimsBasic`.`polis_ingangs_datum` AS `Value`,
`ClaimsBasic`.`claim_status` AS `Status`
FROM `ClaimsBasic`
WHERE (((`ClaimsBasic`.`polis_ingangs_datum`) Is Null
Or (STR_TO_DATE(`ClaimsBasic`.`polis_ingangs_datum`, '%d-%m-%Y'))<STR_TO_DATE('01.01.2005', '%d.%m.%Y')));