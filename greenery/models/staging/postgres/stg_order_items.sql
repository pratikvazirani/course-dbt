{{
    config(
        materialized = 'view'
        , unique_key = 'order_guid'
    )
}}

with order_items_source as (
    SELECT * FROM {{ source('_postgres__sources', 'order_items')}}
)

, renamed_casted as (
    SELECT
        order_id as order_guid
        , product_id as product_guid
        , quantity
    FROM order_items_source

)
SELECT * FROM renamed_casted