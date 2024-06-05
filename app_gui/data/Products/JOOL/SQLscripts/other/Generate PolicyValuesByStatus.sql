CREATE TABLE IF NOT EXISTS PolicyValuesByStatus AS
SELECT
    Q_PolicyValues_by_status.PolNo,
    Q_PolicyValues_by_status.Curr,
    Q_PolicyValues_by_status.Status,
    Q_PolicyValues_by_status.`Market Value`,
    Q_PolicyValues_by_status.`Market Value` * ROE.EUR AS Value_EUR
FROM
    Q_PolicyValues_by_status
INNER JOIN
    ROE ON Q_PolicyValues_by_status.Curr = ROE.Currency;