INSERT INTO DBCBErrorTable(`Claim ID`,`Error`,`Variable`,`Value`,`Status`)
SELECT `ClaimsBasic`.`claim_id`,
IF(ISNULL(`ongeschiktheidsniveau`),"ongeschiktheidsniveau empty","Invalid ongeschiktheidsniveau") AS `Error`,
"ongeschiktheidsniveau" AS `Variable`,
`ClaimsBasic`.`ongeschiktheidsniveau` AS `Value`,
`ClaimsBasic`.`claim_status` AS `Status`
FROM `ClaimsBasic`
WHERE (((`ClaimsBasic`.`ongeschiktheidsniveau`)<>"25%"
And (`ClaimsBasic`.`ongeschiktheidsniveau`)<>"35%"
And (`ClaimsBasic`.`ongeschiktheidsniveau`)<>"80%"
And (`ClaimsBasic`.`ongeschiktheidsniveau`)<>"45%"
And (`ClaimsBasic`.`ongeschiktheidsniveau`)<>"55%"
And (`ClaimsBasic`.`ongeschiktheidsniveau`)<>"65%"))
    Or (((`ClaimsBasic`.`ongeschiktheidsniveau`) Is Null)
And ((`ClaimsBasic`.`betalingsduur`)="uitgebreid"
    Or (`ClaimsBasic`.`betalingsduur`)="basis"));