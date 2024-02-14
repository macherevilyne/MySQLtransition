INSERT INTO DBPErrorTable(`Policy Nr`,`Error`,`Variable`,`Value`,`Status`)
SELECT `Policies`.`policy number`,
IF(ISNULL(`Policies`.`indexation percentage`),"Indexation percentage empty","Invalid indexation percentage") AS `Error`,
"indexation percentage" AS `Variable`,
`Policies`.`indexation percentage` AS `Value`,
`Policies`.`Quantum status` AS `Status`
FROM `Policies`
WHERE (((`Policies`.`indexation percentage`)<0
    Or (`Policies`.`indexation percentage`)>3)
And ((`Policies`.`Quantum status`)="Active"
    Or (`Policies`.`Quantum status`)="Lapsed")
And ((`Policies`.`indexation type`)="POLICY_AND_CLAIM"
    Or (`Policies`.`indexation type`)="CLAIM"))
    Or (((`Policies`.`indexation percentage`) Is Null)
And ((`Policies`.`Quantum status`)="Active"
    Or (`Policies`.`Quantum status`)="Lapsed")
And ((`Policies`.`indexation type`)="POLICY_AND_CLAIM"
    Or (`Policies`.`indexation type`)="CLAIM"));