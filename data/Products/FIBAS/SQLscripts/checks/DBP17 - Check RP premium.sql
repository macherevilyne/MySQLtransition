INSERT INTO DBPErrorTable(`Policy Nr`,`Error`,`Variable`,`Value`,`Status`)
SELECT `Policies`.`policy number`,
IF(ISNULL(`Policies`.`RP premium`),"RP premium empty","Invalid RP premium") AS `Error`,
"RP premium" AS `Variable`,
`Policies`.`RP premium` AS `value`,
`Policies`.`Quantum status` AS `Status`
FROM `Policies`
WHERE (((`Policies`.`RP premium`)<0)
    And ((`Policies`.`Quantum status`)="Active"
        Or (`Policies`.`Quantum status`)="Lapsed"))
        Or (((`Policies`.`RP premium`) Is Null
        Or (`Policies`.`RP premium`)=0)
    And ((`Policies`.`Quantum status`)="Active"
        Or (`Policies`.`Quantum status`)="Lapsed")
    And (Not (`Policies`.`premium payment`)="Single premium"));