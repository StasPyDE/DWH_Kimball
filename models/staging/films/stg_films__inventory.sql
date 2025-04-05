{{
  config(
    materialized = 'table'
    )
}}

select
    inventory_id,
    film_id,
    store_id
from
    {{ source('film_src', 'inventory') }}