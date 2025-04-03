{{
  config(
    materialized = 'table',
    schema = 'staging'
    )
}}

select
    film_id,
    title,
    'description' as description,
    release_year::int2 as release_year,
    language_id,
    rental_duration,
    rental_rate,
    'length' as length,
    replacement_cost,
    rating::varchar(10) as rating,
    last_update,
    special_features,
    'fulltext' as fulltext
from
    {{ source('film_src', 'film') }}