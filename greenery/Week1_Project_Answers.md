1. How many users do we have?
Answer: We have 130 users
Query:
SELECT COUNT (USER_GUID) FROM DEV_DB.DBT_PRATIKVAZIRANI.STG_USERS

2. On average, how many orders do we receive per hour?
Answer: 7.52 Orders per hour
Query:
with
orders_per_hour as (
    select 
        date_trunc('HOUR', created_at_utc) as created_at_hour_utc,
        count(order_guid) as order_count 
    from DEV_DB.DBT_PRATIKVAZIRANI.STG_ORDERS
    group by 1
)
select 
avg(order_count)
from orders_per_hour

3. On average, how long does an order take from being placed to being delivered?
Answer: 3.89 days
Query: SELECT AVG(TIMEDIFF('days',created_at_utc,delivered_at_utc)) AS TIME_TAKEN_TO_DELIVER FROM DEV_DB.DBT_PRATIKVAZIRANI.STG_ORDERS

4. How many users have only made one purchase? Two purchases? Three+ purchases?
Answer: 1 Order - 25, 2 Orders - 28, 3+ orders - 71
Query: 
WITH CTE_ORDER_COUNT_PER_USER AS (
SELECT USER_GUID, COUNT(ORDER_GUID) AS ORDER_COUNT 
FROM DEV_DB.DBT_PRATIKVAZIRANI.STG_ORDERS
GROUP BY 1
)

SELECT 
    CASE WHEN ORDER_COUNT>=3 THEN 3 ELSE ORDER_COUNT END AS ORDER_COUNT
    , COUNT(USER_GUID) AS NUMBER_OF_USERS
FROM CTE_ORDER_COUNT_PER_USER
GROUP BY 1
ORDER BY 1

5. On average, how many unique sessions do we have per hour?
Answer: 12.017
Query:
with
sessions_per_hour as (
    select 
        date_trunc('HOUR', created_at_utc) as created_at_hour_utc,
        count(DISTINCT user_guid) as user_session_count 
    from DEV_DB.DBT_PRATIKVAZIRANI.STG_EVENTS
    group by 1
)
select 
avg(user_session_count) as sessions_per_hour
from sessions_per_hour