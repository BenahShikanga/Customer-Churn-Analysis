-- Business question: How does revenue break down by sales support representative
-- (each customer is assigned to one employee via SupportRepId)?

SELECT
    e.EmployeeId,
    e.FirstName || ' ' || e.LastName AS sales_rep,
    e.Title,
    COUNT(DISTINCT c.CustomerId)     AS customers_managed,
    COUNT(i.InvoiceId)               AS invoices_handled,
    ROUND(SUM(i.Total), 2)           AS revenue_generated
FROM Employee e
JOIN Customer c ON c.SupportRepId = e.EmployeeId
JOIN Invoice i  ON i.CustomerId = c.CustomerId
GROUP BY e.EmployeeId, sales_rep, e.Title
ORDER BY revenue_generated DESC;
