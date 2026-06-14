DROP TABLE IF EXISTS customer_churn CASCADE; DROP TABLE IF EXISTS customer_rfm CASCADE; DROP TABLE IF EXISTS clean_orders CASCADE;

CREATE TABLE clean_orders (
    row_id INT PRIMARY KEY, order_id VARCHAR(30), order_date DATE, ship_date DATE, ship_mode VARCHAR(50),
    customer_id VARCHAR(20), product_id VARCHAR(20), quantity INT, discount NUMERIC(5,2), sales NUMERIC(14,2),
	profit NUMERIC(14,2), payment_mode VARCHAR(50),customer_name VARCHAR(120), segment VARCHAR(50), city VARCHAR(80), 
	state VARCHAR(80), region VARCHAR(30),category VARCHAR(80), sub_category VARCHAR(80), product_name VARCHAR(150),
	min_price NUMERIC(12,2), max_price NUMERIC(12,2), base_margin NUMERIC(6,4),profit_margin NUMERIC(10,4), order_year INT,
	order_month VARCHAR(7), ship_days INT,CONSTRAINT fk_clean_customer FOREIGN KEY (customer_id) 
	REFERENCES customers(customer_id),CONSTRAINT fk_clean_product FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE customer_rfm (
    customer_id VARCHAR(20) PRIMARY KEY, customer_name VARCHAR(120), segment VARCHAR(50), city VARCHAR(80), state VARCHAR(80), 
	region VARCHAR(30),last_purchase DATE, frequency INT, monetary NUMERIC(14,2), profit NUMERIC(14,2), recency INT,
	r_score INT, f_score INT, m_score INT, rfm_score VARCHAR(3), customer_segment VARCHAR(50),
    CONSTRAINT fk_rfm_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE customer_churn (
    customer_id VARCHAR(20) PRIMARY KEY, customer_name VARCHAR(120), segment VARCHAR(50), city VARCHAR(80), state VARCHAR(80), 
	region VARCHAR(30),last_purchase DATE, frequency INT, monetary NUMERIC(14,2), profit NUMERIC(14,2), recency INT, 
	r_score INT, f_score INT, m_score INT, rfm_score VARCHAR(3), customer_segment VARCHAR(50), churn_status VARCHAR(50),
	revenue_at_risk NUMERIC(14,2),CONSTRAINT fk_churn_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

select * from clean_orders;
select * from customer_rfm;

select customer_segment,count(*)from customer_rfm 
group by customer_segment;

select * from customer_churn;
