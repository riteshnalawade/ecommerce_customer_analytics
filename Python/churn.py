import numpy as np

def churn_status(days):

    if days <= 30:
        return "Active"

    if days <= 90:
        return "Warm"

    if days <= 180:
        return "Churn Risk"

    return "Likely Churned"


def create_churn(rfm_df):

    rfm_df["churn_status"] = (
        rfm_df["recency"]
        .apply(churn_status)
    )

    rfm_df["revenue_at_risk"] = np.where(
        rfm_df["churn_status"].isin(
            ["Churn Risk", "Likely Churned"]
        ),
        rfm_df["monetary"],
        0
    )

    return rfm_df