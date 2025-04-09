{{
  config(
    materialized = 'table'
    )
}}

select
    di.title as film_title,
    sum(amount) as amount
from    
    {{ ref('core_fct_payment') }} fp join
    {{ ref('core_dim_inventory') }} di on fp.inventory_fk = di.inventory_pk
group by di.title