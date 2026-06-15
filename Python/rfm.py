import pandas as pd

def segment_customer(row):

    if (
        row["r_score"] >= 4 and
        row["f_score"] >= 4 and
        row["m_score"] >= 4
    ):
        return "VIP Customers"

    if (
        row["r_score"] >= 3 and
        row["f_score"] >= 3
    ):
        return "Loyal Customers"

    if (
        row["r_score"] <= 2 and
        row["f_score"] >= 3
    ):
        return "At-Risk Customers"

    if (
        row["r_score"] <= 2 and
        row["f_score"] <= 2
    ):
        return "Lost Customers"

    return "Regular Customers"


def create_rfm(df):

    # Ensure date format
    df["order_date"] = pd.to_datetime(df["order_date"])

    #Removing invalid order dates column 
    df = df.dropna(subset=["order_date"]).copy()

    # Snapshot date
    snapshot = (
        df["order_date"].max() +
        pd.Timedelta(days=1)
    )

    # RFM Aggregation
    rfm = (
        df.groupby(
            [
                "customer_id",
                "customer_name",
                "segment",
                "city",
                "state",
                "region"
            ]
        )
        .agg(
            last_purchase=("order_date", "max"),
            frequency=("order_id", "nunique"),
            monetary=("sales", "sum"),
            profit=("profit", "sum")
        )
        .reset_index()
    )

    # Recency
    rfm["recency"] = (
        snapshot - rfm["last_purchase"]
    ).dt.days

    # Scores
    rfm["r_score"] = pd.qcut(
        rfm["recency"].rank(method="first"),
        5,
        labels=[5, 4, 3, 2, 1]
    ).astype(int)

    rfm["f_score"] = pd.qcut(
        rfm["frequency"].rank(method="first"),
        5,
        labels=[1, 2, 3, 4, 5]
    ).astype(int)

    rfm["m_score"] = pd.qcut(
        rfm["monetary"].rank(method="first"),
        5,
        labels=[1, 2, 3, 4, 5]
    ).astype(int)

    # Combined Score
    rfm["rfm_score"] = (
        rfm["r_score"].astype(str)
        + rfm["f_score"].astype(str)
        + rfm["m_score"].astype(str)
    )

    # Customer Segment
    rfm["customer_segment"] = (
        rfm.apply(segment_customer, axis=1)
    )
    return rfm