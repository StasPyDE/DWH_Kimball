{{
  config(
    materialized = 'incremental',
    incremental_strategy = 'merge',
    unique_key = ['inventory_id'],
    on_schema_change = 'fail'
    )
}}

{% if is_incremental() %}
with max_update as (
    select max(last_update) as max_last_update from {{ this }}
)
{% endif %}


select
    inventory_id,
    film_id,
    store_id,
    last_update,
    deleted
from
    {{ source('film_src', 'inventory') }}

{% if is_incremental() %}
where last_update > (select max_last_update from max_update) or
      (deleted is not null and (inventory_id in (select inventory_id from {{ this }} where deleted is null)))
{% endif %}