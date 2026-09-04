-- Business question: How has monthly revenue trended over time?

SELECT
    strftime('%Y-%m', InvoiceDate)   AS year_month,
    ROUND(SUM(Total), 2)            AS monthly_revenue,
    COUNT(*)                        AS invoice_count
FROM Invoice
GROUP BY year_month
ORDER BY year_month;
