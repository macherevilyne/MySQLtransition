CREATE FUNCTION QuantumStatus(Status VARCHAR(255)) RETURNS VARCHAR(255)
BEGIN
    DECLARE Result VARCHAR(255);
    IF Status = 'Cancelled Policy - death claim' THEN
        SET Result = 'Death';
    ELSEIF Status IN ('Cancelled Policy', 'Cancelled Policy - mortgage cancelled',
        'Cancelled Policy - premiums unpaid', 'Cancelled Policy - reject smoke premium') THEN
        SET Result = 'Lapsed';
    ELSEIF Status = 'Cancelled Policy - end of term' THEN
        SET Result = 'Expired';
    ELSEIF Status IN ('Issued', 'Cleared to issue') THEN
        SET Result = 'Active';
    ELSEIF Status IN (
        'Accepted by Quantum', 'Accepted by TAF', 'Accepted by client',
        'Cancelled Request', 'Cancelled Request - no mortgage', 'Extra information requested',
        'Ready for medical assessment', 'Reassess medical descision', 'Rejected by client',
        'Rejected by medical advisor', 'Rejected by Quantum', 'Rejected by TAF', 'To be accepted by client',
        'To be accepted by TAF', 'To be accepted by Quantum', 'To be accepted by medical advisor',
        'medical test required', 'To be accepted by reinsurer', 'Removed') THEN
        SET Result = 'Other';
    ELSE
        SET Result = 'Undefined';
    END IF;
    RETURN Result;
END;