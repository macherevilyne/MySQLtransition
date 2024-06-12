INSERT INTO DBPErrorTable(`Policy Nr`,`Error`,`Variable`,`Value`,`Status`)
SELECT `Policies`.`policy number`,
IF(ISNULL(`Policies`.`benefit_duration`),"benefit_duration empty","Invalid benefit_duration") AS `Error`,
"benefit_duration" AS `Variable`,
`Policies`.`benefit_duration` AS `Value`,
`Policies`.`Quantum status` AS `Status`
FROM `Policies`
WHERE (((`Policies`.`benefit_duration`)<>"Basic"
    And (`Policies`.`benefit_duration`)<>"Extended"
    And (`Policies`.`benefit_duration`)<>"Short"
    And Not (`Policies`.`benefit_duration`)="12 months"
    And Not (`Policies`.`benefit_duration`)="24 months"
    And Not (`Policies`.`benefit_duration`)="36 months"
    And Not (`Policies`.`benefit_duration`)="48 months"
    And Not (`Policies`.`benefit_duration`)="60 months"
    And Not (`Policies`.`benefit_duration`)="72 months"
    And Not (`Policies`.`benefit_duration`)="84 months"
    And Not (`Policies`.`benefit_duration`)="96 months"
    And Not (`Policies`.`benefit_duration`)="108 months"
    And Not (`Policies`.`benefit_duration`)="120 months"
    And Not (`Policies`.`benefit_duration`)="Enddate")
    And ((`Policies`.`Quantum status`)="Active"
        Or (`Policies`.`Quantum status`)="Lapsed"))
        Or (((`Policies`.`benefit_duration`) Is Null)
    And ((`Policies`.`Quantum status`)="Active"
        Or (`Policies`.`Quantum status`)="Lapsed"));