SELECT 
    SK_payment_id,
    amount_corrected,
    payment_method_normalized,
    transaction_status

FROM {{ref('stg_sales_payment')}}