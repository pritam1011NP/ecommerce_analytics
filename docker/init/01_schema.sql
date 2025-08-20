
-- 01_schema.sql
-- E-Commerce Analytics Data Modeling (PostgreSQL)
-- Star schema: fact_sales + dimensions: customers, products, dates, regions

CREATE SCHEMA IF NOT EXISTS ecommerce;

-- Dimensions
CREATE TABLE IF NOT EXISTS ecommerce.dim_customers (
    customer_id   INT PRIMARY KEY,
    first_name    VARCHAR(50),
    last_name     VARCHAR(50),
    gender        CHAR(1) CHECK (gender IN ('M','F')),
    email         VARCHAR(255),
    join_date     DATE
);

CREATE TABLE IF NOT EXISTS ecommerce.dim_products (
    product_id    INT PRIMARY KEY,
    product_name  VARCHAR(150),
    category      VARCHAR(50),
    brand         VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS ecommerce.dim_dates (
    date_id     INT PRIMARY KEY,        -- YYYYMMDD
    full_date   DATE NOT NULL,
    year        INT,
    quarter     INT CHECK (quarter BETWEEN 1 AND 4),
    month       INT CHECK (month BETWEEN 1 AND 12),
    month_name  VARCHAR(20),
    day         INT CHECK (day BETWEEN 1 AND 31),
    weekday     VARCHAR(20),
    is_weekend  INT CHECK (is_weekend IN (0,1))
);

CREATE TABLE IF NOT EXISTS ecommerce.dim_regions (
    region_id    INT PRIMARY KEY,
    region_name  VARCHAR(50),
    country      VARCHAR(50)
);

-- Fact
CREATE TABLE IF NOT EXISTS ecommerce.fact_sales (
    sale_id      BIGINT PRIMARY KEY,
    customer_id  INT NOT NULL REFERENCES ecommerce.dim_customers(customer_id),
    product_id   INT NOT NULL REFERENCES ecommerce.dim_products(product_id),
    date_id      INT NOT NULL REFERENCES ecommerce.dim_dates(date_id),
    region_id    INT NOT NULL REFERENCES ecommerce.dim_regions(region_id),
    quantity     INT NOT NULL CHECK (quantity > 0),
    unit_price   NUMERIC(12,2) NOT NULL CHECK (unit_price >= 0),
    discount_pct INT NOT NULL DEFAULT 0 CHECK (discount_pct BETWEEN 0 AND 100)
);
