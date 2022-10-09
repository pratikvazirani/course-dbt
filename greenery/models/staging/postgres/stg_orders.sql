{{
    config(
        materialized = 'view'
        , unique_key = 'order_guid'
    )
}}

with orders_source as (
    SELECT * FROM {{ source('_postgres__sources', 'orders')}}
)

, renamed_casted as (
    SELECT
          order_id as order_guid
        , user_id as user_guid
        , promo_id as promo_guid
        , address_id as address_guid
        , created_at as created_at_utc
        , order_cost
        , shipping_cost
        , order_total as order_total_cost
        , tracking_id
        , shipping_service
        , estimated_delivery_at as estimated_delivery_at_utc
        , delivered_at as delivered_at_utc
        , status as order_status
    FROM orders_source

)
SELECT * FROM renamed_casted