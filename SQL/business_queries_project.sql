-- Business_analysis_queries

--Sales and profit summary 
SELECT ROUND(SUM(sales)::numeric,2) AS total_sales,
ROUND(SUM(profit)::numeric,2) AS total_profit,
COUNT(DISTINCT order_id) AS total_orders,
COUNT(DISTINCT customer_id) AS total_customers,
ROUND((SUM(profit)::numeric/NULLIF(SUM(sales)::numeric,0))*100,2) AS profit_margin_percent 
FROM clean_orders;

-- Monthly sales trend 
SELECT order_month, ROUND(SUM(sales)::numeric,2) AS monthly_sales,
ROUND(SUM(profit)::numeric,2) AS monthly_profit,
COUNT(DISTINCT order_id) AS orders 
FROM clean_orders 
GROUP BY order_month;

--Region wise performance
SELECT region, ROUND(SUM(sales)::numeric,2) AS total_sales, ROUND(SUM(profit)::numeric,2) AS total_profit,
COUNT(DISTINCT order_id) AS total_orders, COUNT(DISTINCT customer_id) AS total_customers,
ROUND((SUM(profit)::numeric/NULLIF(SUM(sales)::numeric,0))*100,2) AS margin_percent 
FROM clean_orders
GROUP BY region 
ORDER BY total_sales DESC;

-- State wise performance 
SELECT state,ROUND(SUM(sales)::numeric,2) AS total_sales, 
ROUND(SUM(profit)::numeric,2) AS total_profit, 
COUNT(DISTINCT order_id) AS total_orders 
FROM clean_orders 
GROUP BY state 
ORDER BY total_sales Desc;

-- Category wise performance
SELECT category,ROUND(SUM(sales)::numeric,2) AS total_sales, 
ROUND(SUM(profit)::numeric,2) AS total_profit, 
ROUND((SUM(profit)::numeric/NULLIF(SUM(sales)::numeric,0))*100,2) AS margin_percent 
FROM clean_orders 
GROUP BY category 
ORDER BY total_sales DESC;

-- Finding out top customers 
SELECT customer_name, city, state, region,
ROUND(SUM(sales)::numeric,2) AS total_sales,
ROUND(SUM(profit)::numeric,2) AS total_profit,
COUNT(DISTINCT order_id) AS orders 
FROM clean_orders 
GROUP BY customer_name, city, state, region 
ORDER BY total_sales DESC LIMIT 10;

-- Top 10 products by profit
SELECT product_name,category,ROUND(SUM(sales)::numeric,2) AS total_sales, 
ROUND(SUM(profit)::numeric,2) AS total_profit, SUM(quantity) AS total_quantity 
FROM clean_orders 
GROUP BY product_name,category
ORDER BY total_profit DESC LIMIT 10;

-- Loss-making products 
SELECT product_name,category,ROUND(SUM(sales)::numeric,2) AS total_sales,
ROUND(SUM(profit)::numeric,2) AS total_profit 
FROM clean_orders 
GROUP BY product_name,category HAVING SUM(profit) < 0 
ORDER BY total_profit ASC;

-- Rfm segment summary 
SELECT 
 customer_segment, 
 COUNT(*) AS customer_count,
 ROUND(SUM(monetary)::numeric,2) AS total_revenue,
 ROUND(SUM(profit)::numeric,2) AS total_profit,
 ROUND(AVG(recency)::numeric,2) AS avg_recency
FROM customer_rfm 
GROUP BY customer_segment
ORDER BY total_revenue DESC;

-- Churn segment summary
SELECT  
      churn_status,
	  COUNT(*) AS customer_count,
	  ROUND(SUM(monetary)::numeric ,2) AS total_customer_value,
	  ROUND(SUM(revenue_at_risk)::numeric,2) AS revenue_at_risk 
FROM customer_churn 
GROUP BY churn_status 
ORDER BY revenue_at_risk DESC;

-- Top at-risk customers 
SELECT 
     customer_name, city, state, region,
	 recency,
	 frequency,
	 ROUND(monetary::numeric,2) AS total_spent,
	 ROUND(revenue_at_risk::numeric ,2) AS revenue_at_risk, 
	 churn_status 
FROM customer_churn
WHERE churn_status IN ('Churn Risk','Likely Churned') 
ORDER BY revenue_at_risk DESC LIMIT 20;

-- Payment mode performance analysis
SELECT 
      payment_mode,
	  COUNT(DISTINCT order_id) AS orders,
	  ROUND(SUM(sales)::numeric,2) AS sales,
	  ROUND(SUM(profit)::numeric,2) AS profit
FROM clean_orders 
GROUP BY payment_mode 
ORDER BY sales DESC;



