INSERT INTO DBCBErrorTable(`Claim ID`,`Error`,`Variable`,`Value`,`Status`)
SELECT `ClaimsBasic`.`claim_id`,
IF(ISNULL(`betalingsniveau`),"betalingsniveau empty","Invalid betalingsniveau") AS `Error`,
"betalingsniveau" AS `Variable`, 
`ClaimsBasic`.`betalingsniveau` AS `Value`, 
`ClaimsBasic`.`claim_status` AS `Status`
FROM `ClaimsBasic`
WHERE (((`ClaimsBasic`.`betalingsniveau`)<>"naar rato" 
And (`ClaimsBasic`.`betalingsniveau`)<>"volledig"))
    Or (((`ClaimsBasic`.`betalingsniveau`) Is Null)
And ((`ClaimsBasic`.`betalingsduur`)="uitgebreid"
    Or (`ClaimsBasic`.`betalingsduur`)="basis"));