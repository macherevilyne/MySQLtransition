INSERT INTO DBCBErrorTable(`Claim ID`,`Error`,`Variable`,`Value`,`Status`)
SELECT `ClaimsBasic`.`claim_id`,
IF(ISNULL(`product`),"product empty","Invalid product") AS `Error`,
"product" AS `Variable`,
`ClaimsBasic`.`product` AS `Value`,
`ClaimsBasic`.`claim_status` AS `Status`
FROM `ClaimsBasic`
WHERE (((`ClaimsBasic`.`product`)<>"TAF Maandlastbeschermer"
And (`ClaimsBasic`.`product`)<>"TAF Maandlastbeschermer Q"
And (`ClaimsBasic`.`product`)<>"TAF Maandlastbeschermer 2010"
And (`ClaimsBasic`.`product`)<>"TAF Maandlastbeschermer 2011"
And (`ClaimsBasic`.`product`)<>"TAF STC Maandlastbeschermer"
And (`ClaimsBasic`.`product`)<>"TAF Zelfstandigenplan"
And (`ClaimsBasic`.`product`)<>"TAF Zelfstandigenplan Q"
And (`ClaimsBasic`.`product`)<>"TAF Zelfstandigenplan 2010"
And (`ClaimsBasic`.`product`)<>"TAF Zelfstandigenplan 2011"
And (`ClaimsBasic`.`product`)<>"TAF GoedGezekerd AOV"))
    Or (((`ClaimsBasic`.`product`) Is Null));