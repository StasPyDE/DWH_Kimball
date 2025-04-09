{{
  config(
    materialized = 'table'
    )
}}

select
    {{ dbt_utils.generate_surrogate_key(['inventory_id', 'i.film_id']) }} as inventory_pk,
    i.inventory_id as inventory_id,
    i.film_id as film_id,
    f.title as title,
    f.rental_duration as rental_duration,
    f.rental_rate as rental_rate,
    f.length as length,
    f.rating as rating
from
    {{ ref('stg_films__inventory') }} i join
    {{ ref('stg_films__film')}} f on i.film_id = f.film_id
