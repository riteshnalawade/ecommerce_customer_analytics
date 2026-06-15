import pandas as pd
import numpy as np

def clean_orders(df):

    # Remove duplicates
    df = df.drop_duplicates()

    # Convert date columns
    df["order_date"] = pd.to_datetime(df["order_date"], errors="coerce")
    df["ship_date"] = pd.to_datetime(df["ship_date"], errors="coerce")

    # Date quality flags
    df["invalid_order_date"] = df["order_date"].isna()
    df["invalid_ship_date"] = df["ship_date"].isna()

    # Convert numeric columns
    numeric_cols = [
        "quantity",
        "discount",
        "sales",
        "profit",
        "min_price",
        "max_price",
        "base_margin"
    ]

    for col in numeric_cols:
        df[col] = pd.to_numeric(df[col], errors="coerce")

    # Fill missing numeric values
    # Quantity
    df["quantity"] = df["quantity"].fillna(
    df["quantity"].mean()
    )
    
    # Discount
    df["discount"] = df["discount"].fillna(
    df["discount"].mean()
    )

    # Base margin
    df["base_margin"] = df["base_margin"].fillna(
    df["base_margin"].mean()
     )

    # Sales and profit
    # Fill missing sales with category-wise median
    df["sales"] = df["sales"].fillna(
    df.groupby("category")["sales"].transform("median"))

    # Fill missing profit with category-wise median
    df["profit"] = df["profit"].fillna(
    df.groupby("category")["profit"].transform("median"))

    # Fill missing text values
    text_cols = [
        "ship_mode",
        "customer_id",
        "product_id",
        "payment_mode",
        "customer_name",
        "segment",
        "city",
        "state",
        "region",
        "category",
        "sub_category",
        "product_name"
    ]

    for col in text_cols:
        df[col] = df[col].fillna("Unknown")

    # Referential integrity flags
    df["missing_customer_details"] = (
    df["customer_name"] == "Unknown")

    df["missing_product_details"] = (
    df["product_name"] == "Unknown")

    # Create profit margin
    df["profit_margin"] = df["profit"] / df["sales"]
    df["profit_margin"] = df["profit_margin"].replace(
        [np.inf, -np.inf], 0
    )
    df["profit_margin"] = df["profit_margin"].fillna(0)

    # Discount quality flag
    df["invalid_discount"] = (
        (df["discount"] < 0) |
        (df["discount"] > 1)
    )

    # Create date-based columns
    df["order_year"] = df["order_date"].dt.year
    df["order_month"] = (
        df["order_date"]
        .dt.to_period("M")
        .astype(str)
    )

    # Create shipping days
    df["ship_days"] = (
    df["ship_date"] - df["order_date"]).dt.days

   # Shipping quality flag
    df["negative_ship_days"] = df["ship_days"] < 0

    # Remove invalid rows
    df = df[df["sales"] >= 0]
    df = df[df["quantity"] >= 0]

    print("\n===== DATA QUALITY SUMMARY =====")
    print("Invalid order dates:", df["invalid_order_date"].sum())
    print("Invalid ship dates:", df["invalid_ship_date"].sum())
    print("Negative shipping days:", df["negative_ship_days"].sum())
    print("Invalid discounts:", df["invalid_discount"].sum())
    print("Missing customer details:", df["missing_customer_details"].sum())
    print("Missing product details:", df["missing_product_details"].sum())

    return df