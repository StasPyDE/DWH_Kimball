{{
  config(
    materialized = 'table'
    )
}}

select
    city_id,
    city
from
    {{ source('film_src', 'city') }}