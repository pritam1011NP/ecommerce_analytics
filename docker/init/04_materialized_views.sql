
-- 04_materialized_views.sql
-- Pre-aggregations for fast dashboards

CREATE MATERIALIZED VIEW IF NOT EXISTS ecommerce.mv_revenue_by_category_region AS
SELECT
    p.category,
    r.region_name,
    SUM((fs.quantity * fs.unit_price) * (1 - fs.discount_pct/100.0)) AS revenue
FROM ecommerce.fact_sales fs
JOIN ecommerce.dim_products p ON fs.product_id = p.product_id
JOIN ecommerce.dim_regions r ON fs.region_id = r.region_id
GROUP BY p.category, r.region_name;

CREATE MATERIALIZED VIEW IF NOT EXISTS ecommerce.mv_monthly_revenue AS
SELECT
    d.year,
    d.month,
    d.month_name,
    SUM((fs.quantity * fs.unit_price) * (1 - fs.discount_pct/100.0)) AS revenue
FROM ecommerce.fact_sales fs
JOIN ecommerce.dim_dates d ON fs.date_id = d.date_id
GROUP BY d.year, d.month, d.month_name;

-- Refresh helper function (optional)
CREATE OR REPLACE FUNCTION ecommerce.refresh_all_matviews()
RETURNS VOID LANGUAGE plpgsql AS $$
BEGIN
    REFRESH MATERIALIZED VIEW CONCURRENTLY ecommerce.mv_revenue_by_category_region;
    REFRESH MATERIALIZED VIEW CONCURRENTLY ecommerce.mv_monthly_revenue;
EXCEPTION WHEN feature_not_supported THEN
    -- Fallback if table doesn't have unique index for CONCURRENTLY
    REFRESH MATERIALIZED VIEW ecommerce.mv_revenue_by_category_region;
    REFRESH MATERIALIZED VIEW ecommerce.mv_monthly_revenue;
END;
$$;
