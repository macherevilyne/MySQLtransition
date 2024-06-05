INSERT INTO DBErrorTable (`Policy Nr`, Error, Variable, `Value`, Status)
SELECT
    Policydata_to_Quantum_ORIGINAL.`Policy Nr`,
    IF(
        Policydata_to_Quantum_ORIGINAL.Smoke2 IS NULL,
        'Smoke2 empty',
        'Invalid smoke2'
    ) AS Error,
    'Smoke2' AS Variable,
    Policydata_to_Quantum_ORIGINAL.Smoke2 AS `Value`,
    IF(
        Policydata_to_Quantum_ORIGINAL.`Internal status` IS NULL,
        'Undefined',
        QuantumStatus(Policydata_to_Quantum_ORIGINAL.`Internal status`)
    ) AS Status
FROM
    Policydata_to_Quantum_ORIGINAL
WHERE
    (
        Policydata_to_Quantum_ORIGINAL.Smoke2 IS NULL
        AND (
            IF(
                Policydata_to_Quantum_ORIGINAL.`Internal status` IS NULL,
                'Undefined',
                QuantumStatus(Policydata_to_Quantum_ORIGINAL.`Internal status`)
            ) IN ('Undefined', 'Other')
        )
        AND Policydata_to_Quantum_ORIGINAL.`Joined lives` = 'Yes'
    )
    OR (
        (
            Policydata_to_Quantum_ORIGINAL.Smoke2 NOT IN ('Yes', 'No')
        )
        AND (
            IF(
                Policydata_to_Quantum_ORIGINAL.`Internal status` IS NULL,
                'Undefined',
                QuantumStatus(Policydata_to_Quantum_ORIGINAL.`Internal status`)
            ) IN ('Undefined', 'Other')
        )
        AND Policydata_to_Quantum_ORIGINAL.`Joined lives` = 'Yes'
    );