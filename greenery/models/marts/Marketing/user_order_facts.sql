{{
  config(
    materialized='table'
  )
}}

SELECT
    user_guid
,   count(order_guid) as lifetime_order_count
,   sum(order_cost) as lifetime_spend_exc_shipping
,   sum(order_total_cost) as lifetime_spend_inc_shipping
,   sum(product_quantity) as lifetime_items_purchased
,   max(order_created_at_utc) as latest_order_at
,   min(order_created_at_utc) as earliest_order_at  
from {{ ref('fact_orders') }}
group by 1