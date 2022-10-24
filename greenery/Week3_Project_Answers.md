Part 1:

1. What is the overall conversion rate?
- 62.45%
- Query: SELECT SUM(checkout_count)/COUNT(session_guid) as conversion_rate FROM DEV_DB.DBT_PRATIKVAZIRANI.INT_SESSION_EVENTS_AGG

2. What is our conversion rate by product?
- Query:
WITH 
checkout_views AS (
SELECT product_guid, product_name, COUNT(DISTINCT session_guid) as checkout_views
FROM DEV_DB.DBT_PRATIKVAZIRANI.INT_SESSION_EVENTS_PRODUCT
WHERE session_guid IN (SELECT distinct session_guid FROM DEV_DB.DBT_PRATIKVAZIRANI.INT_SESSION_EVENTS_PRODUCT WHERE CHECKOUT_COUNT IS NOT NULL)
AND product_guid is not NULL
GROUP BY 1,2
)

, total_views AS (
SELECT product_guid, product_name, COUNT(DISTINCT session_guid) as total_views
FROM DEV_DB.DBT_PRATIKVAZIRANI.INT_SESSION_EVENTS_PRODUCT
WHERE product_guid is not null
GROUP BY 1,2
)

SELECT t.product_guid, t.product_name, t.total_views, c.checkout_views, c.checkout_views/t.total_views as conversion_rate
FROM total_views t
LEFT JOIN checkout_views c ON t.product_guid = c.product_guid

Part 2:

1. Create a macro
- Used a dbt_utils macro in the models int_session_events_agg and int_session_events_product to pivot the data by event type
- Create a macro to grant permissions

Part 3:

1. Add a post hook to your project to apply grants to the role “reporting”
- Added a post hook in the dbt_project.yml


Part 4:

1. Apply macro or tests
- Used the dbt_utils macro in the model nt_session_events_agg and int_session_events_product to pivot the data by event type
- Adding tests for positive_values, not_null, unique on columns


Part 5:

1. Which orders changed from Week 2 to 3  using dbt snapshot?
- 8385cfcd-2b3f-443a-a676-9756f7eb5404
- e24985f3-2fb3-456e-a1aa-aaf88f490d70
- 5741e351-3124-4de7-9dff-01a448e7dfd4
