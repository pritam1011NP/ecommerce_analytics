
-- 03_indexes.sql
-- Helpful indexes for common queries

CREATE INDEX IF NOT EXISTS ix_sales_date ON ecommerce.fact_sales(date_id);
CREATE INDEX IF NOT EXISTS ix_sales_product ON ecommerce.fact_sales(product_id);
CREATE INDEX IF NOT EXISTS ix_sales_customer ON ecommerce.fact_sales(customer_id);
CREATE INDEX IF NOT EXISTS ix_sales_region ON ecommerce.fact_sales(region_id);

-- Composite index for typical group-bys
CREATE INDEX IF NOT EXISTS ix_sales_prod_date_region ON ecommerce.fact_sales(product_id, date_id, region_id);
