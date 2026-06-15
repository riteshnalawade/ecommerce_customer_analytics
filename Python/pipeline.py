from config import get_engine
from extract import extract_orders
from clean import clean_orders
from rfm import create_rfm
from churn import create_churn
from load import (
    load_clean_orders,
    load_rfm,
    load_churn
)

engine = get_engine()

# Extract
df = extract_orders(engine)

# Clean
clean_df = clean_orders(df)
load_clean_orders(clean_df, engine)
clean_df.to_csv("clean_orders.csv", index=False)

# RFM
rfm_df = create_rfm(clean_df)
load_rfm(rfm_df, engine)
rfm_df.to_csv("rfm.csv", index=False)

# Churn
churn_df = create_churn(rfm_df)
load_churn(churn_df, engine)
churn_df.to_csv("churn.csv", index=False)

print("Pipeline completed successfully")