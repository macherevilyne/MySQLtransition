INSERT INTO DBPErrorTable(`Policy Nr`,`Error`,`Variable`,`Value`,`Status`)
SELECT `Policies`.`policy number`, IF(ISNULL(`Policies`.`policy terms`),"policy terms empty","Invalid policy terms") AS `Error`,
"policy terms" AS `Variable`,
`Policies`.`policy terms` AS `Value`,
`Policies`.`Quantum status` AS `Status`
FROM `Policies`
WHERE (((`Policies`.`policy terms`)<>"QL_GF_06_2008"
And (`Policies`.`policy terms`)<>"QL_MLB_01_2010"
And (`Policies`.`policy terms`)<>"QL_MLB_04_2011"
And (`Policies`.`policy terms`)<>"QL_MLB_06_2008"
And (`Policies`.`policy terms`)<>"QL_STC_MLB_04_2010"
And (`Policies`.`policy terms`)<>"QL_ZP_06_2008"
And (`Policies`.`policy terms`)<>"QL_ZP_07_2009"
And (`Policies`.`policy terms`)<>"QL_ZSP_01_2010"
And (`Policies`.`policy terms`)<>"QL_ZSP_08_2011_A"
And (`Policies`.`policy terms`)<>"QL_ZSP_08_2011_B"
And (`Policies`.`policy terms`)<>"QL_GG_09_2012"
And (`Policies`.`policy terms`)<>"QL_GG_12_2012"
And (`Policies`.`policy terms`)<>"QL_MLB_12_2012"
And (`Policies`.`policy terms`)<>"QL_MLBK_03_2014"
And (`Policies`.`policy terms`)<>"QL_GG_03_2015"
And (`Policies`.`policy terms`)<>"QL_MLBK_11_2015"
And (`Policies`.`policy terms`)<>"QL_MLB_06_2019"
And (`Policies`.`policy terms`)<>"QL_GG_2020_06"
And (`Policies`.`policy terms`)<>"QL_MLB_2021_02"
And (`Policies`.`policy terms`)<>"QL_GG_2020_06"
And (`Policies`.`policy terms`)<>"QL_MLB_2021_11"
And (`Policies`.`policy terms`)<>"QL_MLBZ_2022_02")
And ((`Policies`.`Quantum status`)="Active"
    Or (Policies.`Quantum status`)="Lapsed"))
    Or (((Policies.`policy terms`) Is Null)
And ((`Policies`.`Quantum status`)="Active"
    Or (Policies.`Quantum status`)="Lapsed"));