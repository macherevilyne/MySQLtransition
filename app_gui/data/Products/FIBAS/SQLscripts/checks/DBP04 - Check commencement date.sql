INSERT INTO DBPErrorTable(`Policy Nr`,`Error`,`Variable`,`Value`,`Status`)
SELECT `Policies`.`policy number`,
IF(ISNULL(`Policies`.`commencement date`),"commencement date empty","Invalid commencement date") AS `Error`,
"commencement date" AS `Variable`,
`Policies`.`commencement date` AS `Value`,
`Policies`.`Quantum status` AS `Status`
FROM `Policies`
WHERE (((STR_TO_DATE(`Policies`.`commencement date`, '%d-%m-%Y'))<STR_TO_DATE('01.01.2005', '%d.%m.%Y'))
    And ((`Policies`.`Quantum status`)="Active" Or (`Policies`.`Quantum status`)="Lapsed")) Or (((`Policies`.`commencement date`) Is Null)
    And ((`Policies`.`Quantum status`)="Active" Or (`Policies`.`Quantum status`)="Lapsed"));