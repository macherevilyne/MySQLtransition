DROP VIEW IF EXISTS `Q_NoOfPolicies`;
CREATE VIEW `Q_NoOfPolicies` AS
SELECT
    COUNT(`Policies`.`policy number`) AS `CountOfpolicy number`
FROM 
    `Policies`
WHERE 
    ((`Policies`.`Quantum status` = 'Active')
           AND (STR_TO_DATE(`Policies`.`commencement date`, '%d-%m-%Y') < STR_TO_DATE('{ValDat}', '%Y-%m-%d %H:%i:%s')));