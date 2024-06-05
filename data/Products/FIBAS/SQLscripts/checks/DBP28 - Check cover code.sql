INSERT INTO DBPErrorTable(`Policy Nr`,`Error`,`Variable`,`Value`,`Status`)
SELECT `Policies`.`policy number`,
IF(ISNULL(`Policies`.`cover code`),"cover code empty","Invalid cover code") AS `Error`,
"cover code" AS `Variable`,
`Policies`.`cover code` AS `Value`,
`Policies`.`Quantum status` AS `Status`
FROM `Policies`
WHERE (((`Policies`.`Quantum status`)="Active" Or (`Policies`.`Quantum status`)="Lapsed")
    And ((CheckList(`cover code`))=False))
        Or (((`Policies`.`cover code`) Is Null)
    And ((`Policies`.`Quantum status`)="Active"
        Or (`Policies`.`Quantum status`)="Lapsed"));