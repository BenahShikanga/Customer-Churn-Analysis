-- Business question: Which music genres sell best, by revenue and units sold?

SELECT
    g.Name                          AS genre,
    COUNT(il.InvoiceLineId)         AS units_sold,
    ROUND(SUM(il.UnitPrice * il.Quantity), 2) AS revenue
FROM InvoiceLine il
JOIN Track t  ON t.TrackId = il.TrackId
JOIN Genre g  ON g.GenreId = t.GenreId
GROUP BY genre
ORDER BY revenue DESC
LIMIT 10;
