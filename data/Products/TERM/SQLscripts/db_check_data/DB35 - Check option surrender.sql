INSERT INTO DBErrorTable (`Policy Nr`, Error, Variable, `Value`, Status)
SELECT
    Policydata_to_Quantum_ORIGINAL.`Policy Nr`,
    'Invalid optionSurrender' AS Error,
    'optionSurrender' AS Variable,
    Policydata_to_Quantum_ORIGINAL.optionSurrender AS `Value`,
    IF(
        Policydata_to_Quantum_ORIGINAL.`Internal status` IS NULL,
        'Undefined',
        QuantumStatus(Policydata_to_Quantum_ORIGINAL.`Internal status`)
    ) AS Status
FROM
    Policydata_to_Quantum_ORIGINAL
WHERE
    (
        Policydata_to_Quantum_ORIGINAL.optionSurrender NOT IN ('Yes', 'No')
        AND (
            IF(
                Policydata_to_Quantum_ORIGINAL.`Internal status` IS NULL,
                'Undefined',
                QuantumStatus(Policydata_to_Quantum_ORIGINAL.`Internal status`)
            ) IN ('Undefined', 'Other')
        )
    );