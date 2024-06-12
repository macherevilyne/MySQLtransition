INSERT INTO DBPErrorTable(`Policy Nr`,`Error`,`Variable`,`Value`,`Status`)
SELECT `Policies`.`policy number`,
IF(ISNULL(`Policies`.`waiting time`),"waiting time empty","Invalid waiting time") AS `Error`,
"waiting time" AS `Variable`,
`Policies`.`waiting time` AS `Value`,
`Policies`.`Quantum status` AS `Status`
FROM `Policies`
WHERE (((`Policies`.`waiting time`)<>30
    And (`Policies`.`waiting time`)<>90
    And (`Policies`.`waiting time`)<>365
    And (`Policies`.`waiting time`)<>730
    And Not (`Policies`.`waiting time`)=60
    And Not (`Policies`.`waiting time`)=120
    And Not (`Policies`.`waiting time`)=150
    And Not (`Policies`.`waiting time`)=180
    And Not (`Policies`.`waiting time`)=210
    And Not (`Policies`.`waiting time`)=240
    And Not (`Policies`.`waiting time`)=270
    And Not (`Policies`.`waiting time`)=300
    And Not (`Policies`.`waiting time`)=330)
    And ((`Policies`.`Quantum status`)="Active"
        Or (`Policies`.`Quantum status`)="Lapsed"))
        Or (((`Policies`.`waiting time`) Is Null)
    And ((`Policies`.`Quantum status`)="Active"
        Or (`Policies`.`Quantum status`)="Lapsed"));