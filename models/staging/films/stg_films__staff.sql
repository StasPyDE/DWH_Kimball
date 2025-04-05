{{
  config(
    materialized = 'table'
    )
}}

select
    staff_id,
    first_name,
    last_name,
    store_id
from 
    {{ source('film_src', 'staff') }}
