Part 1: Models
1. What is our repeat user rate?
Answer: 
Our Repeat Rate is 79.83% based on the definition that Repeat Rate = Users who purchase 2 or more times / users who purchased
Query: 
WITH USER_PURCHASES AS (
SELECT  USER_GUID
        , CASE WHEN COUNT_OF_ORDERS = 1 THEN 'has_one_purchase' ELSE 'has_two_or_more_purchases' END AS ORDER_CATEGORY
FROM 
    
    (SELECT USER_GUID
            , COUNT(ORDER_GUID) AS COUNT_OF_ORDERS
    FROM DEV_DB.DBT_PRATIKVAZIRANI.STG_ORDERS
    GROUP BY 1
    )

)

SELECT div0(SUM(CASE WHEN ORDER_CATEGORY = 'has_two_or_more_purchases' THEN 1 ELSE 0 END), COUNT(USER_GUID)) AS REPEAT_RATE
FROM USER_PURCHASES

2. What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?

Answer:
- Age group of the user
- How promo codes affect the repeat rate. If the repeat order was on a day when there was a new promo launched.
- What was the satisfaction rating given by the customer on their previous order. Hence, an additional column of rating/comments in the orders_table would be helpful.

3. Explain the marts models you added.
Answer:
I created a common intermediate folder to store all the intermediate models.
For the model ‘int_order_product_promos’, I am taking the stg_orders as my base table and mapping the discount associated with the promo_guid from the stg_promos table. I am also adding the quantity of items ordered in every order from the stg_order_items table.

For the model ‘int_user_addresses’, I mapped the information from the table ‘stg_addresses’ into ‘stg_users’ based on the column address_guid.

Core:
I have created a ‘dim_products’ model, where we have detailed information about the product from the table stg_products and also the number of times the product was ordered by joining it on stg_order_items. We are also getting the date when the product was last ordered from the intermediate model ‘int_order_product_promos’.

I have created a ‘fact_orders’ model, where we have information from the intermediate model ‘int_order_product_promos’ and have added the column ‘days_to_deliver’ in it.

Marketing:
I have created a model ‘user_order_facts’, where we have summarized order information of every users from the model ‘fact_orders’ in the core folder.

Product: 
I have created models ‘fact_page_views’ and ‘fact_events’ from the table ‘stg_events’. 

Part 2: Tests

Added a test ‘positive_values.sql” to make sure certain columns can never have negative values.

Part 3: dbt Snapshots

The following orders changed from week 1 to 2:
05202733-0e17-4726-97c2-0520c024ab85, 939767ac-357a-4bec-91f8-a7b25edd46c9, 914b8929-e04a-40f8-86ee-357f2be3a2a2