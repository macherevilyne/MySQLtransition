INSERT INTO DBPErrorTable(`Policy Nr`,`Error`,`Variable`,`Value`,`Status`)
SELECT Policies.`policy number`,
IF(ISNULL(`Policies`.`mental diseases`),"mental diseases empty","Invalid mental diseases") AS `Error`,
"mental diseases" AS `Variable`,
`Policies`.`mental diseases` AS `Value`,
`Policies`.`Quantum status` AS `Status`
FROM `Policies`
WHERE (((`Policies`.`mental diseases`)<>"Yes"
    And (`Policies`.`mental diseases`)<>"No")
    And ((`Policies`.`Quantum status`)="Active"
        Or (`Policies`.`Quantum status`)="Lapsed"))
        Or (((`Policies`.`mental diseases`) Is Null)
    And ((`Policies`.`Quantum status`)="Active"
        Or (`Policies`.`Quantum status`)="Lapsed")
    And ((IF(LOCATE(`product`,"2011"),2011,200810))=2011
        Or (IF(LOCATE(`product`,"2011"),2011,200810))=2012));