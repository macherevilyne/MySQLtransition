INSERT INTO DBCBErrorTable(`Claim ID`,`Error`,`Variable`,`Value`,`Status`)
SELECT `ClaimsBasic`.`claim_id`,
IF(ISNULL(`totaal_verzekerd_bedrag`),"totaal_verzekerd_bedrag empty","Invalid totaal_verzekerd_bedrag") AS `Error`,
"totaal_verzekerd_bedrag" AS `Variable`,
`ClaimsBasic`.`totaal_verzekerd_bedrag` AS `Value`,
`ClaimsBasic`.`claim_status` AS `Status`
FROM `ClaimsBasic`
WHERE (((`ClaimsBasic`.`totaal_verzekerd_bedrag`) Is Null
    Or (`ClaimsBasic`.`totaal_verzekerd_bedrag`)<=0));