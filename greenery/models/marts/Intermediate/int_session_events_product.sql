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
    e.session_guid
    , e.user_guid
    , e.product_guid
    , p.name as product_name
    , min(e.created_at_utc) as first_event_at_utc
    , max(e.created_at_utc) as last_event_at_utc
    , count(*) as total_event_count
    , timestampdiff(minute,first_event_at_utc, last_event_at_utc) as session_duration_minutes
    {% for event_type in event_types %}
    , sum(case when event_type = '{{ event_type }}' then 1 end) as {{ event_type }}_count
    {% endfor %}
  from events e
  left join {{ ref('stg_products') }} p on e.product_guid = p.product_guid
  group by 1,2,3,4
)

select * from final