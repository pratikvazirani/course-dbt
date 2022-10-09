{{
    config(
        materialized = 'view'
        , unique_key = 'product_guid'
    )
}}

with products_source as (
    SELECT * FROM {{ source('_postgres__sources', 'products')}}
)

, renamed_casted as (
    SELECT
        PRODUCT_ID as product_guid
        , NAME
        , PRICE
        , INVENTORY
    FROM products_source

)
SELECT * FROM renamed_casted