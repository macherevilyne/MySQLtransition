INSERT INTO DBPErrorTable(`Policy Nr`,`Error`,`Variable`,`Value`,`Status`)
SELECT `Policies`.`policy number`,
IF(ISNULL(`Policies`.`En Block 2011`),"En Block 2011 empty","Invalid En Block 2011") AS `Error`,
"En Block 2011" AS `Variable`,
`Policies`.`En Block 2011` AS `Value`,
`Policies`.`Quantum status` AS `Status`
FROM `Policies`
WHERE (((`Policies`.`En Block 2011`)<0)
    And ((`Policies`.`Quantum status`)="Active"
        Or (`Policies`.`Quantum status`)="Lapsed"))
        Or (((`Policies`.`En Block 2011`) Is Null)
    And ((`Policies`.`Quantum status`)="Active"
        Or (`Policies`.`Quantum status`)="Lapsed")
    And ((`Policies`.`premium payment`)<>"Single premium"))
        Or ((Not (`Policies`.`En Block 2011`)=0)
    And ((`Policies`.`premium payment`)="Single premium"
        Or (`Policies`.`premium payment`)="Yearly premium"));