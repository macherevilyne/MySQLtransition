DROP VIEW IF EXISTS `Q_ChangeStatus_Detail`;
CREATE VIEW `Q_ChangeStatus_Detail` AS
SELECT 
    `ClaimsPrevious`.`status`,
    IF(ISNULL(`ClaimsPrevious`.`Status`),"None",ClaimsStatus(`ClaimsPrevious`.`Status`)) AS `StatPrev`,
    `Claims`.`status`, 
    ClaimsStatus(`Claims`.`status`) AS `StatCurrent`,
    IF(Year(STR_TO_DATE(`Claims`.`gebeurtenis_datum`, '%d-%m-%Y'))<2012,1,0) AS `Before2012`,
    IF(Year(STR_TO_DATE(`Claims`.`gebeurtenis_datum`, '%d-%m-%Y'))>=2012,1,0) AS `From2012`,
    `Claims`.`claim_id`
FROM 
    `Claims` 
    LEFT JOIN `ClaimsPrevious` ON `Claims`.`claim_id` = `ClaimsPrevious`.`claim_id`;