SELECT
	Symbol,
	CASE 
        WHEN SUM(Has_Increase) = 5 THEN "TRUE" 
        ELSE "FALSE" 
    END AS Increase_Bool
FROM (
	SELECT
		Symbol,
		Increase_Num,
		CASE 
			WHEN During_Close_Percent > 0 
			  OR After_Close_Percent > 0 
			  OR During_High_Percent > 0 
			  OR After_High_Percent > 0 
			THEN 1 
			ELSE 0 
		END AS Has_Increase
	FROM
		prices_aggregated
)
GROUP BY
	Symbol;