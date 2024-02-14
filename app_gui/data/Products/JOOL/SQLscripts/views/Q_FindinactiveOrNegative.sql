DROP VIEW IF EXISTS `Q_FindinactiveOrNegative`;
CREATE VIEW `Q_FindinactiveOrNegative` AS
SELECT
    MonetInputsJOOL.*,
    PolicyValuesByStatus.PolNo,
    PolicyValuesByStatus.Status,
    PolicyValuesByStatus.Value_EUR
FROM MonetInputsJOOL
LEFT JOIN PolicyValuesByStatus ON MonetInputsJOOL.PolNo = PolicyValuesByStatus.PolNo
WHERE PolicyValuesByStatus.PolNo IS NULL OR PolicyValuesByStatus.Status = 'Other' OR PolicyValuesByStatus.Value_EUR < 0;
