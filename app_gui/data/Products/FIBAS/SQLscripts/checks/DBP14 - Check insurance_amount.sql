INSERT INTO DBPErrorTable(`Policy Nr`,`Error`,`Variable`,`Value`,`Status`)
SELECT `Policies`.`policy number`,
IF(ISNULL(`Policies`.`insurance_amount`),"insurance_amount empty","Invalid insurance_amount") AS `Error`,
"insurance_amount" AS `Variable`,
`Policies`.`insurance_amount` AS `Value`,
Policies.`Quantum status` AS `Status`
FROM `Policies`
WHERE (((`Policies`.`insurance_amount`)<=0)
    And ((`Policies`.`Quantum status`)="Active"
        Or (`Policies`.`Quantum status`)="Lapsed"))
        Or (((`Policies`.`insurance_amount`) Is Null)
    And ((`Policies`.`Quantum status`)="Active"
        Or (`Policies`.`Quantum status`)="Lapsed"));