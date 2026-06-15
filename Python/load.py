# load.py

def load_clean_orders(df, engine):

    df.to_sql(
        "clean_orders",
        engine,
        if_exists="replace",
        index=False
    )

    print("clean_orders loaded successfully")


def load_rfm(rfm_df, engine):

    rfm_df.to_sql(
        "customer_rfm",
        engine,
        if_exists="replace",
        index=False
    )

    print("customer_rfm loaded successfully")


def load_churn(churn_df, engine):

    churn_df.to_sql(
        "customer_churn",
        engine,
        if_exists="replace",
        index=False
    )

    print("customer_churn loaded successfully")