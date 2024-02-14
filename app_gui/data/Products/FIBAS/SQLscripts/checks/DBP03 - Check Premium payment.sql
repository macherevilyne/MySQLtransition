INSERT INTO DBPErrorTable(`Policy Nr`,`Error`,`Variable`,`Value`,`Status`)
SELECT `Policies`.`policy number`,
IF(ISNULL(`Policies`.`Premium payment`),"Premium payment empty","Invalid Premium payment") AS `Error`,
"Premium payment" AS `Variable`,
`Policies`.`Premium payment` AS `Value`,
`Policies`.`Quantum status` AS `Status`
FROM `Policies`
WHERE (((`Policies`.`Premium payment`)<>"Monthly premium"
    And (`Policies`.`Premium payment`)<>"Yearly premium"
    And (`Policies`.`Premium payment`)<>"Single premium"
    And (`Policies`.`Premium payment`)<>"Combination direct"
    And (`Policies`.`Premium payment`)<>"Combination postponed")
    And ((`Policies`.`Quantum status`)="Active" Or (`Policies`.`Quantum status`)="Lapsed")) Or (((`Policies`.`Premium payment`) Is Null)
    And ((`Policies`.`Quantum status`)="Active" Or (`Policies`.`Quantum status`)="Lapsed"));