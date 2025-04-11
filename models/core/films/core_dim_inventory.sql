{{
  config(
    materialized = 'incremental',
    incremental_strategy = 'merge',
    unique_key = ['inventory_id'],
    on_schema_change = 'fail',
    merge_exclude_columns = ['inventory_pk'],
    pre_hook = '
        delete from core.core_dim_inventory
        where inventory_id in (
            select inventory_id from staging.stg_films__inventory
            where deleted is not null
        )
    '
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
    f.rating as rating,
    i.last_update as last_update
from
    {{ ref('stg_films__inventory') }} i join
    {{ ref('stg_films__film')}} f on i.film_id = f.film_id
{% if is_incremental() %}
where i.last_update > (select max(last_update) from {{ this }}) and
      i.deleted is null
{% endif %}
