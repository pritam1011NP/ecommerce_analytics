
#!/usr/bin/env bash
set -e
docker exec -i ecommerce_pg psql -U postgres -d postgres -f /data/../sql/05_analytics.sql
