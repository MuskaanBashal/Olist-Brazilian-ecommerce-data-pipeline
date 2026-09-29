-- ============================================
-- Olist Brazilian E-Commerce Analysis
-- ============================================

-- 1. Total number of orders
SELECT COUNT(*) AS total_orders
FROM orders;


-- 2. Orders by status
SELECT
    order_status,
    COUNT(*) AS number_of_orders
FROM orders
GROUP BY order_status
ORDER BY number_of_orders DESC;


-- 3. Total revenue
SELECT
    ROUND(SUM(payment_value), 2) AS total_revenue
FROM payments;


-- 4. Average order payment
SELECT
    ROUND(AVG(payment_value), 2) AS average_payment
FROM payments;


-- 5. Unique customers
SELECT
    COUNT(DISTINCT customer_unique_id) AS unique_customers
FROM customers;

-- ============================================
-- 6. Monthly Revenue Trend
-- ============================================

SELECT
    strftime('%Y-%m', o.order_purchase_timestamp) AS month,
    ROUND(SUM(p.payment_value), 2) AS revenue
FROM orders o
JOIN payments p
    ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY month
ORDER BY month;


-- ============================================
-- 7. Average Order Value
-- ============================================

WITH order_totals AS (
    SELECT
        order_id,
        SUM(payment_value) AS order_value
    FROM payments
    GROUP BY order_id
)

SELECT
    ROUND(AVG(order_value), 2) AS average_order_value
FROM order_totals;


-- ============================================
-- 8. Top 10 Customer States
-- ============================================

SELECT
    customer_state,
    COUNT(DISTINCT customer_unique_id) AS customers
FROM customers
GROUP BY customer_state
ORDER BY customers DESC
LIMIT 10;


-- ============================================
-- 9. Average Review Score
-- ============================================

SELECT
    ROUND(AVG(review_score), 2) AS average_review_score
FROM reviews;


-- ============================================
-- 10. Payment Methods
-- ============================================

SELECT
    payment_type,
    COUNT(*) AS transactions,
    ROUND(SUM(payment_value), 2) AS payment_value
FROM payments
GROUP BY payment_type
ORDER BY payment_value DESC;

-- ============================================
-- 11. Top Product Categories by Revenue
-- ============================================

SELECT
    p.product_category_name,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
WHERE p.product_category_name IS NOT NULL
GROUP BY p.product_category_name
ORDER BY revenue DESC
LIMIT 10;


-- ============================================
-- 12. Top Product Categories by Items Sold
-- ============================================

SELECT
    p.product_category_name,
    COUNT(*) AS items_sold
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
WHERE p.product_category_name IS NOT NULL
GROUP BY p.product_category_name
ORDER BY items_sold DESC
LIMIT 10;


-- ============================================
-- 13. Top Sellers by Revenue
-- ============================================

SELECT
    s.seller_id,
    s.seller_state,
    COUNT(DISTINCT oi.order_id) AS orders,
    ROUND(SUM(oi.price), 2) AS revenue
FROM order_items oi
JOIN sellers s
    ON oi.seller_id = s.seller_id
GROUP BY s.seller_id, s.seller_state
ORDER BY revenue DESC
LIMIT 10;


-- ============================================
-- 14. Late vs On-Time Delivery Reviews
-- ============================================

SELECT
    CASE
        WHEN datetime(o.order_delivered_customer_date)
             > datetime(o.order_estimated_delivery_date)
        THEN 'Late'
        ELSE 'On Time'
    END AS delivery_status,

    COUNT(*) AS orders,

    ROUND(AVG(r.review_score), 2) AS average_review_score

FROM orders o

JOIN reviews r
    ON o.order_id = r.order_id

WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL

GROUP BY delivery_status;


-- ============================================
-- 15. Average Delivery Time
-- ============================================

SELECT
    ROUND(
        AVG(
            julianday(order_delivered_customer_date)
            - julianday(order_purchase_timestamp)
        ),
        2
    ) AS average_delivery_days

FROM orders

WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL;


-- ============================================
-- 16. Repeat vs One-Time Customers
-- ============================================

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
        WHEN number_of_orders = 1 THEN 'One-time customer'
        ELSE 'Repeat customer'
    END AS customer_type,

    COUNT(*) AS customers

FROM customer_orders

GROUP BY customer_type;