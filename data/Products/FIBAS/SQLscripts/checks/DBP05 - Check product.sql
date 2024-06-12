INSERT INTO DBPErrorTable(`Policy Nr`,`Error`,`Variable`,`Value`,`Status`)
SELECT `Policies`.`policy number`,
IF(ISNULL(`Policies`.`product`),"product empty","Invalid product") AS `Error`,
"product" AS `Variable`,
`Policies`.`product` AS `Value`,
`Policies`.`Quantum status` AS `Status`
FROM `Policies`
WHERE (((`Policies`.`product`)<>"TAF Maandlastbeschermer"
    And (`Policies`.`product`)<>"TAF Maandlastbeschermer Q"
    And (`Policies`.`product`)<>"TAF Maandlastbeschermer 2010"
    And (`Policies`.`product`)<>"TAF Maandlastbeschermer 2011"
    And (`Policies`.`product`)<>"TAF STC Maandlastbeschermer"
    And (`Policies`.`product`)<>"TAF Zelfstandigenplan"
    And (`Policies`.`product`)<>"TAF Zelfstandigenplan Q"
    And (`Policies`.`product`)<>"TAF Zelfstandigenplan 2010"
    And (`Policies`.`product`)<>"TAF Zelfstandigenplan 2011"
    And (`Policies`.`product`)<>"TAF GoedGezekerd AOV"
    And (`Policies`.`product`)<>"TAF Maandlastbeschermer Zelfstandige")
    And ((`Policies`.`Quantum status`)="Active"
        Or (`Policies`.`Quantum status`)="Lapsed"))
        Or (((`Policies`.`product`) Is Null)
    And ((`Policies`.`Quantum status`)="Active"
        Or (`Policies`.`Quantum status`)="Lapsed"));