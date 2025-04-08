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
    dd1.date_dim_pk as rental_date_fk,
    dd2.date_dim_pk as return_date_fk,
    count(*) as cnt,
    sum(p.amount)::numeric(7, 2) as amount
  from
    {{ ref('stg_films__rental') }} r left join
    {{ ref('stg_films__payment') }} p using(rental_id) join
    {{ ref('core_dim_inventory') }} di on r.inventory_id = di.inventory_id join
    {{ ref('core_dim_staff') }} ds on p.staff_id = ds.staff_id join
    {{ ref('core_dim_date') }} dd1 on r.rental_date::date = dd1.date_day left join
    {{ ref('core_dim_date') }} dd2 on r.return_date::date = dd2.date_day
  group by
    r.rental_id,
    di.inventory_pk,
    ds.staff_pk,
    dd1.date_dim_pk,
    dd2.date_dim_pk
)

select
    {{ dbt_utils.generate_surrogate_key(['inventory_fk', 'staff_fk', 'rental_id']) }} as rental_pk,
    rental_id,
    inventory_fk,
    staff_fk,
    rental_date_fk,
    return_date_fk,
    cnt,
    amount
from
    grouped_query
