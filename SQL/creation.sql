-- Creation of tables 

CREATE TABLE customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    customer_name VARCHAR(120) NOT NULL,
    segment VARCHAR(50), city VARCHAR(80), state VARCHAR(80), region VARCHAR(30)
);

CREATE TABLE products (
    product_id VARCHAR(20) PRIMARY KEY,
    category VARCHAR(80), sub_category VARCHAR(80), product_name VARCHAR(150) NOT NULL,
    min_price NUMERIC(12,2), max_price NUMERIC(12,2), base_margin NUMERIC(6,4)
);

CREATE TABLE orders (
    row_id INT PRIMARY KEY,
    order_id VARCHAR(30) NOT NULL,
    order_date DATE, ship_date DATE, ship_mode VARCHAR(50),
    customer_id VARCHAR(20) NOT NULL,
    product_id VARCHAR(20) NOT NULL,
    quantity INT, discount NUMERIC(5,2), sales NUMERIC(14,2), profit NUMERIC(14,2), payment_mode VARCHAR(50),
    CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    CONSTRAINT fk_orders_product FOREIGN KEY (product_id) REFERENCES products(product_id)
);


select * from customers;
select * from orders;

-- check total rows and check unique records 
select count(*) as total_orders from orders;
select count(distinct order_id) as unique_orders,
count(distinct product_id) as unique_products,
count(distinct customer_id) as unique_customers from orders;

--check if any customer_id is there in orders absent in customers 
select o.customer_id from orders o 
left join customers c on o.customer_id = c.customer_id
where c.customer_id is null;

-- check if any product_id is there in orders absent in products
select o.product_id from orders o
left join products p on o.product_id = p.product_id
where p.product_id is null;

