INSERT INTO DBPErrorTable(`Policy Nr`,`Error`,`Variable`,`Value`,`Status`)
SELECT `Policies`.`policy number`,
IF(ISNULL(`Policies`.`cancellation date`),"cancellation date empty","Invalid cancellation date") AS `Error`,
"cancellation date" AS `Variable`,
`Policies`.`cancellation date` AS `Value`,
`Policies`.`Quantum status` AS `Status`
FROM `Policies`
WHERE (((`Policies`.`cancellation date`) Is Null)
And ((`Policies`.`Quantum status`)="Lapsed"));