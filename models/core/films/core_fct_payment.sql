{{
  config(
    materialized = 'table'
  )
}}

with grouped_payments as (
  select
      sum(p.amount)::numeric(7, 2) as amount,
      count(*) as cnt,
      dd.date_dim_pk as payment_date_fk,
      di.inventory_pk as inventory_fk,
      ds.staff_pk as staff_fk,
      p.payment_id
  from
    {{ ref('stg_films__payment') }} p 
    join {{ ref('stg_films__rental') }} r using(rental_id) 
    join {{ ref('core_dim_inventory') }} di using(inventory_id) 
    join {{ ref('core_dim_staff') }} ds on ds.staff_id = p.staff_id
    join {{ ref('core_dim_date') }} dd on p.payment_date::date = dd.date_day
  group by
      dd.date_dim_pk,
      di.inventory_pk,
      ds.staff_pk,
      p.payment_id
)

select
    {{ dbt_utils.generate_surrogate_key(['payment_date_fk', 'inventory_fk', 'staff_fk']) }} as payment_pk,
    payment_id,
    amount,
    cnt,
    payment_date_fk,
    inventory_fk,
    staff_fk
from grouped_payments