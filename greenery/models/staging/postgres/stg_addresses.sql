{{
    config(
        materialized = 'view'
        , unique_key = 'address_guid'
    )
}}

with address_source as (
    SELECT * FROM {{ source('_postgres__sources', 'addresses')}}
)

, renamed_casted as (
    SELECT
        ADDRESS_ID as address_guid
        , ADDRESS
        , ZIPCODE
        , STATE
        , COUNTRY
    FROM address_source

)
SELECT * FROM renamed_casted