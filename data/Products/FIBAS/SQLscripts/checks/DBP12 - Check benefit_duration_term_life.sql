INSERT INTO DBPErrorTable(`Policy Nr`,`Error`,`Variable`,`Value`,`Status`)
SELECT `Policies`.`policy number`,
IF(ISNULL(`Policies`.`benefit_duration_term_life`),"benefit_duration_term_life empty","Invalid benefit_duration_term_life") AS `Error`,
"benefit_duration_term_life" AS `Variable`,
`Policies`.`benefit_duration_term_life` AS `Value`,
`Policies`.`Quantum status` AS `Status`
FROM `Policies`
WHERE (((`Policies`.`benefit_duration_term_life`)<>"Basic"
    And (`Policies`.`benefit_duration_term_life`)<>"Extended"
    And (`Policies`.`benefit_duration_term_life`)<>"Short"
    And (`Policies`.`benefit_duration_term_life`)<>"Standard"
    And (`Policies`.`benefit_duration_term_life`)<>"12 months"
    And (`Policies`.`benefit_duration_term_life`)<>"24 months"
    And (`Policies`.`benefit_duration_term_life`)<>"36 months"
    And (`Policies`.`benefit_duration_term_life`)<>"48 months"
    And (`Policies`.`benefit_duration_term_life`)<>"60 months"
    And (`Policies`.`benefit_duration_term_life`)<>"72 months"
    And (`Policies`.`benefit_duration_term_life`)<>"84 months"
    And (`Policies`.`benefit_duration_term_life`)<>"96 months"
    And (`Policies`.`benefit_duration_term_life`)<>"108 months"
    And (`Policies`.`benefit_duration_term_life`)<>"120 months"
    And (`Policies`.`benefit_duration_term_life`)<>"Enddate")
    And ((`Policies`.`Quantum status`)="Active"
        Or (Policies.`Quantum status`)="Lapsed"))
        Or (((`Policies`.`benefit_duration_term_life`) Is Null)
    And ((`Policies`.`Quantum status`)="Active"
        Or (Policies.`Quantum status`)="Lapsed")
    And ((IF(LOCATE(`product`,"2010")
        Or LOCATE(`product`,"2011")
        Or (`product`="TAF GoedGezekerd AOV"
    And `policy terms`<>"QL_GG_2020_06"),201011,200809))=201011));