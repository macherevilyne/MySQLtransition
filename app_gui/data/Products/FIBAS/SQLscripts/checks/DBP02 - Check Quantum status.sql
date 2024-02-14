INSERT INTO DBPErrorTable(`Policy Nr`,`Error`,`Variable`,`Value`,`Status`)
SELECT `Policies`.`policy number`,
IF(ISNULL(`Quantum status`),"Quantum status empty","Invalid Quantum status") AS `Error`,
"Quantum status" AS `Variable`,
`Policies`.`Quantum status` AS `Value`,
`Policies`.`Quantum status` AS `Status`
FROM `Policies`
WHERE (((`Policies`.`Quantum status`)<>"Active"
    And (`Policies`.`Quantum status`)<>"Lapsed"
    And (`Policies`.`Quantum status`)<>"Other")) OR (((Policies.`Quantum status`) Is Null));