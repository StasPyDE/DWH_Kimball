{{
  config(
    materialized = 'table'
    )
}}

select
    dd.day_of_month || ' ' || dd.month_name || ' ' || dd.year_number as date_title,
    sum(fp.amount) as amount,
    dd.date_dim_pk as date_sort
from
    {{ ref('core_fct_payment') }} fp join 
    {{ ref('core_dim_date') }} dd on fp.payment_date_fk = dd.date_dim_pk
group by
    dd.day_of_month || ' ' || dd.month_name || ' ' || dd.year_number,
    dd.date_dim_pk