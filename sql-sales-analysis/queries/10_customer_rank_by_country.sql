-- Business question: Within each country, who is the #1 customer by revenue?
-- Demonstrates a window function (RANK ... OVER PARTITION BY).

WITH customer_revenue AS (
    SELECT
        c.Country,
        c.CustomerId,
        c.FirstName || ' ' || c.LastName AS customer_name,
        SUM(i.Total)                     AS revenue
    FROM Customer c
    JOIN Invoice i ON i.CustomerId = c.CustomerId
    GROUP BY c.Country, c.CustomerId, customer_name
),
ranked AS (
    SELECT
        *,
        RANK() OVER (PARTITION BY Country ORDER BY revenue DESC) AS rank_in_country
    FROM customer_revenue
)
SELECT Country, customer_name, ROUND(revenue, 2) AS revenue
FROM ranked
WHERE rank_in_country = 1
ORDER BY revenue DESC;
