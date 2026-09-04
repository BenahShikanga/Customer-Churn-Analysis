-- Business question: Who are our top 10 customers by lifetime revenue?

SELECT
    c.CustomerId,
    c.FirstName || ' ' || c.LastName AS customer_name,
    c.Country,
    COUNT(i.InvoiceId)               AS orders,
    ROUND(SUM(i.Total), 2)           AS lifetime_revenue
FROM Customer c
JOIN Invoice i ON i.CustomerId = c.CustomerId
GROUP BY c.CustomerId, customer_name, c.Country
ORDER BY lifetime_revenue DESC
LIMIT 10;
