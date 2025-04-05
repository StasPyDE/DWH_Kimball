{{
  config(
    materialized = 'table'
    )
}}

select
    {{ dbt_utils.generate_surrogate_key(['inventory_id', 'i.film_id']) }} as inventory_pk,
    i.inventory_id,
    i.film_id,
    f.title,
    f.rental_duration,
    f.rental_rate,
    f.length,
    f.rating
from
    {{ ref('stg_films__inventory') }} i join
    {{ ref('stg_films__film')}} f on i.film_id = f.film_id
