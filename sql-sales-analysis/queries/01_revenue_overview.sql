-- Business question: What does the overall business look like — total revenue,
-- total orders, total customers, and average order value?

SELECT
    ROUND(SUM(Total), 2)                         AS total_revenue,
    COUNT(*)                                     AS total_invoices,
    COUNT(DISTINCT CustomerId)                   AS total_customers,
    ROUND(SUM(Total) * 1.0 / COUNT(*), 2)        AS avg_order_value,
    ROUND(SUM(Total) * 1.0 / COUNT(DISTINCT CustomerId), 2) AS avg_revenue_per_customer
FROM Invoice;
