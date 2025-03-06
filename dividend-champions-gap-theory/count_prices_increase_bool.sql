SELECT
	COUNT(Increase_Bool) as Num_Of_Increase_Stock
FROM
	prices_increase_bool
WHERE
	Increase_Bool = TRUE
GROUP BY
	Increase_Bool;