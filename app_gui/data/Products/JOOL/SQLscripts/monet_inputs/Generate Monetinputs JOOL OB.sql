CREATE TABLE IF NOT EXISTS `MonetInputsJOOL OB` AS
SELECT `MonetInputsJOOL AgeUpdate`.*
FROM `MonetInputsJOOL AgeUpdate`
LEFT JOIN `MonetInputsJOOL previous year` ON `MonetInputsJOOL AgeUpdate`.PolNo = `MonetInputsJOOL previous year`.PolNo
WHERE `MonetInputsJOOL previous year`.PolNo IS NOT NULL;