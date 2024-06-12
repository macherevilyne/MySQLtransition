CREATE FUNCTION CalcAge(DateOfBirth DATE, EvalDate DATE) RETURNS INT
BEGIN
    DECLARE age INT;
    SET age = YEAR(EvalDate) - YEAR(DateOfBirth);
    IF DATE_FORMAT(CONCAT(YEAR(EvalDate), '-', MONTH(DateOfBirth), '-', DAY(DateOfBirth)), '%Y-%m-%d') > EvalDate THEN
        SET age = age - 1;
    END IF;
    RETURN age;
END;