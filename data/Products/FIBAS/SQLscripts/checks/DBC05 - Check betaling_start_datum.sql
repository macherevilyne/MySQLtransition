INSERT INTO DBCErrorTable(`Claim ID`,Error,Variable,`Value`,Status)
SELECT `Claims`.`claim_id`,
IF(ISNULL(`Claims`.`betaling_start_datum`),"betaling_start_datum empty","Invalid betaling_start_datum") AS `Error`,
"betaling_start_datum" AS `Variable`,
`Claims`.`betaling_start_datum` AS `Value`,
`Claims`.`status` AS `Status`
FROM `Claims` LEFT JOIN `ClaimsBasic` ON `Claims`.`claim_id` = `ClaimsBasic`.`claim_id`
WHERE (((`Claims`.`betaling_start_datum`) Is Null
    Or (STR_TO_DATE(`Claims`.`betaling_start_datum`, '%d-%m-%Y'))<STR_TO_DATE(`eigen_risico_start_datum`, '%d-%m-%Y'))
And ((`Claims`.`reserveringen_betaald`)<0)
And ((`Claims`.`claim_type`)="DISABILITY"))
    Or (((`Claims`.`betaling_start_datum`) Is Null
    Or (STR_TO_DATE(`Claims`.`betaling_start_datum`, '%d-%m-%Y'))<STR_TO_DATE(`eigen_risico_start_datum`, '%d-%m-%Y'))
And ((`Claims`.`claim_type`)="DISABILITY")
And ((ClaimsStatus(Claims.status))<>"Terminated"));