{% snapshot core_dim_inventory_scd2 %}

{{
   config(
       target_database='DWHKimball',
       target_schema='snapshots',
       unique_key='inventory_id',

       strategy='timestamp',
       updated_at='last_update',
       dbt_valid_to_current="CAST('9999-12-31 23:59:59' AS timestamp)"
   )
}}

select
    {{ dbt_utils.generate_surrogate_key(['i.inventory_id', 'i.film_id', 'i.last_update']) }} as inventory_pk,
    i.inventory_id as inventory_id,
    i.film_id as film_id,
    f.title as title,
    f.rental_duration as rental_duration,
    f.rental_rate as rental_rate,
    f.length as length,
    f.rating as rating,
    i.deleted as deleted,
    i.last_update as last_update
from
    {{ ref('stg_films__inventory') }} i join
    {{ ref('stg_films__film')}} f on i.film_id = f.film_id

{% endsnapshot %}