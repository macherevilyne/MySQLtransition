INSERT INTO DBCBErrorTable(`Claim ID`,`Error`,`Variable`,`Value`,`Status`)
SELECT `ClaimsBasic`.`claim_id`,
IF(ISNULL(`arbeidsongeschiktheid_percentage`),"arbeidsongeschiktheid_percentage empty","Invalid arbeidsongeschiktheid_percentage") AS `Error`,
"arbeidsongeschiktheid_percentage" AS `Variable`,
`ClaimsBasic`.`arbeidsongeschiktheid_percentage` AS `Value`,
`ClaimsBasic`.`claim_status` AS `Status`
FROM `ClaimsBasic`
WHERE (((`ClaimsBasic`.`arbeidsongeschiktheid_percentage`)<0
    Or (`ClaimsBasic`.`arbeidsongeschiktheid_percentage`)>100));