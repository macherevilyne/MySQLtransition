DROP VIEW IF EXISTS `Q_MissingPersonalData`;
CREATE VIEW `Q_MissingPersonalData` AS
SELECT
    MonetInputsJOOL.PolNo,
    MonetInputsJOOL.PeriodIF,
    MonetInputsJOOL.StartYear,
    MonetInputsJOOL.AgeEnt1,
    MonetInputsJOOL.Sex1,
    PersonalData.polno
FROM MonetInputsJOOL
LEFT JOIN PersonalData ON MonetInputsJOOL.PolNo = PersonalData.polno
WHERE PersonalData.polno IS NULL;