-- models/monitoring/mart_dq_test_results.sql
{{
  config(
    schema = 'dbt_dev',
    materialized = 'view'
  )
}}

with test_results as (
    select
        test_unique_id,
        test_name,
        column_name                                    as column_name,
        model_unique_id,
        split_part(model_unique_id, '.', 3)                as model_name,
        status,
        failures                                            as failure_count,
        detected_at                                        as tested_at,
        invocation_id
    from {{ source('elementary', 'elementary_test_results') }}
),

invocations as (
    select
        invocation_id,
        generated_at,
        row_number() over (order by generated_at desc)     as run_number
    from {{ source('elementary', 'dbt_invocations') }}
),

history as (
    select
        test_unique_id,
        date(detected_at)  as run_date,
        status,
        failures            as failure_count
    from {{ source('elementary', 'elementary_test_results') }}
    where detected_at >= now() - interval '30 days'
)

select
    tr.model_name,
    tr.column_name,
    tr.test_name,
    tr.status,
    tr.failure_count,
    tr.tested_at,
    date(tr.tested_at) as run_date,
    inv.run_number,
    count(case when h.status != 'pass' then 1 end)          as failures_last_30_days,
    max(h.run_date) filter (where h.status != 'pass')       as last_failure_date,
    case tr.status
        when 'error' then 1
        when 'fail'  then 2
        when 'warn'  then 3
        else 4
    end                                                      as status_sort

from test_results tr
left join invocations inv using (invocation_id)
left join history h using (test_unique_id)
group by
    tr.model_name, tr.column_name, tr.test_name,
    tr.status, tr.failure_count, tr.tested_at, inv.run_number