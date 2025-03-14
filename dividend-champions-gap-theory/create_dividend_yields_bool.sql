SELECT
	Symbol,
	Dividend_Yield,
	CASE
		WHEN Dividend_Yield >= 2 THEN "TRUE"
		ELSE "FALSE"
	END AS Dividend_Bool
	
FROM
	dividend_yields