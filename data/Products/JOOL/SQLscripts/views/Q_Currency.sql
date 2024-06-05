DROP VIEW IF EXISTS `Q_Currency`;
CREATE VIEW `Q_Currency` AS
    SELECT
        polno,
        RIGHT(Product, 3) AS Curr
FROM PolicyData;
