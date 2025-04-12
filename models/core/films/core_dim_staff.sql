{{
  config(
    materialized = 'incremental',
    incremental_strategy = 'merge',
    unique_key = ['staff_id'],
    on_schema_change = 'fail',
    merge_exclude_columns = ['staff_pk'],
    pre_hook = '
              delete from core.core_dim_staff
              where staff_id in
                    (select staff_id 
                     from staging.stg_films__staff
                     where active = false)
    '
    )
}}

select
    {{ dbt_utils.generate_surrogate_key(['staff_id']) }} as staff_pk,
    stf.staff_id as staff_id,
    stf.first_name as first_name,
    stf.last_name as last_name,
    a.address as address,
    a.district as district,
    c.city as city,
    stf.last_update as last_update
from
    {{ ref('stg_films__staff') }} stf join
    {{ ref('stg_films__store') }} str on stf.store_id = str.store_id join
    {{ ref('stg_films__address') }} a on str.address_id = a.address_id join
    {{ ref('stg_films__city') }} c on c.city_id = a.city_id
{% if is_incremental() %}
where stf.last_update > (select max(last_update) from {{ this }}) and
      stf.active = true
{% endif %}