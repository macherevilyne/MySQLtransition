INSERT INTO DBErrorTable (`Policy Nr`, Error, Variable, `Value`, Status)
SELECT
    Policydata_to_Quantum_ORIGINAL.`Policy Nr`,
    IF(
        Policydata_to_Quantum_ORIGINAL.Freq IS NULL,
        'Freq empty',
        IF(
            Policydata_to_Quantum_ORIGINAL.Freq = 'Single',
            'Freq contradicts QP',
            'Invalid Freq'
        )
    ) AS Error,
    'Freq' AS Variable,
    Policydata_to_Quantum_ORIGINAL.Freq AS `Value`,
    IF(
        Policydata_to_Quantum_ORIGINAL.`Internal status` IS NULL,
        'Undefined',
        QuantumStatus(Policydata_to_Quantum_ORIGINAL.`Internal status`)
    ) AS Status
FROM
    Policydata_to_Quantum_ORIGINAL
WHERE
    (
        Policydata_to_Quantum_ORIGINAL.Freq IS NULL
        AND NOT (
            IF(
                Policydata_to_Quantum_ORIGINAL.`Internal status` IS NULL,
                'Undefined',
                QuantumStatus(Policydata_to_Quantum_ORIGINAL.`Internal status`)
            ) IN ('Undefined', 'Other')
        )
    )
    OR (
        (
            Policydata_to_Quantum_ORIGINAL.Freq NOT IN ('Yearly', 'Monthly', 'Single')
            AND NOT (IF(
                Policydata_to_Quantum_ORIGINAL.`Internal status` IS NULL,
                'Undefined',
                QuantumStatus(Policydata_to_Quantum_ORIGINAL.`Internal status`)
            ) IN ('Undefined', 'Other'))
        )
        OR (
            Policydata_to_Quantum_ORIGINAL.Freq = 'Single'
            AND NOT (
                IF(
                    Policydata_to_Quantum_ORIGINAL.`Internal status` IS NULL,
                    'Undefined',
                    QuantumStatus(Policydata_to_Quantum_ORIGINAL.`Internal status`)
                ) IN ('Undefined', 'Other')
            )
            AND NOT (Policydata_to_Quantum_ORIGINAL.QP = 0)
        )
    );