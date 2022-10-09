{{
    config(
        materialized = 'view'
        , unique_key = 'user_guid'
    )
}}

with users_source as (
    SELECT * FROM {{ source('_postgres__sources', 'users')}}
)

, renamed_casted as (
    SELECT
        USER_ID as user_guid
        , FIRST_NAME
        , LAST_NAME
        , EMAIL
        , PHONE_NUMBER
        , CREATED_AT as created_at_utc
        , UPDATED_AT as updated_at_utc
        , ADDRESS_ID as address_guid  
    FROM users_source

)
SELECT * FROM renamed_casted