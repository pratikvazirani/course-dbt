{{
  config(
    materialized='table'
  )
}}

SELECT
    event_guid
,   created_at_utc as page_view_created_at
,   session_guid
,   user_guid
,   page_url
,   product_guid
from {{ ref('stg_events') }}
where event_type = 'page_view'