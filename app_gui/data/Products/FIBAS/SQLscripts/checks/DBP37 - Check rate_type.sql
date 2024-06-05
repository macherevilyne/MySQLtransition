INSERT INTO DBPErrorTable(`Policy Nr`,`Error`,`Variable`,`Value`,`Status`)
SELECT `Policies`.`policy number`,
IF(ISNULL(`Policies`.`rate_type`),"rate_type empty","Invalid rate_type") AS `Error`,
"rate_type" AS `Variable`,
`Policies`.`rate_type` AS `Value`,
`Policies`.`Quantum status` AS `Status`
FROM `Policies`
WHERE (((`Policies`.`rate_type`)<>"Standard"
And (`Policies`.`rate_type`)<>"Combi")
And ((`Policies`.`Quantum status`)="Active"
    Or (`Policies`.`Quantum status`)="Lapsed")
And ((`Policies`.`policy terms`)="QL_GG_2020_06"))
    Or (((`Policies`.`rate_type`) Is Null)
And ((`Policies`.`Quantum status`)="Active"
    Or (`Policies`.`Quantum status`)="Lapsed")
And ((`Policies`.`policy terms`)="QL_GG_2020_06"));