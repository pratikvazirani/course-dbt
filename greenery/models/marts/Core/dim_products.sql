{{
  config(
    materialized='table'
  )
}}

SELECT
    p.product_guid
,   p.name as product_name
,   p.price as product_price
,   p.inventory as quantity_available
,   count(distinct oi.order_guid) as distinct_orders
,   max(op.order_created_at_utc) as latest_order_at
from {{ ref('stg_products') }} p
left join {{ ref('stg_order_items')}} oi
    on p.product_guid = oi.product_guid
left join {{ ref('int_order_product_promos')}} op
    on oi.order_guid = op.order_guid
group by 1,2,3,4