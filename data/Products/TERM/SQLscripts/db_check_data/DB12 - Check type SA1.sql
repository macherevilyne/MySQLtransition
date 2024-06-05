INSERT INTO DBErrorTable (`Policy Nr`, Error, Variable, `Value`, Status)
SELECT
    Policydata_to_Quantum_ORIGINAL.`Policy Nr`,
    IF(
        Policydata_to_Quantum_ORIGINAL.`Insured life 1 Type` IS NULL,
        'Type SA1 empty',
        'Invalid type SA1'
    ) AS Error,
    'Insured life 1 Type' AS Variable,
    Policydata_to_Quantum_ORIGINAL.`Insured life 1 Type` AS `Value`,
    IF(
        Policydata_to_Quantum_ORIGINAL.`Internal status` IS NULL,
        'Undefined',
        QuantumStatus(Policydata_to_Quantum_ORIGINAL.`Internal status`)
    ) AS Status
FROM
    Policydata_to_Quantum_ORIGINAL
WHERE
    (
        Policydata_to_Quantum_ORIGINAL.`Insured life 1 Type` IS NULL
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
        AND (Policydata_to_Quantum_ORIGINAL.CalcEngine) <> 21
    )
    OR (
        (
            Policydata_to_Quantum_ORIGINAL.`Insured life 1 Type` NOT IN (
                'Level', 'StraightLine', 'Annuity', 'Linear Increasing', 'Annuity Increasing'
            )
        )
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