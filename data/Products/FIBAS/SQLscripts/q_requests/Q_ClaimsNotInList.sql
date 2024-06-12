DROP VIEW IF EXISTS `Q_ClaimsNotInList`;
CREATE VIEW `Q_ClaimsNotInList` AS
SELECT 
    `Claims`.`claim_id`,
    ClaimsStatus(`claims`.`status`) AS `Stat`,
    IF(STR_TO_DATE(`Claims`.`betaling_eind_datum`, '%d-%m-%Y') >= STR_TO_DATE('{ValDat}', '%d-%m-%Y'), "Yes", "No") AS `END_PAYENT_DATE`,
    IF(`Quantum status` = "Active" OR ClaimsStatus(`Claims`.`status`) = "Accepted", "Yes", "No") AS `POLICY_STATUS`,
    IF(TIMESTAMPDIFF(MONTH, STR_TO_DATE('{ValDat}', '%d-%m-%Y'), STR_TO_DATE(`eigen_risico_start_datum`, '%d-%m-%Y')) < 1, "Yes", "No") AS `INC_DATE_IN_PAST`
FROM 
    (`Claims`
    LEFT JOIN `Policies` ON `Claims`.`eerste_polis_nummer` = `Policies`.`policy number`)
    LEFT JOIN `ClaimsBasic` ON `Claims`.`claim_id` = `ClaimsBasic`.`claim_id`
WHERE 
    (((ClaimsStatus(`claims`.`status`)) = "Accepted")
    AND (IF(STR_TO_DATE(`Claims`.`betaling_eind_datum`, '%d-%m-%Y') >= STR_TO_DATE('{ValDat}', '%d-%m-%Y'), "Yes", "No") = "No")
    AND ((`Claims`.`claim_type`) = "DISABILITY")) 
    OR 
    (((ClaimsStatus(`claims`.`status`)) = "Accepted")
    AND (IF(`Quantum status` = "Active" OR ClaimsStatus(`Claims`.`status`) = "Accepted", "Yes", "No") = "No")
    AND ((`Claims`.`claim_type`) = "DISABILITY")) 
    OR 
    (((ClaimsStatus(`claims`.`status`)) = "Accepted")
    AND (IF(TIMESTAMPDIFF(MONTH, STR_TO_DATE('{ValDat}', '%d-%m-%Y'), STR_TO_DATE(`eigen_risico_start_datum`, '%d-%m-%Y')) < 1, "Yes", "No") = "No")
    AND ((`Claims`.`claim_type`) = "DISABILITY"));