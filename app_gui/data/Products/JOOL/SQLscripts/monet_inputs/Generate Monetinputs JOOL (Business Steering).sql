CREATE TABLE IF NOT EXISTS `MonetInputsJOOL BusinessSteering` AS
SELECT MonetInputsJOOL.*, PolicyData.PolStart
FROM MonetInputsJOOL
LEFT JOIN PolicyData ON MonetInputsJOOL.PolNo = PolicyData.polno
WHERE (PolicyData.PolStart >= [StartDate] AND PolicyData.PolStart < [ValDate]);
