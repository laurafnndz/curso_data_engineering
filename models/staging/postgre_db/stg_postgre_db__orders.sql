{{ config(
materialized='incremental',
incremental_strategy='microbatch',
event_time='created_at',
begin='2024-01-01',
batch_size='day',
lookback=2
) }}



with 

source as (

    select * from {{ source('postgre_db', 'orders') }}

),

renamed as (

    select
        order_id,
        shipping_service,
        shipping_cost,
        address_id,
        created_at,
        promo_id,
        estimated_delivery_at,
        order_cost,
        user_id,
        order_total,
        delivered_at,
        tracking_id,
        status,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed