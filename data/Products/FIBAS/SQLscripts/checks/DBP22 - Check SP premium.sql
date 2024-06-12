INSERT INTO DBPErrorTable(`Policy Nr`,`Error`,`Variable`,`Value`,`Status`)
SELECT `Policies`.`policy number`,
IF(ISNULL(`Policies`.`SP premium`),"SP premium empty","Invalid SP premium") AS `Error`,
"SP premium" AS `Variable`,
`Policies`.`SP premium` AS `value`,
`Policies`.`Quantum status` AS `Status`
FROM `Policies`
WHERE (((`Policies`.`SP premium`)<0)
    And ((`Policies`.`Quantum status`)="Active"
        Or (`Policies`.`Quantum status`)="Lapsed"))
        Or (((`Policies`.`SP premium`) Is Null
        Or (`Policies`.`SP premium`)=0)
    And ((`Policies`.`Quantum status`)="Active"
        Or (`Policies`.`Quantum status`)="Lapsed")
    And (Not (`Policies`.`premium payment`)="Monthly premium"
    And Not (Policies.`premium payment`)="Yearly premium"));