{{
    config(
        materialized = 'view'
        , unique_key = 'promo_guid'
    )
}}

with promos_source as (
    SELECT * FROM {{ source('_postgres__sources', 'promos')}}
)

, renamed_casted as (
    SELECT
        promo_id as promo_guid
        , discount
        , status
    FROM promos_source

)
SELECT * FROM renamed_casted