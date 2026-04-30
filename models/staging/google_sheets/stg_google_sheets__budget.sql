{{ config(
    materialized='incremental', 
    unique_key='product_id',
    incremental_strategy='append'
    ) 
    }}

with 

source as (

    select * from {{ source('google_sheet', 'budget') }}
    {% if is_incremental() %}

  where _fivetran_synced > (select max(_fivetran_synced) from {{ this }})

{% endif %}
    
),

renamed as (

    select
        _row,
        product_id,
        quantity,
        month,
        _fivetran_synced

    from source

)

select * from renamed

