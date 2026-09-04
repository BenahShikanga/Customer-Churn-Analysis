-- Business question: What share of customers are repeat buyers (2+ orders)
-- vs. one-time buyers, and how much revenue does each group represent?

WITH customer_orders AS (
    SELECT
        CustomerId,
        COUNT(*)        AS order_count,
        SUM(Total)      AS customer_revenue
    FROM Invoice
    GROUP BY CustomerId
)
SELECT
    CASE WHEN order_count > 1 THEN 'Repeat customer' ELSE 'One-time customer' END AS segment,
    COUNT(*)                                   AS customers,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM customer_orders), 1) AS pct_of_customers,
    ROUND(SUM(customer_revenue), 2)            AS total_revenue,
    ROUND(100.0 * SUM(customer_revenue) / (SELECT SUM(customer_revenue) FROM customer_orders), 1) AS pct_of_revenue
FROM customer_orders
GROUP BY segment;
