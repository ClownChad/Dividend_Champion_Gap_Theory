SELECT
	*,
	(During_Close-Before_Open)/Before_Open*100 as During_Close_Percent,
	(After_Close-Before_Open)/Before_Open*100 as After_Close_Percent,
	(During_High-Before_Open)/Before_Open*100 as During_High_Percent,
	(After_High-Before_Open)/Before_Open*100 as After_High_Percent
FROM (
	SELECT
		Before.Symbol,
		Before.Increase_Num,
		Before.Increase_Year,
		Before.Open AS Before_Open,
		During.Close AS During_Close,
		After.Close AS After_Close,
		During.High AS During_High,
		After.High as After_High
	FROM
		prices as Before
	LEFT JOIN prices as During
		ON Before.Symbol = During.Symbol
		AND Before.Increase_Num = During.Increase_Num
		AND During.Timeframe = 'During'
	LEFT JOIN prices as After
		ON Before.Symbol = After.Symbol
		AND Before.Increase_Num = After.Increase_Num
		AND After.Timeframe = 'After'
	WHERE
		Before.Timeframe = 'Before'
);