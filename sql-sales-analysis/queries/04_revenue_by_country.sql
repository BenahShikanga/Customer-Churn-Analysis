-- Business question: Which countries generate the most revenue, and how does
-- average order value differ by market?

SELECT
    BillingCountry                              AS country,
    COUNT(*)                                    AS invoices,
    COUNT(DISTINCT CustomerId)                  AS customers,
    ROUND(SUM(Total), 2)                        AS revenue,
    ROUND(SUM(Total) * 1.0 / COUNT(*), 2)       AS avg_order_value
FROM Invoice
GROUP BY country
ORDER BY revenue DESC
LIMIT 10;
