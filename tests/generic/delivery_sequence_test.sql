{% test flag_is_false(model, column_name) %}

    select order_id from {{ model }}
    where {{ column_name }} = True

{% endtest %}