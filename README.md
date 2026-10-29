# 🛒 E-commerce Customer Analytics

An end-to-end analytics project for an Indian e-commerce business: **PostgreSQL → Python ETL → RFM segmentation → churn analysis → SQL insights → Power BI dashboard.**

![Python](https://img.shields.io/badge/Python-3.9%2B-blue)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-14%2B-336791)
![pandas](https://img.shields.io/badge/pandas-ETL-150458)
![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-F2C811)
![SQL](https://img.shields.io/badge/SQL-Analysis-orange)

---

## 📌 Table of Contents

- [Problem Statement](#-problem-statement)
- [Project Highlights](#-project-highlights)
- [Tech Stack](#-tech-stack)
- [Architecture](#-architecture)
- [Dataset](#-dataset)
- [Repository Structure](#-repository-structure)
- [How It Works](#-how-it-works)
- [Key Insights](#-key-insights)
- [Recommendations](#-recommendations)
- [Getting Started](#-getting-started)
- [Dashboard](#-dashboard)
- [Known Limitations & Future Work](#-known-limitations--future-work)
- [Author](#-author)

---

## 🎯 Problem Statement

The business had order, customer and product data spread across separate tables, with no unified view of:

1. Sales and profit trends by region, state, category, product and payment mode
2. Products and discount levels that quietly destroy profit
3. Who the most valuable customers are
4. Which customers are drifting away, and how much revenue is tied to them
5. A repeatable way to refresh all of the above

This project builds a clean, automated pipeline and analysis layer that answers those questions.

---

## ✨ Project Highlights

- Normalised **PostgreSQL schema** with primary/foreign keys and integrity checks
- Modular **Python ETL pipeline** (extract → clean → RFM → churn → load) runnable with one command
- **Data-quality flags** for invalid dates, discounts, shipping days and missing details
- **RFM segmentation** into VIP, Loyal, Regular, At-Risk and Lost customers
- **Churn classification** (Active / Warm / Churn Risk / Likely Churned) with **revenue at risk**
- **12 business SQL queries** covering KPIs, trends, geography, products, customers and payments
- Interactive **Power BI dashboard**

---

## 🧰 Tech Stack

| Tool | Purpose |
|---|---|
| PostgreSQL | Data storage, constraints, aggregations |
| SQL | Schema design, integrity checks, business analysis |
| Python (pandas, NumPy) | Cleaning, feature engineering, RFM and churn logic |
| SQLAlchemy, psycopg2 | Database connectivity |
| Jupyter Notebook | EDA before and after cleaning |
| Power BI | Dashboard and reporting |

---

## 🏗 Architecture

```
customers.csv / products.csv / orders.csv
            │   creation.sql
            ▼
  PostgreSQL: customers · products · orders
            │   extract.py   (JOIN all three tables)
            ▼
  clean.py ──► clean_orders    ┐
  rfm.py   ──► customer_rfm    ├─ load.py ─► PostgreSQL + CSV exports
  churn.py ──► customer_churn  ┘
            │
            ▼
  business_queries_project.sql  +  Power BI dashboard
```

---

## 📊 Dataset

Period: **1 Jan 2021 – 31 Dec 2024**

| File | Rows | Description |
|---|---|---|
| `customers.csv` | 720 | Customer name, segment, city, state, region |
| `products.csv` | 28 | Category, sub-category, product name, price range, base margin |
| `orders.csv` | 17,107 order lines (11,000 orders) | Dates, ship mode, quantity, discount, sales, profit, payment mode |

**Pipeline outputs:** `clean_orders` (27 columns), `customer_rfm`, `customer_churn`.

---

## 📁 Repository Structure

```
ecommerce-customer-analytics/
│
├── data/
│   ├── customers.csv
│   ├── products.csv
│   └── orders.csv
│
├── sql/
│   ├── creation.sql                  # Source tables + integrity checks
│   ├── clean_tables.sql              # Output tables (clean orders, RFM, churn)
│   └── business_queries_project.sql  # Business analysis queries
│
├── pipeline/
│   ├── config.py                     # Database connection
│   ├── extract.py                    # Join and extract data
│   ├── clean.py                      # Cleaning + feature engineering
│   ├── rfm.py                        # RFM scoring and segmentation
│   ├── churn.py                      # Churn status + revenue at risk
│   ├── load.py                       # Write results to PostgreSQL
│   └── pipeline.py                   # Runs the full workflow
│
├── notebooks/
│   ├── EDA_before_cleaning.ipynb
│   └── eda_after_cleaning.ipynb
│
├── outputs/
│   ├── clean_orders.csv
│   ├── rfm.csv
│   └── churn.csv
│
├── dashboard/
│   └── ecommerce_analytics.pbix
│
├── requirements.txt
├── .env.example
├── .gitignore
└── README.md
```

> If you keep all files in one folder instead, the commands below work the same; just drop the folder prefixes.

---

## ⚙️ How It Works

### 1. Database setup (`creation.sql`)
Creates `customers`, `products` and `orders` with PK/FK constraints and runs checks to confirm every order maps to a valid customer and product.

### 2. Extraction (`extract.py`)
Joins orders, customers and products into one analysis-ready dataset.

### 3. Cleaning (`clean.py`)
- Removes duplicates and parses dates
- Converts numeric columns and imputes missing values (mean for quantity, discount and base margin; category-wise median for sales and profit; `"Unknown"` for text)
- Adds quality flags: `invalid_order_date`, `invalid_ship_date`, `missing_customer_details`, `missing_product_details`, `invalid_discount`, `negative_ship_days`
- Creates `profit_margin`, `order_year`, `order_month`, `ship_days`
- Drops rows with negative sales or quantity

### 4. RFM segmentation (`rfm.py`)
Snapshot date = last order date + 1 day. Each customer is scored 1–5 on Recency, Frequency and Monetary value.

| Segment | Rule |
|---|---|
| VIP Customers | R, F, M all ≥ 4 |
| Loyal Customers | R ≥ 3 and F ≥ 3 |
| At-Risk Customers | R ≤ 2 and F ≥ 3 |
| Lost Customers | R ≤ 2 and F ≤ 2 |
| Regular Customers | All others |

### 5. Churn classification (`churn.py`)

| Days since last order | Status |
|---|---|
| ≤ 30 | Active |
| 31–90 | Warm |
| 91–180 | Churn Risk |
| > 180 | Likely Churned |

`revenue_at_risk` = total spend of Churn Risk and Likely Churned customers.

### 6. Load and analyse
Results are written to PostgreSQL (`clean_orders`, `customer_rfm`, `customer_churn`) and exported to CSV for Power BI. `business_queries_project.sql` contains the analysis queries.

---

## 🔍 Key Insights

| Metric | Value |
|---|---|
| Total sales | ₹44.07 Cr |
| Total profit | ₹4.27 Cr (9.7% margin) |
| Orders / customers | 11,000 / 720 |

- **Electronics** drives about 76% of profit at a 13.4% margin.
- **Furniture** is 33% of sales but earns only a **1.5% margin**. **Sofas are loss-making** (−0.2% margin), led by the Pepperfry Sofa Set.
- **Discounts erode profit:** margin falls from **12.1%** (no discount) to **2.6%** (20–30% discount).
- **Fashion** (18.9%) and **Home & Kitchen** (15.5%) have the best margins but are small.
- **Central region** is the smallest (3% of sales) with the weakest margin (8.9%).
- **Customer base is not concentrated:** the top 10% of customers account for about 21% of sales.
- **₹14.38 Cr (about 33% of lifetime revenue)** is tied to **252** Churn Risk or Likely Churned customers.
- **At-Risk customers (157)** buy often but have been inactive for about 5 months on average.

---

## 💡 Recommendations

**Protect profit**
- Cap discounts at roughly 15–20% and require approval above that
- Fix Furniture pricing and supplier costs, starting with Sofas
- Shift marketing toward high-margin Fashion and Home & Kitchen

**Win back customers**
- Run a targeted campaign on the 161 Churn Risk customers using the top at-risk list
- Prefer low-cost incentives (free shipping, loyalty points) over deep discounts
- Trigger alerts at about 60 days of inactivity for frequent buyers

**Grow the best customers**
- Launch a VIP/Loyal rewards programme (275 customers, about 46% of revenue)
- Nudge Regular customers toward higher frequency

**Operations**
- Review the Central region and Net Banking (lowest-margin payment mode)

---

## 🚀 Getting Started

### Prerequisites
- Python 3.9+
- PostgreSQL 14+
- Power BI Desktop (to open the dashboard)

### 1. Clone the repository
```bash
git clone https://github.com/riteshnalawade/ecommerce-customer-analytics.git
cd ecommerce-customer-analytics
```

### 2. Install dependencies
```bash
pip install -r requirements.txt
```

`requirements.txt`:
```
pandas
numpy
sqlalchemy
psycopg2-binary
```

### 3. Set up the database
1. Create a PostgreSQL database whose name starts with `ecommerce` (for example `ecommerce_analytics`).
2. Run `sql/creation.sql`.
3. Import the three CSVs from `data/` into `customers`, `products` and `orders` (in that order).
4. Run `sql/clean_tables.sql`.

### 4. Configure credentials
Do **not** hard-code your password. Copy `.env.example` to `.env` and fill in your values:

```
DB_HOST=127.0.0.1
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=your_password_here
```

Then update `config.py` to read these with `os.getenv(...)` instead of literal values. Make sure `.env` is listed in `.gitignore`.

### 5. Run the pipeline
```bash
python pipeline.py
```

This extracts and cleans the data, builds RFM and churn tables, loads them into PostgreSQL, and writes `clean_orders.csv`, `rfm.csv` and `churn.csv`.

### 6. Run the analysis
Open `sql/business_queries_project.sql` in pgAdmin or `psql` and run the queries.

### 7. Open the dashboard
Open `dashboard/ecommerce_analytics.pbix` in Power BI Desktop and refresh the data source.

---

## 📈 Dashboard

Add screenshots of your Power BI pages here:

```
![Overview](images/dashboard_overview.png)
![RFM and Churn](images/dashboard_rfm_churn.png)
```

---

## 🔧 Known Limitations & Future Work

- `load.py` uses `if_exists="replace"`, which drops PK/FK constraints on output tables; switch to truncate-and-append or re-apply constraints after load
- Quality flag columns from `clean.py` are not in the `clean_orders` table definition in `clean_tables.sql`
- Mean imputation can create fractional quantities; consider median or product-wise imputation
- Churn thresholds are fixed (30/90/180 days); a per-customer purchase-cycle approach would be more accurate
- Add a predictive churn model, Customer Lifetime Value and seasonality analysis
- Schedule the pipeline (cron or Airflow) and add logging and tests

---

## 👤 Author

**Your Name**
[LinkedIn](https://linkedin.com/in/riteshnalawade/) · [GitHub](https://github.com/riteshnalawade)

---

⭐ If you found this project useful, consider giving it a star.
