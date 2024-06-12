INSERT INTO DBPErrorTable(`Policy Nr`,`Error`,`Variable`,`Value`,`Status`)
SELECT `Policies`.`policy number`,
IF(ISNULL(`Policies`.`RP premium FIB`),"RP premium FIB empty","Invalid RP premium FIB") AS `Error`,
"RP premium FIB" AS `Variable`,
`Policies`.`RP premium FIB` AS `value`,
`Policies`.`Quantum status` AS `Status`
FROM `Policies`
WHERE (((`Policies`.`RP premium FIB`)<0)
    And ((`Policies`.`Quantum status`)="Active"
        Or (`Policies`.`Quantum status`)="Lapsed"))
        Or (((`Policies`.`RP premium FIB`) Is Null
        Or (`Policies`.`RP premium FIB`)=0)
    And ((`Policies`.`Quantum status`)="Active"
        Or (`Policies`.`Quantum status`)="Lapsed")
    And ((`Policies`.`premium payment`)<>"Single premium"
    And Not (`Policies`.`premium payment`)="Combination postponed")
    And ((`Policies`.`benefit_duration_term_life`) Is Not Null
    And (`Policies`.`benefit_duration_term_life`)<>"Standard"));