{{
  config(
    materialized='view'
  )
}}

{%-
    set event_types = dbt_utils.get_column_values(
        table = ref('stg_events')
        , column = 'event_type'
        , order_by = 'event_type asc'
    )
-%}

with events as (
  select * from {{ ref('stg_events') }}
)

, final as (
  select
    session_guid
    , user_guid
    , min(created_at_utc) as first_event_at_utc
    , max(created_at_utc) as last_event_at_utc
    , count(*) as total_event_count
    , timestampdiff(minute,first_event_at_utc, last_event_at_utc) as session_duration_minutes
    {% for event_type in event_types %}
    , sum(case when event_type = '{{ event_type }}' then 1 end) as {{ event_type }}_count
    {% endfor %}
  from events
  group by 1,2
)

select * from final