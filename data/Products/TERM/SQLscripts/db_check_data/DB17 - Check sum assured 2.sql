INSERT INTO DBErrorTable (`Policy Nr`, Error, Variable, `Value`, Status)
SELECT
    Policydata_to_Quantum_ORIGINAL.`Policy Nr`,
    IF(
        Policydata_to_Quantum_ORIGINAL.`Insured life 2 SA` IS NULL,
        'Sum assured 2 empty',
        'Invalid sum assured 2'
    ) AS Error,
    'Insured life 2 SA' AS Variable,
    Policydata_to_Quantum_ORIGINAL.`Insured life 2 SA` AS `Value`,
    IF(
        Policydata_to_Quantum_ORIGINAL.`Internal status` IS NULL,
        'Undefined',
        QuantumStatus(Policydata_to_Quantum_ORIGINAL.`Internal status`)
    ) AS Status
FROM
    Policydata_to_Quantum_ORIGINAL
WHERE
    (
        Policydata_to_Quantum_ORIGINAL.`Insured life 2 SA` IS NULL
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
            Policydata_to_Quantum_ORIGINAL.`Insured life 2 SA` < 0
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