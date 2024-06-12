INSERT INTO DBCBErrorTable(`Claim ID`,`Error`,`Variable`,`Value`,`Status`)
SELECT `ClaimsBasic`.`claim_id`,
IF(ISNULL(`ClaimsBasic`.`betaling_eind_datum`),"betaling_eind_datum empty","Invalid betaling_eind_datum") AS `Error`,
"betaling_eind_datum" AS `Variable`,
`ClaimsBasic`.`betaling_eind_datum` AS `Value`,
`ClaimsBasic`.`claim_status` AS `Status`
FROM (`ClaimsBasic` LEFT JOIN `Claims` ON `ClaimsBasic`.`claim_id` = `Claims`.`claim_id`)
    LEFT JOIN `CustomPayments` ON `ClaimsBasic`.`claim_id` = `CustomPayments`.`claim_id`
WHERE (((`ClaimsBasic`.`betaling_eind_datum`) Is Null
    Or (STR_TO_DATE(`ClaimsBasic`.`betaling_eind_datum`, '%d-%m-%Y'))<STR_TO_DATE(`ClaimsBasic`.`betaling_start_datum`, '%d-%m-%Y'))
And ((ClaimsStatus(`ClaimsBasic`.`claim_status`))<>"Terminated")
And ((`ClaimsBasic`.`type`)="DISABILITY"))
    Or (((`ClaimsBasic`.`betaling_eind_datum`) Is Null
    Or (STR_TO_DATE(`ClaimsBasic`.`betaling_eind_datum`, '%d-%m-%Y'))<STR_TO_DATE(`ClaimsBasic`.`betaling_start_datum`, '%d-%m-%Y'))
And ((`ClaimsBasic`.`type`)="DISABILITY")
And ((`Claims`.`reserveringen_betaald`)<0)
And ((`CustomPayments`.`Type`) Is Null Or (`CustomPayments`.`Type`)="Other"));