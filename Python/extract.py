import pandas as pd

def extract_orders(engine):

    query = """
    SELECT
        o.row_id,
        o.order_id,
        o.order_date,
        o.ship_date,
        o.ship_mode,
        o.customer_id,
        o.product_id,
        o.quantity,
        o.discount,
        o.sales,
        o.profit,
        o.payment_mode,

        c.customer_name,
        c.segment,
        c.city,
        c.state,
        c.region,

        p.category,
        p.sub_category,
        p.product_name,
        p.min_price,
        p.max_price,
        p.base_margin

    FROM orders o
    JOIN customers c
        ON o.customer_id = c.customer_id
    JOIN products p
        ON o.product_id = p.product_id;
    """

    return pd.read_sql(query, engine)