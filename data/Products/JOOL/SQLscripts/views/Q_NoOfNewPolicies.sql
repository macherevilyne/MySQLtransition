DROP VIEW IF EXISTS `Q_NoOfNewPolicies`;
CREATE VIEW `Q_NoOfNewPolicies` AS
SELECT
    PolicyData.polno,
    PolicyData.Status,
    PolicyData.PolStart
FROM PolicyData
WHERE (PolicyData.Status = 'Issued' OR PolicyData.Status = 'Terminated')
  AND (PolicyData.PolStart >= STR_TO_DATE('01-01-2022', '%d-%m-%Y'));