INSERT INTO DBCBErrorTable(`Claim ID`,`Error`,`Variable`,`Value`,`Status`)
SELECT `ClaimsBasic`.`claim_id`,
IF(ISNULL(`betalingsduur`),"betalingsduur empty","Invalid betalingsduur") AS `Error`,
"betalingsduur" AS `Variable`,
`ClaimsBasic`.`betalingsduur` AS `Value`,
`ClaimsBasic`.`claim_status` AS `Status`
FROM `ClaimsBasic`
WHERE (((`ClaimsBasic`.`betalingsduur`) Is Null))
    Or (((`ClaimsBasic`.`betalingsduur`)<>"Uitgebreid"
And (`ClaimsBasic`.`betalingsduur`)<>"Basis"
And (`ClaimsBasic`.`betalingsduur`)<>"Kort"
And (`ClaimsBasic`.`betalingsduur`)<>"Einde looptijd"
And (`ClaimsBasic`.`betalingsduur`)<>"24 maanden"
And (`ClaimsBasic`.`betalingsduur`)<>"120 maanden"
And (`ClaimsBasic`.`betalingsduur`)<>"108 maanden"
And (`ClaimsBasic`.`betalingsduur`)<>"96 maanden"
And (`ClaimsBasic`.`betalingsduur`)<>"84 maanden"
And (`ClaimsBasic`.`betalingsduur`)<>"72 maanden"
And (`ClaimsBasic`.`betalingsduur`)<>"60 maanden"
And (`ClaimsBasic`.`betalingsduur`)<>"48 maanden"
And (`ClaimsBasic`.`betalingsduur`)<>"36 maanden"));