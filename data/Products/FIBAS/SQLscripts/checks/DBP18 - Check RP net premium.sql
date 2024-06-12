INSERT INTO DBPErrorTable(`Policy Nr`,`Error`,`Variable`,`Value`,`Status`)
SELECT `Policies`.`policy number`,
IF(ISNULL(`Policies`.`RP net premium`),"RP net premium empty","Invalid RP net premium") AS `Error`,
"RP net premium" AS `Variable`,
`Policies`.`RP net premium` AS `value`,
`Policies`.`Quantum status` AS `Status`
FROM `Policies`
WHERE (((`Policies`.`RP net premium`)<0 Or (`Policies`.`RP net premium`)>`RP premium`)
    And ((`Policies`.`Quantum status`)="Active"
        Or (`Policies`.`Quantum status`)="Lapsed"))
        Or (((`Policies`.`RP net premium`) Is Null
        Or (`Policies`.`RP net premium`)=0)
    And ((`Policies`.`Quantum status`)="Active"
        Or (`Policies`.`Quantum status`)="Lapsed")
    And ((`Policies`.`premium payment`)<>"Single premium"));