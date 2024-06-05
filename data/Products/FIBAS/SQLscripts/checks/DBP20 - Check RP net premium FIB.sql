INSERT INTO DBPErrorTable(`Policy Nr`,`Error`,`Variable`,`Value`,`Status`)
SELECT `Policies`.`policy number`,
IF(ISNULL(`Policies`.`RP net premium FIB`),"RP net premium FIB empty","Invalid RP net premium FIB") AS `Error`,
"RP net premium FIB" AS `Variable`,
`Policies`.`RP net premium FIB` AS `value`,
`Policies`.`Quantum status` AS `Status`
FROM `Policies`
WHERE (((`Policies`.`RP net premium FIB`)<0 Or (`Policies`.`RP net premium FIB`)>`RP premium FIB`)
    And ((`Policies`.`Quantum status`)="Active"
        Or (`Policies`.`Quantum status`)="Lapsed"))
        Or (((`Policies`.`RP net premium FIB`) Is Null
        Or (`Policies`.`RP net premium FIB`)=0)
    And ((`Policies`.`Quantum status`)="Active"
        Or (`Policies`.`Quantum status`)="Lapsed")
    And ((`Policies`.`premium payment`)<>"Single premium"
    And Not (`Policies`.`premium payment`)="Combination postponed")
    And ((`Policies`.`benefit_duration_term_life`) Is Not Null
    And (`Policies`.`benefit_duration_term_life`)<>"Standard"));