DROP VIEW IF EXISTS `Q_ChangeStatus`;
CREATE VIEW `Q_ChangeStatus` AS
SELECT 
    IF(ISNULL(`ClaimsPrevious`.`Status`),"None",ClaimsStatus(`ClaimsPrevious`.`Status`)) AS `StatPrev`,
    ClaimsStatus(`Claims`.`status`) AS `StatCurrent`,
    SUM(IF(YEAR(STR_TO_DATE(`ClaimsBasic`.`eigen_risico_start_datum`, '%d-%m-%Y'))<2011,1,0)) AS `Before2011`,
    SUM(IF(YEAR(STR_TO_DATE(`ClaimsBasic`.`eigen_risico_start_datum`, '%d-%m-%Y'))>=2011,1,0)) AS `From2011`,
    COUNT(`Claims`.`claim_id`) AS `CountOfclaim_id`
FROM 
    (`Claims`
    LEFT JOIN `ClaimsPrevious` ON `Claims`.`claim_id` = `ClaimsPrevious`.`claim_id`)
    LEFT JOIN `ClaimsBasic` ON `Claims`.`claim_id` = `ClaimsBasic`.`claim_id`
WHERE 
    (`Claims`.`claim_type`="DISABILITY")
GROUP BY 
    IF(ISNULL(`ClaimsPrevious`.`Status`),"None",ClaimsStatus(`ClaimsPrevious`.`Status`)), ClaimsStatus(`Claims`.`status`);