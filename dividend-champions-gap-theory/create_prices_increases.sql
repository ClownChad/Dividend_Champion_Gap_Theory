SELECT
	BOOLS.Symbol,
	INCREASES.Increase_Num,
	INCREASES.During_High_Increase,
	INCREASES.During_Close_Increase,
	INCREASES.After_High_Increase,
	INCREASES.After_Close_Increase
FROM
	prices_increase_bool AS BOOLS
LEFT JOIN (
	SELECT
		Symbol,
		Increase_Num,
		
		CASE
			WHEN During_High_Percent > 0
			THEN During_High_Percent
			ELSE NULL
		END AS During_High_Increase,
		
		CASE
			WHEN During_Close_Percent > 0
			THEN During_Close_Percent
			ELSE NULL
		END AS During_Close_Increase,
		
		CASE
			WHEN After_High_Percent > 0
			THEN After_High_Percent
			ELSE NULL
		END AS After_High_Increase,
		
		CASE
			WHEN After_Close_Percent > 0
			THEN After_Close_Percent
			ELSE NULL
		END AS After_Close_Increase,
		
		CASE 
			WHEN During_Close_Percent > 0 OR 
				 After_Close_Percent > 0 OR 
				 During_High_Percent > 0 OR 
				 After_High_Percent > 0 
			THEN 1 
			ELSE 0 
		END AS Has_Increase
	FROM
		prices_aggregated
	GROUP BY
		Symbol,
		Increase_Num
) AS INCREASES
	ON BOOLS.Symbol = INCREASES.Symbol
WHERE
	BOOLS.Increase_Bool = TRUE;
