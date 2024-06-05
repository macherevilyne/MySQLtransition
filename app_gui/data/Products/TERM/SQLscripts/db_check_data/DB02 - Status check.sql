INSERT INTO `DBErrorTable` (`Policy Nr`, Error, Variable, `Value`, Status)
SELECT
    `Policydata_to_Quantum_ORIGINAL`.`Policy Nr`,
    IF(
        `Policydata_to_Quantum_ORIGINAL`.`Internal status` IS NULL,
        'Status empty',
        'Invalid status'
    ) AS Error,
    'Internal status' AS Variable,
    `Policydata_to_Quantum_ORIGINAL`.`Internal status` AS `Value`,
    IF(
        `Policydata_to_Quantum_ORIGINAL`.`Internal status` IS NULL,
        'Undefined',
        QuantumStatus(`Policydata_to_Quantum_ORIGINAL`.`Internal status`)
    ) AS Expr1
FROM
    `Policydata_to_Quantum_ORIGINAL`
WHERE
    IF(
        `Policydata_to_Quantum_ORIGINAL`.`Internal status` IS NULL,
        'Undefined',
        QuantumStatus(`Policydata_to_Quantum_ORIGINAL`.`Internal status`)
    ) = 'Undefined';