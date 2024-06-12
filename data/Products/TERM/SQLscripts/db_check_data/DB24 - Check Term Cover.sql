INSERT INTO DBErrorTable (`Policy Nr`, Error, Variable, `Value`, Status)
SELECT
    Policydata_to_Quantum_ORIGINAL.`Policy Nr`,
    IF(
        Policydata_to_Quantum_ORIGINAL.`Term Cover` IS NULL,
        'Term Cover empty',
        'Invalid term cover'
    ) AS Error,
    'Term Cover' AS Variable,
    Policydata_to_Quantum_ORIGINAL.`Term Cover` AS `Value`,
    IF(
        Policydata_to_Quantum_ORIGINAL.`Internal status` IS NULL,
        'Undefined',
        QuantumStatus(Policydata_to_Quantum_ORIGINAL.`Internal status`)
    ) AS Status
FROM
    Policydata_to_Quantum_ORIGINAL
WHERE
    (
        Policydata_to_Quantum_ORIGINAL.`Term Cover` IS NULL
        AND (
            IF(
                Policydata_to_Quantum_ORIGINAL.`Internal status` IS NULL,
                'Undefined',
                QuantumStatus(Policydata_to_Quantum_ORIGINAL.`Internal status`)
            ) NOT IN ('Undefined', 'Other')
        )
        AND Policydata_to_Quantum_ORIGINAL.productgroup <> 'FUNERAL'
    )
    OR (
        Policydata_to_Quantum_ORIGINAL.`Term Cover` < 0
        AND (
            IF(
                Policydata_to_Quantum_ORIGINAL.`Internal status` IS NULL,
                'Undefined',
                QuantumStatus(Policydata_to_Quantum_ORIGINAL.`Internal status`)
            ) NOT IN ('Undefined', 'Other')
        )
    );