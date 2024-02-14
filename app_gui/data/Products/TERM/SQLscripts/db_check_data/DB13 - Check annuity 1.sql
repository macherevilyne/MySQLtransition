INSERT INTO DBErrorTable (`Policy Nr`, Error, Variable, `Value`, Status)
SELECT
    Policydata_to_Quantum_ORIGINAL.`Policy Nr`,
    IF(
        Policydata_to_Quantum_ORIGINAL.`Annuity percentage 1` IS NULL,
        'Annuity 1 empty',
        'Invalid annuity 1'
    ) AS Error,
    'Annuity percentage 1' AS Variable,
    Policydata_to_Quantum_ORIGINAL.`Annuity percentage 1` AS `Value`,
    IF(
        Policydata_to_Quantum_ORIGINAL.`Internal status` IS NULL,
        'Undefined',
        QuantumStatus(Policydata_to_Quantum_ORIGINAL.`Internal status`)
    ) AS Status
FROM
    Policydata_to_Quantum_ORIGINAL
WHERE
    (
        Policydata_to_Quantum_ORIGINAL.`Annuity percentage 1` IS NULL
        AND NOT (
            IF(
                Policydata_to_Quantum_ORIGINAL.`Internal status` IS NULL,
                'Undefined',
                QuantumStatus(Policydata_to_Quantum_ORIGINAL.`Internal status`)
            ) IN ('Undefined', 'Other')
        )
        AND (
            Policydata_to_Quantum_ORIGINAL.`Insured life 1 Type` IN ('Annuity', 'Annuity Increasing')
        )
    )
    OR (
        (
            Policydata_to_Quantum_ORIGINAL.`Annuity percentage 1` < 0
            OR Policydata_to_Quantum_ORIGINAL.`Annuity percentage 1` > 1
        )
        AND NOT (
            IF(
                Policydata_to_Quantum_ORIGINAL.`Internal status` IS NULL,
                'Undefined',
                QuantumStatus(Policydata_to_Quantum_ORIGINAL.`Internal status`)
            ) IN ('Undefined', 'Other')
        )
        AND (
            Policydata_to_Quantum_ORIGINAL.`Insured life 1 Type` IN ('Annuity', 'Annuity Increasing')
        )
    );