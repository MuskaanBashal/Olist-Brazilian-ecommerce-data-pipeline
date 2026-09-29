import sqlite3
import pandas as pd
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent
DB_PATH = BASE_DIR / "database" / "olist.db"
OUTPUT_DIR = BASE_DIR / "dashboard_data"

OUTPUT_DIR.mkdir(exist_ok=True)

conn = sqlite3.connect(DB_PATH)

queries = {
    "monthly_revenue": """
        SELECT
            strftime('%Y-%m', o.order_purchase_timestamp) AS month,
            ROUND(SUM(p.payment_value), 2) AS revenue
        FROM orders o
        JOIN payments p ON o.order_id = p.order_id
        WHERE o.order_status = 'delivered'
        GROUP BY month
        ORDER BY month
    """,

    "product_categories": """
        SELECT
            COALESCE(
                t.product_category_name_english,
                p.product_category_name
            ) AS category,
            COUNT(DISTINCT oi.order_id) AS total_orders,
            ROUND(SUM(oi.price), 2) AS revenue
        FROM order_items oi
        JOIN products p ON oi.product_id = p.product_id
        LEFT JOIN category_translation t
            ON p.product_category_name = t.product_category_name
        WHERE p.product_category_name IS NOT NULL
        GROUP BY category
        ORDER BY revenue DESC
    """,

    "customers_by_state": """
        SELECT
            customer_state AS state,
            COUNT(DISTINCT customer_unique_id) AS customers
        FROM customers
        GROUP BY customer_state
        ORDER BY customers DESC
    """,

    "delivery_reviews": """
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
        JOIN reviews r ON o.order_id = r.order_id
        WHERE o.order_status = 'delivered'
          AND o.order_delivered_customer_date IS NOT NULL
          AND o.order_estimated_delivery_date IS NOT NULL
        GROUP BY delivery_status
    """,
    "kpis": """
    WITH order_totals AS (
        SELECT
            order_id,
            SUM(payment_value) AS order_value
        FROM payments
        GROUP BY order_id
    )

    SELECT
        (SELECT ROUND(SUM(payment_value), 2)
         FROM payments) AS total_payment_value,

        (SELECT COUNT(*)
         FROM orders) AS total_orders,

        (SELECT ROUND(AVG(order_value), 2)
         FROM order_totals) AS average_order_value,

        (SELECT ROUND(AVG(review_score), 2)
         FROM reviews) AS average_review_score
"""
    
}

for filename, query in queries.items():

    df = pd.read_sql_query(query, conn)

    output = OUTPUT_DIR / f"{filename}.csv"
    df.to_csv(output, index=False)

    print(f"Created: {output}")

conn.close()

print("\nDashboard datasets exported successfully.")

