INSERT INTO DBPErrorTable(`Policy Nr`,`Error`,`Variable`,`Value`,`Status`)
SELECT `Policies`.`policy number`,
IF(ISNULL(`Policies`.`RP premium`),"RP premium empty","Invalid RP premium") AS `Error`,
"SP term" AS `Variable`,
`Policies`.`SP term` AS `value`,
`Policies`.`Quantum status` AS `Status`
FROM `Policies`
WHERE (((`Policies`.`SP term`)<=0 Or (`Policies`.`SP term`)>`total_term`)
    And ((`Policies`.`Quantum status`)="Active"
        Or (`Policies`.`Quantum status`)="Lapsed"))
        Or (((Policies.`SP term`) Is Null)
    And ((`Policies`.`Quantum status`)="Active"
        Or (`Policies`.`Quantum status`)="Lapsed")
    And (Not (`Policies`.`premium payment`)="Monthly premium"
    And Not (`Policies`.`premium payment`)="Yearly premium"));