{{
  config(
    materialized='view'
  )
}}

with products_orders as (
    select
        order_guid
    ,   sum(quantity) as product_quantity
    from {{ ref('stg_order_items') }}
    group by 1
)

SELECT
    o.order_guid
,   o.user_guid
,   o.promo_guid
,   o.address_guid
,   o.created_at_utc as order_created_at_utc
,   o.order_cost
,   o.shipping_cost
,   o.order_total_cost
,   coalesce(p.discount,0) as promo_discount
,   po.product_quantity
,   o.tracking_id
,   o.shipping_service
,   o.estimated_delivery_at_utc
,   o.delivered_at_utc
,   o.order_status
from {{ ref('stg_orders') }} o
left join {{ ref('stg_promos') }} p
    on o.promo_guid = p.promo_guid
left join products_orders po
    on o.order_guid = po.order_guid