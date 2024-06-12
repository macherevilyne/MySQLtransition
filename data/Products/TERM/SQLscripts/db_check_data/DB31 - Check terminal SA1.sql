INSERT INTO DBErrorTable (`Policy Nr`, Error, Variable, `Value`, Status)
SELECT
    Policydata_to_Quantum_ORIGINAL.`Policy Nr`,
    IF(
        Policydata_to_Quantum_ORIGINAL.`Insured Life 1 SA Enddate` IS NULL,
        'Terminal SA1 empty',
        'Invalid terminal SA1'
    ) AS Error,
    'Insured Life 1 SA Enddate' AS Variable,
    Policydata_to_Quantum_ORIGINAL.`Insured Life 1 SA Enddate` AS `Value`,
    IF(
        Policydata_to_Quantum_ORIGINAL.`Internal status` IS NULL,
        'Undefined',
        QuantumStatus(Policydata_to_Quantum_ORIGINAL.`Internal status`)
    ) AS Status
FROM
    Policydata_to_Quantum_ORIGINAL
WHERE
    (
        Policydata_to_Quantum_ORIGINAL.`Insured Life 1 SA Enddate` IS NULL
        AND (
            IF(
                Policydata_to_Quantum_ORIGINAL.`Internal status` IS NULL,
                'Undefined',
                QuantumStatus(Policydata_to_Quantum_ORIGINAL.`Internal status`)
            ) IN ('Undefined', 'Other')
        )
        AND Policydata_to_Quantum_ORIGINAL.`Insured life 1 Type` = 'Linear Increasing'
    )
    OR (
        Policydata_to_Quantum_ORIGINAL.`Insured Life 1 SA Enddate` < Policydata_to_Quantum_ORIGINAL.`Insured life 1 SA`
        AND (
            IF(
                Policydata_to_Quantum_ORIGINAL.`Internal status` IS NULL,
                'Undefined',
                QuantumStatus(Policydata_to_Quantum_ORIGINAL.`Internal status`)
            ) IN ('Undefined', 'Other')
        )
        AND Policydata_to_Quantum_ORIGINAL.`Insured life 1 Type` = 'Linear Increasing'
    );