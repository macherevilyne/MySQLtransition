DROP VIEW IF EXISTS `Q_NoOfPolicies`;
CREATE VIEW `Q_NoOfPolicies` AS
SELECT
    COUNT(PolicyData.polno) AS CountOfpolno
FROM PolicyData
WHERE PolicyData.Status = 'Issued';