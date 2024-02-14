CREATE TABLE IF NOT EXISTS `DBErrorTable` (
   `Policy Nr` TEXT,
   `Error` TEXT,
   `Variable` TEXT,
   `Value` TEXT,
   `Status` TEXT
   );
INSERT INTO `DBErrorTable` (`Policy Nr`,`Error`,`Variable`,`Value`)
SELECT
    Policydata_to_Quantum_ORIGINAL.`Policy Nr`,
    IF(
        COALESCE(Policydata_to_Quantum_ORIGINAL.`Policy Nr`, '') = '' OR Policydata_to_Quantum_ORIGINAL.`Policy Nr` IS NULL,
        'Invalid Policy number',
        'Double counted policy'
    ) AS Error,
    'Policy Nr' AS Variable,
    Policydata_to_Quantum_ORIGINAL.`Policy Nr` AS `Value`
FROM
    Policydata_to_Quantum_ORIGINAL
GROUP BY
    Policydata_to_Quantum_ORIGINAL.`Policy Nr`
HAVING
    COUNT(Policydata_to_Quantum_ORIGINAL.`Policy Nr`) <> 1
    OR Policydata_to_Quantum_ORIGINAL.`Policy Nr` IS NULL
    OR Policydata_to_Quantum_ORIGINAL.`Policy Nr` = '';