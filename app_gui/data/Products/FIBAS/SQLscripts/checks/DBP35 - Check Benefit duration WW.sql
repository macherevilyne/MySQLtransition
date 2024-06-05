INSERT INTO DBPErrorTable(`Policy Nr`,`Error`,`Variable`,`Value`,`Status`)
SELECT `Policies`.`policy number`,
IF(ISNULL(`Policies`.`Benefit duration WW`),"Benefit duration WW empty","Invalid Benefit duration WW") AS `Error`,
"Benefit duration WW" AS `Variable`,
`Policies`.`Benefit duration WW` AS `Value`,
`Policies`.`Quantum status` AS `Status`
FROM `Policies`
WHERE (((`Policies`.`Benefit duration WW`)<>"12 months"
And (`Policies`.`Benefit duration WW`)<>"24 months")
And ((`Policies`.`Quantum status`)="Active"
    Or (`Policies`.`Quantum status`)="Lapsed")
And ((`Policies`.`WW`)="yes"));