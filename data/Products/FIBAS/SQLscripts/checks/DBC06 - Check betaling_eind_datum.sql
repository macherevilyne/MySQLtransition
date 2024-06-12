INSERT INTO DBCErrorTable(`Claim ID`,`Error`,`Variable`,`Value`,`Status`)
SELECT `Claims`.`claim_id`,
IF(ISNULL(`betaling_eind_datum`),"betaling_eind_datum empty","Invalid betaling_eind_datum") AS `Error`,
"betaling_eind_datum" AS `Variable`,
`Claims`.`betaling_eind_datum` AS `Value`,
`Claims`.`status` AS `Status`
FROM `Claims` LEFT JOIN `CustomPayments` ON `Claims`.`claim_id` = `CustomPayments`.`claim_id`
WHERE (((`Claims`.`betaling_eind_datum`) Is Null
    Or (STR_TO_DATE(`Claims`.`betaling_eind_datum`, '%d-%m-%Y'))<STR_TO_DATE(`betaling_start_datum`, '%d-%m-%Y'))
And ((`Claims`.`reserveringen_betaald`)<0)
And ((`CustomPayments`.`Type`) Is Null Or (`CustomPayments`.`Type`)="Other")
And ((`Claims`.`claim_type`)="DISABILITY"))
    Or (((`Claims`.`betaling_eind_datum`) Is Null
    Or (STR_TO_DATE(`Claims`.`betaling_eind_datum`, '%d-%m-%Y'))<STR_TO_DATE(`betaling_start_datum`, '%d-%m-%Y'))
And ((`CustomPayments`.`Type`) Is Null Or (`CustomPayments`.`Type`)="Other")
And ((`Claims`.`claim_type`)="DISABILITY")
And ((ClaimsStatus(`status`))<>"Terminated"));