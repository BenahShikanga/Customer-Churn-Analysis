-- Business question: Which artists and individual tracks drive the most revenue?
-- (Two related queries: top artists, then top individual tracks.)

-- Top 10 artists by revenue
SELECT
    ar.Name                                    AS artist,
    COUNT(il.InvoiceLineId)                    AS units_sold,
    ROUND(SUM(il.UnitPrice * il.Quantity), 2)  AS revenue
FROM InvoiceLine il
JOIN Track t   ON t.TrackId = il.TrackId
JOIN Album al  ON al.AlbumId = t.AlbumId
JOIN Artist ar ON ar.ArtistId = al.ArtistId
GROUP BY artist
ORDER BY revenue DESC
LIMIT 10;

-- Top 10 individual tracks by revenue
SELECT
    t.Name                                     AS track,
    ar.Name                                    AS artist,
    COUNT(il.InvoiceLineId)                    AS units_sold,
    ROUND(SUM(il.UnitPrice * il.Quantity), 2)  AS revenue
FROM InvoiceLine il
JOIN Track t   ON t.TrackId = il.TrackId
JOIN Album al  ON al.AlbumId = t.AlbumId
JOIN Artist ar ON ar.ArtistId = al.ArtistId
GROUP BY t.TrackId, track, artist
ORDER BY revenue DESC
LIMIT 10;
