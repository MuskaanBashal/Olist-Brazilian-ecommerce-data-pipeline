import pandas as pd
import sqlite3
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent

PROCESSED_DIR = BASE_DIR / "data" / "processed"
DATABASE_DIR = BASE_DIR / "database"
DATABASE_PATH = DATABASE_DIR / "olist.db"


def load():

    print("Starting database load...")

    DATABASE_DIR.mkdir(parents=True, exist_ok=True)

    conn = sqlite3.connect(DATABASE_PATH)

    files = {
        "customers": "customers.csv",
        "orders": "orders.csv",
        "order_items": "order_items.csv",
        "payments": "payments.csv",
        "products": "products.csv",
        "sellers": "sellers.csv",
        "reviews": "reviews.csv",
        "category_translation": "category_translation.csv",
        
    }

    for table_name, filename in files.items():

        file_path = PROCESSED_DIR / filename

        print(f"Loading {table_name}...")

        df = pd.read_csv(file_path)

        df.to_sql(
            table_name,
            conn,
            if_exists="replace",
            index=False
        )

        print(f"Loaded {len(df):,} rows into {table_name}")

    conn.close()

    print("\nDatabase load complete.")
    print(f"Database: {DATABASE_PATH}")


if __name__ == "__main__":
    load()