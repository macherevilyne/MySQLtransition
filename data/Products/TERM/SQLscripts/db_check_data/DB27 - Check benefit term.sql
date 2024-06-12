INSERT INTO DBErrorTable (`Policy Nr`, Error, Variable, `Value`, Status)
SELECT
    Policydata_to_Quantum_ORIGINAL.`Policy Nr`,
    IF(
        Policydata_to_Quantum_ORIGINAL.TermOfBenefit IS NULL,
        'Benefit term empty',
        IF(
            Policydata_to_Quantum_ORIGINAL.TermOfBenefit = 99,
            'Term of benefit 99 requires joined lives',
            'Invalid benefit term'
        )
    ) AS Error,
    'TermOfBenefit' AS Variable,
    Policydata_to_Quantum_ORIGINAL.TermOfBenefit AS `Value`,
    IF(
        Policydata_to_Quantum_ORIGINAL.`Internal status` IS NULL,
        'Undefined',
        QuantumStatus(Policydata_to_Quantum_ORIGINAL.`Internal status`)
    ) AS Status
FROM
    Policydata_to_Quantum_ORIGINAL
WHERE
    (
        Policydata_to_Quantum_ORIGINAL.TermOfBenefit IS NULL
        AND (
            IF(
                Policydata_to_Quantum_ORIGINAL.`Internal status` IS NULL,
                'Undefined',
                QuantumStatus(Policydata_to_Quantum_ORIGINAL.`Internal status`)
            ) NOT IN ('Undefined', 'Other')
        )
        AND (
            Policydata_to_Quantum_ORIGINAL.CalcEngine IN (3, 10, 12)
        )
    )
    OR (
        (Policydata_to_Quantum_ORIGINAL.TermOfBenefit < 0 OR Policydata_to_Quantum_ORIGINAL.TermOfBenefit > 99)
        AND (
            IF(
                Policydata_to_Quantum_ORIGINAL.`Internal status` IS NULL,
                'Undefined',
                QuantumStatus(Policydata_to_Quantum_ORIGINAL.`Internal status`)
            ) NOT IN ('Undefined', 'Other')
        )
        AND (
            Policydata_to_Quantum_ORIGINAL.CalcEngine IN (3, 10, 12)
        )
    )
    OR (
        Policydata_to_Quantum_ORIGINAL.TermOfBenefit = 99
        AND (
            IF(
                Policydata_to_Quantum_ORIGINAL.`Internal status` IS NULL,
                'Undefined',
                QuantumStatus(Policydata_to_Quantum_ORIGINAL.`Internal status`)
            ) NOT IN ('Undefined', 'Other')
        )
        AND (
            Policydata_to_Quantum_ORIGINAL.CalcEngine IN (3, 10, 12)
        )
        AND (
            Policydata_to_Quantum_ORIGINAL.`Joined lives` = 'No'
        )
    );