
-- 05_analytics.sql
-- Example analytical queries

-- Top 10 best-selling products by revenue
SELECT
    p.product_name,
    SUM((fs.quantity * fs.unit_price) * (1 - fs.discount_pct/100.0)) AS revenue
FROM ecommerce.fact_sales fs
JOIN ecommerce.dim_products p ON fs.product_id = p.product_id
GROUP BY p.product_name
ORDER BY revenue DESC
LIMIT 10;

-- Monthly revenue trend
SELECT
    d.year,
    d.month,
    d.month_name,
    SUM((fs.quantity * fs.unit_price) * (1 - fs.discount_pct/100.0)) AS monthly_revenue
FROM ecommerce.fact_sales fs
JOIN ecommerce.dim_dates d ON fs.date_id = d.date_id
GROUP BY d.year, d.month, d.month_name
ORDER BY d.year, d.month;

-- Customer ranking by total spend (RANK window function)
SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    SUM((fs.quantity * fs.unit_price) * (1 - fs.discount_pct/100.0)) AS total_spent,
    RANK() OVER (ORDER BY SUM((fs.quantity * fs.unit_price) * (1 - fs.discount_pct/100.0)) DESC) AS spend_rank
FROM ecommerce.fact_sales fs
JOIN ecommerce.dim_customers c ON fs.customer_id = c.customer_id
GROUP BY c.customer_id, customer_name
ORDER BY spend_rank
LIMIT 50;

-- Category share of revenue by region (uses MV if desired)
SELECT * FROM ecommerce.mv_revenue_by_category_region ORDER BY category, region_name;

-- Basket size distribution (avg quantity per order id bucketed)
SELECT
    width_bucket(quantity, 1, 5, 5) AS qty_bucket,
    COUNT(*) AS num_orders
FROM ecommerce.fact_sales
GROUP BY qty_bucket
ORDER BY qty_bucket;
