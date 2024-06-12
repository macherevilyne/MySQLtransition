INSERT INTO DBPErrorTable(`Policy Nr`,`Error`,`Variable`,`Value`,`Status`)
SELECT `Policies`.`policy number`,
IF(ISNULL(`Policies`.`WW`),"WW empty","Invalid WW") AS `Error`,
"WW" AS `Variable`,
`Policies`.`WW` AS `Value`,
`Policies`.`Quantum status` AS `Status`
FROM `Policies`
WHERE ((Not (`Policies`.`WW`)="yes"
And Not (`Policies`.WW)="no")
And ((`Policies`.`Quantum status`)="Active"
    Or (`Policies`.`Quantum status`)="Lapsed"))
    Or (((`Policies`.`WW`) Is Null)
And ((`Policies`.`Quantum status`)="Active"
    Or (`Policies`.`Quantum status`)="Lapsed"));