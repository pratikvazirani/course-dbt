{{
    config(
        materialized = 'view'
        , unique_key = 'event_guid'
    )
}}

with events_source as (
    SELECT * FROM {{ source('_postgres__sources', 'events')}}
)

, renamed_casted as (
    SELECT
        EVENT_ID as event_guid
        , SESSION_ID as session_guid
        , USER_ID as user_guid
        , PAGE_URL
        , CREATED_AT as created_at_utc
        , EVENT_TYPE
        , ORDER_ID as order_guid
        , PRODUCT_ID as product_guid
    FROM events_source

)
SELECT * FROM renamed_casted