INSERT INTO DBCBErrorTable(`Claim ID`,`Error`,`Variable`,`Value`,`Status`)
SELECT `ClaimsBasic`.`claim_id`,
IF(ISNULL(`premie_betaling`),"premie_betaling empty","Invalid premie_betaling") AS `Error`,
"premie_betaling" AS `Variable`,
`ClaimsBasic`.`premie_betaling` AS `Value`,
`ClaimsBasic`.`claim_status` AS `Status`
FROM `ClaimsBasic`
WHERE (((`ClaimsBasic`.`premie_betaling`) Is Null))
    Or ((Not (`ClaimsBasic`.`premie_betaling`)="Combinatie direct (maand)"
And Not (`ClaimsBasic`.`premie_betaling`)="Combinatie uitgesteld (maand)"
And Not (`ClaimsBasic`.`premie_betaling`)="Maandpremie"
And Not (`ClaimsBasic`.`premie_betaling`)="Jaarpremie"
And Not (`ClaimsBasic`.`premie_betaling`)="Koopsom"));