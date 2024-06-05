INSERT INTO DBPErrorTable(`Policy Nr`,`Error`,`Variable`,`Value`,`Status`)
SELECT `Policies`.`policy number`,
IF(ISNULL(`Policies`.`SP net premium`),"SP net premium empty","Invalid SP net premium") AS `Error`,
"SP net premium" AS `Variable`,
`Policies`.`SP net premium` AS `value`,
`Policies`.`Quantum status` AS `Status`
FROM `Policies`
WHERE (((`Policies`.`SP net premium`)<-10 Or (`Policies`.`SP net premium`)>`SP premium`)
    And ((`Policies`.`Quantum status`)="Active"
        Or (`Policies`.`Quantum status`)="Lapsed"))
        Or (((`Policies`.`SP net premium`) Is Null)
    And ((`Policies`.`Quantum status`)="Active"
        Or (`Policies`.`Quantum status`)="Lapsed")
    And ((`Policies`.`premium payment`)<>"Monthly premium"
    And (`Policies`.`premium payment`)<>"Yearly premium"))
        Or ((Not (`Policies`.`policy number`)="8111479")
    And ((`Policies`.`SP net premium`)<=0)
    And ((`Policies`.`Quantum status`)="Active"
        Or (`Policies`.`Quantum status`)="Lapsed"));