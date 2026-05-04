{{ config(
    materialized='table'
) }}

with

orders as (
    select * from {{ ref('stg_postgre_db__orders') }}
),

addresses as (
    select * from {{ ref('dim_addresses') }}
),

users as (
    select * from {{ ref('dim_user') }}
),

final as (
    select
        -- keys
        orders.order_id,
        orders.user_id,
        orders.address_id,
        orders.promo_id,
        orders.tracking_id,

        -- time dimension
        cast(orders.created_at as timestamp_ntz)  as order_date,
        orders.estimated_delivery_at,
        orders.delivered_at,

        -- shipping
        orders.shipping_service,
        addresses.country                          as address_country,
        addresses.state,
        addresses.zipcode,

        -- status
        orders.status,

        -- amounts
        try_cast(replace(orders.order_cost::string,    ',', '.') as number(18, 2)) as order_cost,
        try_cast(replace(orders.shipping_cost::string, ',', '.') as number(18, 2)) as shipping_cost,
        try_cast(replace(orders.order_total::string,   ',', '.') as number(18, 2)) as order_total

    from orders
    inner join addresses
        on orders.address_id = addresses.address_id
    inner join users
        on orders.user_id = users.user_id
)

select * from final