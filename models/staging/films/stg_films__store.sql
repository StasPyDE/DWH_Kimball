{{
  config(
    materialized = 'table'
    )
}}

select
    store_id,
    address_id
from
    {{ source('film_src', 'store') }}