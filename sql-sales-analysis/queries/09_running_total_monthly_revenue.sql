-- Business question: What does cumulative (running-total) revenue look like
-- month over month? Demonstrates a window function (SUM ... OVER).

WITH monthly AS (
    SELECT
        strftime('%Y-%m', InvoiceDate) AS year_month,
        SUM(Total)                     AS monthly_revenue
    FROM Invoice
    GROUP BY year_month
)
SELECT
    year_month,
    ROUND(monthly_revenue, 2) AS monthly_revenue,
    ROUND(SUM(monthly_revenue) OVER (ORDER BY year_month), 2) AS running_total_revenue
FROM monthly
ORDER BY year_month;
