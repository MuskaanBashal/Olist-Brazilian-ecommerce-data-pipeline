# Brazilian E-Commerce Analytics & ETL Pipeline

An end-to-end data engineering and analytics project built using **Python, Pandas, SQLite, SQL, and Tableau** to transform and analyse the Brazilian Olist e-commerce dataset.

The project demonstrates a complete analytics workflow — from raw data extraction and transformation through database loading, SQL analysis, dashboard dataset generation, and interactive business intelligence visualisation.

## Dashboard Preview

![E-Commerce Executive Dashboard](dashboard/E-Commerce%20Executive%20Dashboard.png)

## Project Overview

This project analyses Brazilian e-commerce marketplace data to understand:

- Sales and payment trends
- Product category performance
- Geographic customer distribution
- Delivery performance
- Customer satisfaction
- Customer retention behaviour

The workflow was designed as a reproducible ETL and analytics pipeline rather than analysing the raw CSV files directly.

## Architecture

```text
Kaggle Dataset
      ↓
Python Extraction
      ↓
Pandas Transformation
      ↓
Processed CSV Files
      ↓
SQLite Database
      ↓
SQL Analysis
      ↓
Dashboard Data Exports
      ↓
Tableau Dashboard
```

## Technology Stack

| Technology | Purpose |
|---|---|
| Python | ETL pipeline and automation |
| Pandas | Data cleaning and transformation |
| SQLite | Relational data storage |
| SQL | Data analysis and aggregation |
| Tableau | Dashboard development and visualisation |
| KaggleHub | Dataset extraction |
| Git & GitHub | Version control and project documentation |

## ETL Pipeline

### Extract

The source dataset is retrieved programmatically using KaggleHub.

### Transform

Python and Pandas are used to:

- Load source CSV files
- Remove duplicate records
- Standardise column names
- Prepare structured datasets
- Generate processed CSV files

### Load

The transformed datasets are loaded into a SQLite database containing tables for:

- Customers
- Orders
- Order items
- Payments
- Products
- Sellers
- Reviews
- Product category translations

## SQL Analysis

SQL queries were developed to investigate:

- Monthly payment trends
- Product category performance
- Customer distribution by state
- Payment-method usage
- Average order value
- Review-score distribution
- Delivery performance
- Repeat versus one-time customers
- Relationship between delivery timeliness and customer reviews

Dashboard-ready datasets are subsequently exported using Python.

## Key Findings

- **99,441 orders** were represented in the orders dataset.
- Total recorded **payment value was approximately $16.01M**.
- **Average order value was $160.99**, calculated after aggregating payments to order level.
- The overall **average review score was 4.09/5**.
- São Paulo represented the largest customer base among Brazilian states.
- Health & Beauty was the highest-value product category based on item-price totals.
- On-time delivered orders had an average review score of approximately **4.29/5**, compared with **2.57/5** for late deliveries, indicating a strong association between delivery performance and customer satisfaction.

> **Note:** Monetary values reflect the currency represented in the source Olist dataset. Product-category value is based on item prices, while the headline payment KPI is based on recorded payment values.

## Dashboard

The Tableau executive dashboard presents four headline KPIs:

- Total Payment Value
- Total Orders
- Average Order Value
- Average Review Score

It also includes visual analysis of:

- Monthly payment trends
- Top product categories
- Customer distribution by state
- Delivery performance and customer satisfaction

The packaged Tableau workbook is available in:

`dashboard/Brazilian_ECommerce_Analytics.twbx`

## Project Structure

```text
olist-ecommerce-data-pipeline/
│
├── dashboard/
│   ├── Brazilian_ECommerce_Analytics.twbx
│   └── E-Commerce Executive Dashboard.png
│
├── dashboard_data/
│   ├── customers_by_state.csv
│   ├── delivery_reviews.csv
│   ├── kpis.csv
│   ├── monthly_revenue.csv
│   └── product_categories.csv
│
├── sql/
│   ├── analysis.sql
│   └── dashboard_queries.sql
│
├── src/
│   ├── etl.py
│   ├── export_dashboard.py
│   └── load.py
│
├── .gitignore
├── requirements.txt
├── pyproject.toml
└── README.md
```

Raw datasets and generated database files are excluded from version control through `.gitignore`.

## Running the Project

Clone the repository:

```bash
git clone <repository-url>
cd olist-ecommerce-data-pipeline
```

Create and activate a virtual environment:

```bash
python3 -m venv .venv
source .venv/bin/activate
```

Install dependencies:

```bash
pip install -r requirements.txt
```

Run the ETL pipeline:

```bash
python3 src/etl.py
```

Load the processed data into SQLite:

```bash
python3 src/load.py
```

Export the Tableau-ready datasets:

```bash
python3 src/export_dashboard.py
```

## Dataset

This project uses the **Brazilian E-Commerce Public Dataset by Olist**, containing anonymised marketplace information covering orders, customers, products, sellers, payments, reviews, and delivery activity.

## Future Improvements

Potential extensions include:

- Automated data-quality validation
- Dimensional/star-schema modelling
- Customer segmentation
- Cohort and retention analysis
- Delivery-delay prediction
- Containerisation with Docker
- Cloud-based ETL orchestration
- Automated CI/CD testing

## Author

**Muskaan Bashal**
AI| Data Engineering | Data Analytics | Machine Learning 

Master of Information Technology in Data Science & Artificial Intelligence with Dissertation

Interests: Data Engineering | Data Analytics | Artificial Intelligence | Machine Learning
