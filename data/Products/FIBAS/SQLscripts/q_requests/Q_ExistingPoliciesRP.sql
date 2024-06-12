DROP VIEW IF EXISTS `Q_ExistingPoliciesRP`;
CREATE VIEW `Q_ExistingPoliciesRP` AS
SELECT 
    `Policies`.*
FROM 
    `Policies`
WHERE 
    (((`Policies`.`Quantum status`) = "Active" OR Policies.`Quantum status` = "Lapsed")
    AND (`Policies`.`RP net premium` > 0)
    AND (STR_TO_DATE(`Policies`.`cancellation date`, '%d-%m-%Y') IS NULL
         OR STR_TO_DATE(`Policies`.`cancellation date`, '%d-%m-%Y') >= STR_TO_DATE('01.01.2017', '%d.%m.%Y')));