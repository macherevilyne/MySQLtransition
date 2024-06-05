INSERT INTO DBPErrorTable(`Policy Nr`,`Error`,`Variable`,`Value`,`Status`)
SELECT `Policies`.`policy number`,
"Invalid indexation type" AS `Error`,
"indexation type" AS `Variable`,
`Policies`.`indexation type` AS `Value`,
`Policies`.`Quantum status` AS `Status`
FROM `Policies`
WHERE (((`Policies`.`indexation type`)<>"NO_INDEXATION"
And (`Policies`.`indexation type`)<>"POLICY_AND_CLAIM"
And Not (`Policies`.`indexation type`)="CLAIM")
And ((`Policies`.`Quantum status`)="Active"
    Or (`Policies`.`Quantum status`)="Lapsed"));