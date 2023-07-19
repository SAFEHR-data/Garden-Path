WITH bp_avg_24 -- CTE for average blood pressure in the last 24 hours 
AS ( SELECT * FROM (
            SELECT
                *,
                row_number () OVER( PARTITION BY csn, horizon_datetime
                    ORDER BY log_datetime DESC) AS row number
            FROM blood_pressure_average_last_24_hours_v1
        ) AS CTE WHERE row_number = 1
),

prediction target -- CTE for discharge timestamp 
AS ( SELECT * FROM (
            SELECT
                *,
                row_number () OVER( PARTITION BY csn, horizon_datetime
                    ORDER BY log_datetime desc) AS row_number
            FROM discharge_v1
        ) AS CTE WHERE row_number = 1

SELECT
         prediction_target.[csn] 
        ,prediction_target.[discharge_datetime]
        ,bp_avg_24.[systolic]
FROM prediction_target
    LEFT JOIN bp_avg_24
    ON      prediction_target.[csn] = bp_avg_24.[csn]
        AND prediction_target.[horizon_datetime] = bp_avg_24.[horizon_datetime]

WHERE prediction_target.[csn] = '1041780975'
ORDER BY prediction_target.[horizon_datetime] DESC