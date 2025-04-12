{{
  config(
    materialized = 'incremental',
    incremental_strategy = 'merge',
    unique_key = ['staff_id'],
    on_schema_change = 'fail'
    )
}}

select
    staff_id,
    first_name,
    last_name,
    store_id,
    last_update,
    active
from 
    {{ source('film_src', 'staff') }}

{% if is_incremental() %}
where last_update > (select last_update from {{ this }} order by last_update desc limit 1)
{% endif %}

