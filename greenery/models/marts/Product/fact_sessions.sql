{{
  config(
    materialized='table'
  )
}}

select 
    session_guid
,   user_guid
,   min(order_guid) as order_guid
,   min(created_at_utc) as session_started_at
,   max(created_at_utc) as session_ended_at
from {{ ref('stg_events') }}
group by 1,2