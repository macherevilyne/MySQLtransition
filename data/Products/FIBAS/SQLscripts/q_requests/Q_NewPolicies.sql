DROP VIEW IF EXISTS `Q_NewPolicies`;
CREATE VIEW `Q_NewPolicies` AS
SELECT 
    `Policies`.*
FROM 
    `Policies`
WHERE 
    ((`Policies`.`Quantum status` = 'Active' OR `Policies`.`Quantum status` = 'Lapsed')
    AND (STR_TO_DATE(`Policies`.`commencement date`, '%d-%m-%Y') >= STR_TO_DATE('01.01.2017', '%d.%m.%Y')));