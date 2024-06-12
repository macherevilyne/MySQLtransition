INSERT INTO DBCBErrorTable(`Claim ID`,`Error`,Variable,`Value`,`Status`)
SELECT `ClaimsBasic`.`claim_id`,
IF(ISNULL(`product_groep`),"product_groep empty","Invalid product_groep") AS `Error`,
"product_groep" AS `Variable`,
`ClaimsBasic`.`product_groep` AS `Value`,
`ClaimsBasic`.`claim_status` AS `Status`
FROM `ClaimsBasic`
WHERE (((`ClaimsBasic`.`product_groep`) Is Null))
    Or (((`ClaimsBasic`.`product_groep`)<>"MLB"
And (`ClaimsBasic`.`product_groep`)<>"ZSP"));