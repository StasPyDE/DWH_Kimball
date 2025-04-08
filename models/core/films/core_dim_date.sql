{{
  config(
    materialized = 'table'
    )
}}

{{ dbt_date.get_date_dimension("2007-01-01", "2025-12-31") }}