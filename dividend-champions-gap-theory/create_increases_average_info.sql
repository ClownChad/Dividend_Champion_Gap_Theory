SELECT
	AVG(Min_During_High) AS Avg_Min_DH,
	AVG(Max_During_High) AS Avg_Max_DH,
	AVG(Avg_During_High) AS Avg_Avg_DH,
	
	AVG(Min_During_Close) AS Avg_Min_DC,
	AVG(Max_During_Close) AS Avg_Max_DC,
	AVG(Avg_During_Close) AS Avg_Avg_DC,
	
	AVG(Min_After_High) AS Avg_Min_AH,
	AVG(Max_After_High) AS Avg_Max_AH,
	AVG(Avg_After_High) AS Avg_Avg_AH,
	
	AVG(Min_After_Close) AS Avg_Min_AC,
	AVG(Max_After_Close) AS Avg_Max_AC,
	AVG(Avg_After_Close) AS Avg_Avg_AC,
	
	AVG(Num_Increases_During_High) AS Avg_Num_Inc_DH,
	AVG(Num_Increases_During_Close) AS Avg_Num_Inc_DC,
	AVG(Num_Increases_After_High) AS Avg_Num_Inc_AH,
	AVG(Num_Increases_After_Close) AS Avg_Num_Inc_AC
FROM
	prices_increases_aggregated;