INSERT INTO DBCBErrorTable(`Claim ID`,`Error`,`Variable`,`Value`,`Status`)
SELECT `ClaimsBasic`.`claim_id`,
IF(ISNULL(`polis_voorwaarden`),"polis_voorwaarden empty","Invalid polis_voorwaarden") AS `Error`,
"polis_voorwaarden" AS `Variable`,
`ClaimsBasic`.`polis_voorwaarden` AS `Value`,
`ClaimsBasic`.`claim_status` AS `Status`
FROM `ClaimsBasic`
WHERE (((`ClaimsBasic`.`polis_voorwaarden`)<>"QL_GF_06_2008"
And (`ClaimsBasic`.`polis_voorwaarden`)<>"QL_MLB_01_2010"
And (`ClaimsBasic`.`polis_voorwaarden`)<>"QL_MLB_04_2011"
And (`ClaimsBasic`.`polis_voorwaarden`)<>"QL_MLB_06_2008"
And (`ClaimsBasic`.`polis_voorwaarden`)<>"QL_STC_MLB_04_2010"
And (`ClaimsBasic`.`polis_voorwaarden`)<>"QL_ZP_06_2008"
And (`ClaimsBasic`.`polis_voorwaarden`)<>"QL_ZP_07_2009"
And (`ClaimsBasic`.`polis_voorwaarden`)<>"QL_ZSP_01_2010"
And (`ClaimsBasic`.`polis_voorwaarden`)<>"QL_ZSP_08_2011_A"
And (`ClaimsBasic`.`polis_voorwaarden`)<>"QL_ZSP_08_2011_B"
And (`ClaimsBasic`.`polis_voorwaarden`)<>"QL_GG_09_2012"
And (`ClaimsBasic`.`polis_voorwaarden`)<>"QL_GG_12_2012"
And (`ClaimsBasic`.`polis_voorwaarden`)<>"QL_MLB_12_2012"
And (`ClaimsBasic`.`polis_voorwaarden`)<>"QL_GG_03_2015"
And (`ClaimsBasic`.`polis_voorwaarden`)<>"QL_MLBK_03_2014"
And (`ClaimsBasic`.`polis_voorwaarden`)<>"QL_MLBK_11_2015"
And (`ClaimsBasic`.`polis_voorwaarden`)<>"QL_MLB_06_2019"
And (`ClaimsBasic`.`polis_voorwaarden`)<>"QL_GG_2020_06"
And  (`ClaimsBasic`.`polis_voorwaarden`)<>"QL_MLB_2021_02"  ))
    Or (((`ClaimsBasic`.`polis_voorwaarden`) Is Null));