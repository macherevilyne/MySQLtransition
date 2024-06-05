DROP VIEW IF EXISTS `Q_CheckExistencePara`;
CREATE VIEW `Q_CheckExistencePara` AS
SELECT
    MonetInputsJOOL.PolNo,
    MonetInputsJOOL.StartYear,
    TermsheetJOOL.Branch,
    PolicyValuesByStatus.Status,
    MonetInputsJOOL.FundAccValDat,
    PolicyValuesByStatus.Value_EUR
FROM MonetInputsJOOL
LEFT JOIN TermsheetJOOL ON MonetInputsJOOL.Branch = TermsheetJOOL.Branch
LEFT JOIN PolicyValuesByStatus ON MonetInputsJOOL.PolNo = PolicyValuesByStatus.PolNo
WHERE TermsheetJOOL.Branch IS NULL;
