{{
  config(
    materialized = 'table'
    )
}}

select
    address_id,
    address,
    district,
    city_id
from
    {{ source('film_src', 'address') }}