INSERT INTO DBPErrorTable(`Policy Nr`,`Error`,`Variable`,`Value`,`Status`)
SELECT `Policies`.`policy number`,
IF(ISNULL(`Policies`.`SP net premium FIB`),"SP net premium FIB empty","Invalid SP net premium FIB") AS `Error`,
"SP net premium FIB" AS `Variable`,
`Policies`.`SP net premium FIB` AS `value`,
`Policies`.`Quantum status` AS `Status`
FROM `Policies`
WHERE (((`Policies`.`SP net premium FIB`)<0 Or (`Policies`.`SP net premium FIB`)>`SP premium FIB`)
    And ((`Policies`.`Quantum status`)="Active"
        Or (`Policies`.`Quantum status`)="Lapsed"))
        Or (((`Policies`.`SP net premium FIB`) Is Null
        Or (`Policies`.`SP net premium FIB`)=0)
    And ((`Policies`.`Quantum status`)="Active"
        Or (`Policies`.`Quantum status`)="Lapsed")
    And ((`Policies`.`premium payment`)<>"Monthly premium"
    And (`Policies`.`premium payment`)<>"Yearly premium"
    And Not (`Policies`.`premium payment`)="Combination direct")
    And ((`Policies`.`benefit_duration_term_life`) Is Not Null
    And (`Policies`.`benefit_duration_term_life`)<>"Standard"));