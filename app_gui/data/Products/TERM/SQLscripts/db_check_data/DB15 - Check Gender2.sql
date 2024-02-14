INSERT INTO DBErrorTable (`Policy Nr`, Error, Variable, `Value`, Status)
SELECT
    Policydata_to_Quantum_ORIGINAL.`Policy Nr`,
    IF(
        Policydata_to_Quantum_ORIGINAL.Gender2 IS NULL,
        'Gender2 empty',
        'Invalid Gender2'
    ) AS Error,
    'Gender2' AS Variable,
    Policydata_to_Quantum_ORIGINAL.Gender2 AS `Value`,
    IF(
        Policydata_to_Quantum_ORIGINAL.`Internal status` IS NULL,
        'Undefined',
        QuantumStatus(Policydata_to_Quantum_ORIGINAL.`Internal status`)
    ) AS Status
FROM
    Policydata_to_Quantum_ORIGINAL
WHERE
    (
        Policydata_to_Quantum_ORIGINAL.Gender2 IS NULL
        AND (
            IF(
                Policydata_to_Quantum_ORIGINAL.`Internal status` IS NULL,
                'Undefined',
                QuantumStatus(Policydata_to_Quantum_ORIGINAL.`Internal status`)
            ) IN ('Undefined', 'Other')
        )
        AND Policydata_to_Quantum_ORIGINAL.`Joined lives` = 'Yes'
        AND NOT Policydata_to_Quantum_ORIGINAL.CalcEngine = 12
    )
    OR (
        (
            Policydata_to_Quantum_ORIGINAL.Gender2 NOT IN ('Male', 'Female')
        )
        AND (
            IF(
                Policydata_to_Quantum_ORIGINAL.`Internal status` IS NULL,
                'Undefined',
                QuantumStatus(Policydata_to_Quantum_ORIGINAL.`Internal status`)
            ) IN ('Undefined', 'Other')
        )
        AND Policydata_to_Quantum_ORIGINAL.`Joined lives` = 'Yes'
        AND NOT Policydata_to_Quantum_ORIGINAL.CalcEngine = 12
    );