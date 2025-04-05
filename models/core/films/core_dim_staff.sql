{{
  config(
    materialized = 'table'
    )
}}

select
    {{ dbt_utils.generate_surrogate_key(['staff_id']) }} as staff_pk,
    stf.staff_id,
    stf.first_name,
    stf.last_name,
    a.address,
    a.district,
    c.city
from
    {{ ref('stg_films__staff') }} stf join
    {{ ref('stg_films__store') }} str on stf.store_id = str.store_id join
    {{ ref('stg_films__address') }} a on str.address_id = a.address_id join
    {{ ref('stg_films__city') }} c on c.city_id = a.city_id