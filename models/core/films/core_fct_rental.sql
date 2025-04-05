{{
  config(
    materialized = 'table'
    )
}}

with grouped_query as (
  select
    r.rental_id as rental_id,
    di.inventory_pk as inventory_fk,
    ds.staff_pk as staff_fk,
    r.rental_date::date,
    r.return_date::date,
    count(*) as cnt,
    sum(p.amount)::numeric(7, 2) as amount
  from
    {{ ref('stg_films__rental') }} r join
    {{ ref('stg_films__payment') }} p using(rental_id) join
    {{ ref('core_dim_inventory') }} di on r.inventory_id = di.inventory_id join
    {{ ref('core_dim_staff') }} ds on p.staff_id = ds.staff_id
  group by
    r.rental_id,
    di.inventory_pk,
    ds.staff_pk,
    r.rental_date::date,
    r.return_date::date
)

select
    {{ dbt_utils.generate_surrogate_key(['inventory_fk', 'staff_fk', 'rental_id']) }} as rental_pk,
    rental_id,
    inventory_fk,
    staff_fk,
    rental_date,
    return_date,
    cnt,
    amount
from
    grouped_query
