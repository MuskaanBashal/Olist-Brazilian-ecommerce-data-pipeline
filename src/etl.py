import kagglehub
import pandas as pd
from pathlib import Path

DATASET = "olistbr/brazilian-ecommerce"

BASE_DIR = Path(__file__).resolve().parent.parent
RAW_DIR = BASE_DIR / "data"
PROCESSED_DIR = BASE_DIR / "data" / "processed"


def extract():
    """Extract the Olist Brazilian e-commerce dataset from Kaggle."""

    print("Starting extraction...")

    dataset_path = kagglehub.dataset_download(DATASET)
    dataset_path = Path(dataset_path)

    print("Extraction complete.")
    print(f"Dataset location: {dataset_path}")

    return dataset_path


def transform():
    """Clean and transform the Olist datasets."""

    print("\nStarting transformation...")

    PROCESSED_DIR.mkdir(parents=True, exist_ok=True)

    files = {
        "customers": "olist_customers_dataset.csv",
        "orders": "olist_orders_dataset.csv",
        "order_items": "olist_order_items_dataset.csv",
        "payments": "olist_order_payments_dataset.csv",
        "products": "olist_products_dataset.csv",
        "sellers": "olist_sellers_dataset.csv",
        "reviews": "olist_order_reviews_dataset.csv",
        "category_translation": "product_category_name_translation.csv",
    }

    for name, filename in files.items():

        input_path = RAW_DIR / filename

        print(f"Processing {filename}...")

        df = pd.read_csv(input_path)

        # Remove duplicate rows
        df = df.drop_duplicates()

        # Remove leading/trailing spaces from column names
        df.columns = df.columns.str.strip()

        output_path = PROCESSED_DIR / f"{name}.csv"

        df.to_csv(output_path, index=False)

        print(
            f"Saved {name}.csv "
            f"({len(df):,} rows, {len(df.columns)} columns)"
        )

    print("\nTransformation complete.")


if __name__ == "__main__":

    extract()
    transform()