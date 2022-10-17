{{
  config(
    materialized='table'
  )
}}

SELECT
    order_guid
,   user_guid
,   promo_guid
,   address_guid
,   order_created_at_utc
,   order_cost
,   shipping_cost
,   order_total_cost
,   promo_discount
,   product_quantity
,   tracking_id
,   shipping_service
,   estimated_delivery_at_utc
,   delivered_at_utc
,   datediff(d,order_created_at_utc,delivered_at_utc) as days_to_deliver
,   order_status
from {{ ref('int_order_product_promos') }}