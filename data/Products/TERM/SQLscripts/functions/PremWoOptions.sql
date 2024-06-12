CREATE FUNCTION PremWoOptions(
  Premium DOUBLE,
  Freq VARCHAR(255),
  Term INT,
  Joint VARCHAR(255),
  DOC DATE,
  DOB1 DATE,
  DOB2 DATE,
  Child VARCHAR(255),
  WoP VARCHAR(255),
  Accident VARCHAR(255),
  Surrender VARCHAR(255)
) RETURNS DOUBLE
BEGIN
  DECLARE Age1 DOUBLE;
  DECLARE Age2 DOUBLE;
  DECLARE EndAgeWoP DOUBLE;
  DECLARE FactWoP DOUBLE;
  DECLARE PremChild DOUBLE;
  DECLARE PremAccident DOUBLE;
  DECLARE FactTermIll DOUBLE;
  DECLARE FactSurrender DOUBLE;
  DECLARE AnnualPrem DOUBLE;
  -- Waiver of premium
  IF WoP = 'No' THEN
    SET FactWoP = 1;
  ELSE
    SET Age1 = DATEDIFF(DOC, DOB1) / 365;
    IF Joint = 'Yes' THEN
      SET Age2 = DATEDIFF(DOC, DOB2) / 365;
    END IF;
    IF Joint = 'Yes' AND Age2 > Age1 THEN
      SET EndAgeWoP = Age2 + Term;
    ELSE
      SET EndAgeWoP = Age1 + Term;
    END IF;
    IF EndAgeWoP < 46 THEN
      SET FactWoP = 1.04;
    ELSEIF EndAgeWoP < 56 THEN
      SET FactWoP = 1.05;
    ELSEIF EndAgeWoP < 66 THEN
      SET FactWoP = 1.07;
    ELSEIF EndAgeWoP < 71 THEN
      SET FactWoP = 1.08;
    ELSE
      SET FactWoP = 1.09;
    END IF;
  END IF;
  -- Child
  IF Child = 'No' THEN
    SET PremChild = 0;
  ELSE
    SET PremChild = 48;
  END IF;
  IF Freq = 'Single' THEN
    SET PremChild = PremChild * Term;
  END IF;
  -- Accident
  IF Accident = 'No' THEN
    SET PremAccident = 0;
  ELSE
    IF Joint = 'No' THEN
      SET PremAccident = 36;
    ELSE
      SET PremAccident = 60;
    END IF;
  END IF;
  IF Freq = 'Single' THEN
    SET PremAccident = PremAccident * Term;
  END IF;
  -- Surrender
  IF Surrender = 'Yes' THEN
    SET FactSurrender = 1.25;
  ELSE
    SET FactSurrender = 1;
  END IF;
  -- Calculate premium without options
  IF Freq = 'Monthly' THEN
    SET AnnualPrem = 12 * Premium;
  ELSE
    SET AnnualPrem = Premium;
  END IF;
  RETURN (AnnualPrem / FactWoP - PremChild - PremAccident) / FactSurrender;
END