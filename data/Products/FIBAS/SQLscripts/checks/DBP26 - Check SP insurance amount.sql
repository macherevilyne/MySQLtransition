INSERT INTO DBPErrorTable(`Policy Nr`,`Error`,`Variable`,`Value`,`Status`)
SELECT `Policies`.`policy number`,
IF(ISNULL(`Policies`.`SP insurance amount`),"SP insurance amount empty","Invalid SP insurance amount") AS `Error`,
"SP insurance amount" AS `Variable`,
`Policies`.`SP insurance amount` AS `value`,
`Policies`.`Quantum status` AS Status
FROM `Policies`
WHERE (((`Policies`.`SP insurance amount`)<=0 Or (`Policies`.`SP insurance amount`)>`insurance_amount`)
    And ((`Policies`.`Quantum status`)="Active"
        Or (`Policies`.`Quantum status`)="Lapsed"))
        Or (((`Policies`.`SP insurance amount`) Is Null)
    And ((`Policies`.`Quantum status`)="Active"
        Or (`Policies`.`Quantum status`)="Lapsed")
    And (Not (`Policies`.`premium payment`)="Monthly premium"
    And Not (`Policies`.`premium payment`)="Yearly premium"))
        Or (((`Policies`.`SP insurance amount`)=`insurance_amount`)
    And ((`Policies`.`Quantum status`)="Active"
        Or (`Policies`.`Quantum status`)="Lapsed")
    And ((`Policies`.`premium payment`)="Combination direct"));