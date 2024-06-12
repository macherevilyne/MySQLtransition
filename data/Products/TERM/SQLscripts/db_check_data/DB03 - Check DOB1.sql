INSERT INTO DBErrorTable (`Policy Nr`, Error, Variable, `Value`, Status)
SELECT
    Policydata_to_Quantum_ORIGINAL.`Policy Nr`,
    'Invalid DOB1' AS Error,
    'DOB1' AS Variable,
    Policydata_to_Quantum_ORIGINAL.DOB1 AS `Value`,
    IF(
        Policydata_to_Quantum_ORIGINAL.`Internal status` IS NULL,
        'Undefined',
        QuantumStatus(Policydata_to_Quantum_ORIGINAL.`Internal status`)
    ) AS Expr1
FROM
    Policydata_to_Quantum_ORIGINAL
WHERE
    (
        Policydata_to_Quantum_ORIGINAL.DOB1 IS NULL

        OR STR_TO_DATE(Policydata_to_Quantum_ORIGINAL.DOB1, '%d-%m-%Y') < STR_TO_DATE('01-01-1900', '%d-%m-%Y')
        OR STR_TO_DATE(Policydata_to_Quantum_ORIGINAL.DOB1, '%d-%m-%Y') > STR_TO_DATE('01-01-2012', '%d-%m-%Y')
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
    );