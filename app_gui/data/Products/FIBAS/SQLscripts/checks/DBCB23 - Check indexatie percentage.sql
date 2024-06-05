INSERT INTO DBCBErrorTable(`Claim ID`,`Error`,`Variable`,`Value`,`Status`)
SELECT `ClaimsBasic`.`claim_id`,
IF(ISNULL(`indexatie_percentage`),"Indexatie percentage empty","Invalid indexatie percentage") AS `Error`,
"indexatie percentage" AS `Variable`,
`ClaimsBasic`.`indexatie_percentage` AS `Value`,
`ClaimsBasic`.`claim_status` AS `Status`
FROM `ClaimsBasic`
WHERE (((`ClaimsBasic`.`indexatie_percentage`)<0
    Or (`ClaimsBasic`.`indexatie_percentage`)>3))
    Or (((`ClaimsBasic`.`indexatie_percentage`) Is Null)
And ((`ClaimsBasic`.`indexatie_type`)="POLICY_AND_CLAIM"
    Or (`ClaimsBasic`.`indexatie_type`)="CLAIM"));