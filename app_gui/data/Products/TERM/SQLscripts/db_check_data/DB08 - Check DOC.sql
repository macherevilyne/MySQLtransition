INSERT INTO DBErrorTable (`Policy Nr`, Error, Variable, `Value`, Status)
SELECT
    Policydata_to_Quantum_ORIGINAL.`Policy Nr`,
    IF(
        Policydata_to_Quantum_ORIGINAL.`Type of application` IS NULL,
        'Type of application empty',
        'Invalid type of application'
    ) AS Error,
    'Type of application' AS Variable,
    Policydata_to_Quantum_ORIGINAL.`Type of application` AS `Value`,
    IF(
        Policydata_to_Quantum_ORIGINAL.`Internal status` IS NULL,
        'Undefined',
        QuantumStatus(Policydata_to_Quantum_ORIGINAL.`Internal status`)
    ) AS Status
FROM
    Policydata_to_Quantum_ORIGINAL
WHERE
    (
        Policydata_to_Quantum_ORIGINAL.`Type of application` IS NULL
        AND (
            IF(
                Policydata_to_Quantum_ORIGINAL.`Internal status` IS NULL,
                'Undefined',
                QuantumStatus(Policydata_to_Quantum_ORIGINAL.`Internal status`)
            ) <> 'Other'
            AND IF(
                Policydata_to_Quantum_ORIGINAL.`Internal status` IS NULL,
                'Undefined',
                QuantumStatus(Policydata_to_Quantum_ORIGINAL.`Internal status`)
            ) <> 'Undefined'
        )
    )
    OR (
        (Policydata_to_Quantum_ORIGINAL.`Type of application` <> 'Mortgage' AND Policydata_to_Quantum_ORIGINAL.`Type of application` <> 'Std.Term')
        AND (
            IF(
                Policydata_to_Quantum_ORIGINAL.`Internal status` IS NULL,
                'Undefined',
                QuantumStatus(Policydata_to_Quantum_ORIGINAL.`Internal status`)
            ) <> 'Other'
            AND IF(
                Policydata_to_Quantum_ORIGINAL.`Internal status` IS NULL,
                'Undefined',
                QuantumStatus(Policydata_to_Quantum_ORIGINAL.`Internal status`)
            ) <> 'Undefined'
        )
    );