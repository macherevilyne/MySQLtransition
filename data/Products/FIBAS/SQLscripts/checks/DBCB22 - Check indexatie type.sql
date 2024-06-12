INSERT INTO DBCBErrorTable(`Claim ID`,`Error`,`Variable`,`Value`,`Status`)
SELECT `ClaimsBasic`.`claim_id`,
"Invalid indexatie type" AS `Error`,
"indexatie type" AS `Variable`,
`ClaimsBasic`.`indexatie_type` AS `Value`,
`ClaimsBasic`.`claim_status` AS `Status`
FROM `ClaimsBasic`
WHERE ((Not (`ClaimsBasic`.`indexatie_type`)="NO_INDEXATION"
And Not (`ClaimsBasic`.`indexatie_type`)="POLICY_AND_CLAIM"
And Not (`ClaimsBasic`.`indexatie_type`)="CLAIM"));