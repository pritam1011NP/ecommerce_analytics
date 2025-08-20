
-- 02_load_data.sql
-- Load CSVs using COPY (adjust file paths if not using Docker compose setup)

-- Example using absolute paths (Linux/Mac). For Windows, use a suitable path or \\COPY in psql.
-- You can also use \\COPY from psql for client-side file paths.

TRUNCATE ecommerce.fact_sales, ecommerce.dim_customers, ecommerce.dim_products, ecommerce.dim_dates, ecommerce.dim_regions RESTART IDENTITY;

\copy ecommerce.dim_customers (customer_id,first_name,last_name,gender,email,join_date)
FROM './data/dim_customers.csv' WITH (FORMAT csv, HEADER true);

\copy ecommerce.dim_products (product_id,product_name,category,brand)
FROM './data/dim_products.csv' WITH (FORMAT csv, HEADER true);

\copy ecommerce.dim_dates (date_id,full_date,year,quarter,month,month_name,day,weekday,is_weekend)
FROM './data/dim_dates.csv' WITH (FORMAT csv, HEADER true);

\copy ecommerce.dim_regions (region_id,region_name,country)
FROM './data/dim_regions.csv' WITH (FORMAT csv, HEADER true);

\copy ecommerce.fact_sales (sale_id,customer_id,product_id,date_id,region_id,quantity,unit_price,discount_pct)
FROM './data/fact_sales.csv' WITH (FORMAT csv, HEADER true);
