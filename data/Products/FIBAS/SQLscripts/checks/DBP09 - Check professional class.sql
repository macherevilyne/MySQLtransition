INSERT INTO DBPErrorTable(`Policy Nr`,`Error`,`Variable`,`Value`,`Status`)
SELECT `Policies`.`policy number`,
IF(ISNULL(`Policies`.`professional class`),"professional class empty","Invalid professional class") AS `Error`,
"professional class" AS `Variable`,
`Policies`.`professional class` AS `Value`,
`Policies`.`Quantum status` AS `Status`
FROM `Policies`
WHERE (((`Policies`.`professional class`)<>"1"
    And (`Policies`.`professional class`)<>"2"
    And (`Policies`.`professional class`)<>"3"
    And (`Policies`.`professional class`)<>"4"
    And (`Policies`.`professional class`)<>"5")
    And ((`Policies`.`Quantum status`)="Active"
        Or (`Policies`.`Quantum status`)="Lapsed"))
        Or (((`Policies`.`professional class`) Is Null)
    And ((`Policies`.`Quantum status`)="Active"
        Or (`Policies`.`Quantum status`)="Lapsed")
    And ((IF(LOCATE(`product`,"2011")
        Or LOCATE(`product`,"2010")
        Or `product`="TAF GoedGezekerd AOV",201011,200809))=201011)
    And ((`Policies`.`product group`)="ZSP"));