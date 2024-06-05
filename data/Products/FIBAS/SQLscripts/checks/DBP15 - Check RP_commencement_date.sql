INSERT INTO DBPErrorTable(`Policy Nr`,`Error`,`Variable`,`Value`,`Status`)
SELECT `Policies`.`policy number`,
IF(ISNULL(`Policies`.`RP_commencement_date`),"RP_commencement_date empty","Invalid RP_commencement_date") AS `Error`,
"RP_commencement_date" AS `Variable`,
`Policies`.`RP_commencement_date` AS `value`,
`Policies`.`Quantum status` AS `Status`
FROM `Policies`
WHERE (((`Policies`.`RP_commencement_date`)<`commencement date`)
    And ((`Policies`.`Quantum status`)="Active"
        Or (`Policies`.`Quantum status`)="Lapsed"))
        Or (((`Policies`.`RP_commencement_date`) Is Null)
    And ((`Policies`.`Quantum status`)="Active"
        Or (`Policies`.`Quantum status`)="Lapsed")
    And ((`Policies`.`premium payment`)="combination postponed"));