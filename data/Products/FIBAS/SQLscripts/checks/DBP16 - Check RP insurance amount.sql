INSERT INTO DBPErrorTable(`Policy Nr`,`Error`,`Variable`,`Value`,`Status`)
SELECT `Policies`.`policy number`,
IF(ISNULL(`Policies`.`RP insurance amount`),"RP insurance amount empty","Invalid RP insurance amount") AS `Error`,
"RP insurance amount" AS `Variable`,
`Policies`.`RP insurance amount` AS `value`,
`Policies`.`Quantum status` AS `Status`
FROM `Policies`
WHERE (((`Policies`.`RP insurance amount`)<=0 Or (`Policies`.`RP insurance amount`)>`insurance_amount`)
    And ((`Policies`.`Quantum status`)="Active"
        Or (`Policies`.`Quantum status`)="Lapsed"))
        Or (((`Policies`.`RP insurance amount`) Is Null
        Or (`Policies`.`RP insurance amount`)=`insurance_amount`)
    And ((`Policies`.`Quantum status`)="Active"
        Or (`Policies`.`Quantum status`)="Lapsed")
    And ((`Policies`.`premium payment`)="combination direct"));