CREATE FUNCTION ClaimsStatus (Status VARCHAR(255))
RETURNS VARCHAR(255)
BEGIN
    DECLARE ResultStatus VARCHAR(255) DEFAULT "Invalid";
    IF(Status = "EMPLOYMENT_REEVALUATION" OR
        Status = "INSURER_REASSESSMENT" OR
        Status = "INSURER_ASSESSMENT" OR
        Status = "PAYMENT_AUTOMATED" OR
        Status = "PAYMENT_PREPARATION" OR
        Status = "PAYMENT_PREPARED" OR
        Status = "PAYMENT_PROPOSED" OR
        Status = "PAYMENT_POSTPONED" OR
        Status = "PREPARED_FOR_ACCEPTANCE"
    ) THEN SET ResultStatus = "Accepted";
    ELSEIF(
        Status = "EMPLOYMENT_EVALUATION" OR
        Status = "ENTERED" OR
        Status = "OWN_RISK_PERIOD" OR
        Status = "WAITING_FOR_INFORMATION" OR
        Status = "PRE_SCREENING"
    )THEN SET ResultStatus = "NotAccepted";
    ELSEIF(
        Status = "CANCELED" OR
        Status = "CLOSED" OR
        Status = "ENDED" OR
        Status = "DECLINED" OR
        Status = "APPEAL_PROCEDURE" OR
        Status = "ENDED_APPEAL_PROCEDURE" OR
        Status = "PREPARED_FOR_DECLINE"
    )THEN SET ResultStatus = "Terminated";
    END IF;

    RETURN ResultStatus;
END