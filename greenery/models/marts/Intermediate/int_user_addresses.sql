{{
    config(
        materialized = 'view'
        , unique_key = 'user_guid'
    )
}}

with addresses as (
    SELECT * FROM {{ ref('stg_addresses') }}
)

, users as (
    SELECT * FROM {{ ref('stg_users') }}
)

, int_user_addresses as (
    SELECT
        u.user_guid
        , u.FIRST_NAME AS user_first_name
        , u.LAST_NAME AS user_last_name
        , u.EMAIL AS user_email
        , u.PHONE_NUMBER as user_phone_number
        , u.created_at_utc as user_created_at_utc
        , u.updated_at_utc as user_updated_at_utc
        , u.address_guid as user_address_guid  
        , a.address as user_address
        , a.zipcode as user_zipcode
        , a.state as user_state
        , a.country as user_country
    FROM users AS u
    LEFT JOIN addresses AS a 
        on u.address_guid = a.address_guid

)
SELECT * FROM int_user_addresses