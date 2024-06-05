INSERT INTO DBErrorTable (`Policy Nr`, Error, Variable, `Value`, Status)
SELECT
    Policydata_to_Quantum_ORIGINAL.`Policy Nr`,
    IF(
        Policydata_to_Quantum_ORIGINAL.`Insured life 2 Type` IS NULL,
        'Type SA2 empty',
        'Invalid type SA2'
    ) AS Error,
    'Insured life 2 Type' AS Variable,
    Policydata_to_Quantum_ORIGINAL.`Insured life 2 Type` AS `Value`,
    IF(
        Policydata_to_Quantum_ORIGINAL.`Internal status` IS NULL,
        'Undefined',
        QuantumStatus(Policydata_to_Quantum_ORIGINAL.`Internal status`)
    ) AS Status
FROM
    Policydata_to_Quantum_ORIGINAL
WHERE
    (
        Policydata_to_Quantum_ORIGINAL.`Insured life 2 Type` IS NULL
        AND NOT (
            IF(
                Policydata_to_Quantum_ORIGINAL.`Internal status` IS NULL,
                'Undefined',
                QuantumStatus(Policydata_to_Quantum_ORIGINAL.`Internal status`)
            ) IN ('Undefined', 'Other')
        )
        AND Policydata_to_Quantum_ORIGINAL.`Joined lives` = 'Yes'
        AND Policydata_to_Quantum_ORIGINAL.CalcEngine <= 2
        AND Policydata_to_Quantum_ORIGINAL.`Insured life 2 SA` > 0
    )
    OR (
        NOT (
            Policydata_to_Quantum_ORIGINAL.`Insured life 2 Type` IN (
                'Level', 'StraightLine', 'Annuity', 'Linear Increasing', 'Annuity Increasing'
            )
        )
        AND NOT (
            IF(
                Policydata_to_Quantum_ORIGINAL.`Internal status` IS NULL,
                'Undefined',
                QuantumStatus(Policydata_to_Quantum_ORIGINAL.`Internal status`)
            ) IN ('Undefined', 'Other')
        )
        AND Policydata_to_Quantum_ORIGINAL.`Joined lives` = 'Yes'
        AND Policydata_to_Quantum_ORIGINAL.CalcEngine <= 2
        AND Policydata_to_Quantum_ORIGINAL.`Insured life 2 SA` > 0
    );