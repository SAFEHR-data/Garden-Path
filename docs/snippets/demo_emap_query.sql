WITH 

 bp AS (
	SELECT
	 hospital_visit_id
	,observation_datetime
	,value_as_text
	FROM star.visit_observation vo
	LEFT JOIN star.visit_observation_type ot 
        ON vo.visit_observation_type_id = ot.visit_observation_type_id 
	WHERE ot.id_in_application = '5'
	AND observation_datetime > NOW() - INTERVAL '60 Days'
)

,prediction_target AS (
	SELECT
	 hospital_visit_id
	,encounter AS CSN
	,discharge_datetime
	FROM star.hospital_visit 
	WHERE encounter = '1041780975'
)

SELECT 
	 prediction_target.csn
	,bp.observation_datetime
	,prediction_target.discharge_datetime
	,bp.value_as_text
FROM prediction_target
LEFT JOIN bp ON prediction_target.hospital_visit_id = bp.hospital_visit_id
ORDER BY bp.observation_datetime DESC
;
