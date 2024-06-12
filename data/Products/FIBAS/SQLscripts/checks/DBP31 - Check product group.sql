INSERT INTO DBPErrorTable(`Policy Nr`,`Error`,`Variable`,`Value`,`Status`)
SELECT `Policies`.`policy number`,
IF(ISNULL(`Policies`.`product group`),"product group empty","Invalid product group") AS `Error`,
"product group" AS `Variable`,
`Policies`.`product group` AS `Value`,
`Policies`.`Quantum status` AS `Status`
FROM `Policies`
WHERE (((`Policies`.`product group`)<>"ZSP"
And (`Policies`.`product group`)<>"MLB")
And ((`Policies`.`Quantum status`)="Active"
    Or (`Policies`.`Quantum status`)="Lapsed"))
    Or (((`Policies`.`product group`) Is Null)
And ((`Policies`.`Quantum status`)="Active"
    Or (`Policies`.`Quantum status`)="Lapsed"));