{{
  config(
    materialized = 'table'
  )
}}

select
    scd.inventory_pk,
    scd.inventory_id,
    scd.film_id,
    scd.title,
    scd.rental_duration,
    scd.rental_rate,
    scd.length,
    scd.rating,
    scd.last_update,
    scd.dbt_valid_from as valid_from,
    coalesce(scd.dbt_valid_to, '9999-12-31'::timestamp) as valid_to
from
    {{ ref('core_dim_inventory_scd2') }} scd
where
    scd.deleted is null