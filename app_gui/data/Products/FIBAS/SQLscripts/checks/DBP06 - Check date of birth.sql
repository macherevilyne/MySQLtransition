INSERT INTO DBPErrorTable(`Policy Nr`,`Error`,`Variable`,`Value`,`Status`)
SELECT `Policies`.`policy number`,
IF(ISNULL(`Policies`.`date of birth`),"date of birth empty","Invalid date of birth") AS `Error`,
"date of birth" AS `Variable`,
`Policies`.`date of birth` AS `Value`,
`Policies`.`Quantum status` AS `Status`
FROM `Policies`
WHERE (((STR_TO_DATE(`Policies`.`date of birth`, '%d-%m-%Y'))<STR_TO_DATE('01.01.1900', '%d.%m.%Y') Or (STR_TO_DATE(`Policies`.`date of birth`, '%d-%m-%Y'))>STR_TO_DATE('01.01.2012', '%d.%m.%Y'))
    And ((`Policies`.`Quantum status`)="Active"
        Or (`Policies`.`Quantum status`)="Lapsed"))
        Or (((`Policies`.`date of birth`) Is Null)
    And ((`Policies`.`Quantum status`)="Active"
        Or (`Policies`.`Quantum status`)="Lapsed"));