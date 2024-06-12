DROP VIEW IF EXISTS `Q_BadStatus`;
CREATE VIEW `Q_BadStatus` AS
SELECT 
    `Policies`.`policy number`,
    `Policies`.`premium payment`,
    `Policies`.`Quantum status`,
    `PoliciesNew`.`quantum status`,
    `PoliciesNew`.`status`,
    IF(`reserveringen_openstaand` > 0, "Yes", "No") AS `disable`
FROM 
    (`Policies`
        LEFT JOIN `PoliciesNew` ON `Policies`.`policy number` = `PoliciesNew`.`policy number`)
        LEFT JOIN `Claims` ON `PoliciesNew`.`policy number` = `Claims`.`eerste_polis_nummer`
WHERE 
    `Policies`.`Quantum status` = "Active" AND 
    `PoliciesNew`.`quantum status` = "Other";