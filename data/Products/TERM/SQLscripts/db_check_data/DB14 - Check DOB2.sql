INSERT INTO DBErrorTable (`Policy Nr`, Error, Variable, `Value`, Status)
SELECT
    Policydata_to_Quantum_ORIGINAL.`Policy Nr`,
    IF(
        Policydata_to_Quantum_ORIGINAL.DOB2 IS NULL,
        'DOB2 empty',
        'Invalid DOB2'
    ) AS Error,
    'DOB2' AS Variable,
    Policydata_to_Quantum_ORIGINAL.DOB2 AS `Value`,
    IF(
        Policydata_to_Quantum_ORIGINAL.`Internal status` IS NULL,
        'Undefined',
        QuantumStatus(Policydata_to_Quantum_ORIGINAL.`Internal status`)
    ) AS Status
FROM
    Policydata_to_Quantum_ORIGINAL
WHERE
    (
        Policydata_to_Quantum_ORIGINAL.DOB2 IS NULL
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
            STR_TO_DATE(Policydata_to_Quantum_ORIGINAL.DOB2, '%d-%m-%Y') < STR_TO_DATE('01-01-1900', '%d-%m-%Y')
            OR STR_TO_DATE(Policydata_to_Quantum_ORIGINAL.DOB2, '%d-%m-%Y') > STR_TO_DATE('01-01-2012', '%d-%m-%Y')
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