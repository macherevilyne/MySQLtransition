INSERT INTO DBCBErrorTable(`Claim ID`,`Error`,`Variable`,`Value`,`Status`)
SELECT `ClaimsBasic`.`claim_id`,
IF(ISNULL(`claim_type`),"type empty","Invalid type") AS Error,
"type" AS `Variable`,
`ClaimsBasic`.`claim_type` AS `Value`,
`ClaimsBasic`.`claim_status` AS `Status`
FROM `ClaimsBasic`
WHERE (((`ClaimsBasic`.`claim_type`)<>"DISABILITY"
And (`ClaimsBasic`.`claim_type`)<>"DEATH"
And (`ClaimsBasic`.`claim_type`)<>"UNEMPLOYMENT"));