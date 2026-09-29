-- =====================================================
-- OLIST E-COMMERCE DASHBOARD ANALYTICS
-- =====================================================


-- 1. TOP PRODUCT CATEGORIES BY REVENUE
SELECT
    COALESCE(
        t.product_category_name_english,
        p.product_category_name
    ) AS category,

    COUNT(DISTINCT oi.order_id) AS total_orders,

    ROUND(SUM(oi.price), 2) AS revenue

FROM order_items oi

JOIN products p
    ON oi.product_id = p.product_id

LEFT JOIN category_translation t
    ON p.product_category_name = t.product_category_name

GROUP BY category
ORDER BY revenue DESC
LIMIT 10;


-- 2. MONTHLY REVENUE
SELECT
    strftime('%Y-%m', o.order_purchase_timestamp) AS month,
    ROUND(SUM(p.payment_value), 2) AS revenue

FROM orders o

JOIN payments p
    ON o.order_id = p.order_id

WHERE o.order_status = 'delivered'

GROUP BY month
ORDER BY month;


-- 3. CUSTOMERS BY STATE
SELECT
    customer_state AS state,
    COUNT(DISTINCT customer_unique_id) AS customers

FROM customers

GROUP BY customer_state
ORDER BY customers DESC;


-- 4. DELIVERY PERFORMANCE
SELECT
    CASE
        WHEN datetime(order_delivered_customer_date)
             > datetime(order_estimated_delivery_date)
        THEN 'Late'
        ELSE 'On Time'
    END AS delivery_status,

    COUNT(*) AS orders

FROM orders

WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL

GROUP BY delivery_status;


-- 5. DELIVERY PERFORMANCE VS REVIEW SCORE
SELECT
    CASE
        WHEN datetime(o.order_delivered_customer_date)
             > datetime(o.order_estimated_delivery_date)
        THEN 'Late'
        ELSE 'On Time'
    END AS delivery_status,

    ROUND(AVG(r.review_score), 2) AS average_review_score

FROM orders o

JOIN reviews r
    ON o.order_id = r.order_id

WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL

GROUP BY delivery_status;


-- 6. PAYMENT METHOD ANALYSIS
SELECT
    payment_type,
    COUNT(*) AS transactions,
    ROUND(SUM(payment_value), 2) AS payment_value

FROM payments

GROUP BY payment_type
ORDER BY payment_value DESC;


-- 7. REVIEW SCORE DISTRIBUTION
SELECT
    review_score,
    COUNT(*) AS reviews

FROM reviews

GROUP BY review_score
ORDER BY review_score;


-- 8. CUSTOMER RETENTION
WITH customer_orders AS (

    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS number_of_orders

    FROM customers c

    JOIN orders o
        ON c.customer_id = o.customer_id

    GROUP BY c.customer_unique_id
)

SELECT
    CASE
        WHEN number_of_orders = 1
        THEN 'One-time customer'
        ELSE 'Repeat customer'
    END AS customer_type,

    COUNT(*) AS customers

FROM customer_orders

GROUP BY customer_type;