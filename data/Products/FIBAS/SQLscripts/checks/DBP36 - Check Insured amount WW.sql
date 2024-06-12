INSERT INTO DBPErrorTable(`Policy Nr`,`Error`,`Variable`,`Value`,`Status`)
SELECT `Policies`.`policy number`,
IF(ISNULL(`Policies`.`Insured amount WW`),"Insured amount WW empty","Invalid Insured amount WW") AS `Error`,
"Insured amount WW" AS Variable,
`Policies`.`Insured amount WW` AS `Value`,
`Policies`.`Quantum status` AS `Status`
FROM `Policies`
WHERE (((`Policies`.`Insured amount WW`)<=0)
And ((`Policies`.`Quantum status`)="Active"
    Or (`Policies`.`Quantum status`)="Lapsed")
And ((`Policies`.`WW`)="yes"))
    Or (((`Policies`.`Insured amount WW`) Is Null)
And ((`Policies`.`Quantum status`)="Active"
    Or (`Policies`.`Quantum status`)="Lapsed")
And ((`Policies`.`WW`)="yes"));