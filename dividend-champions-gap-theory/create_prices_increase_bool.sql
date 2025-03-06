SELECT
	Symbol,
	CASE 
        WHEN SUM(Has_Increase) = 5 THEN TRUE 
        ELSE FALSE 
    END AS Increase_Bool
FROM 
	prices_increases
GROUP BY
	Symbol;