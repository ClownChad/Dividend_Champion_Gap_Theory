SELECT 
    Symbol,
    MIN(During_High_Increase) AS Min_During_High,
    MAX(During_High_Increase) AS Max_During_High,
    AVG(During_High_Increase) AS Avg_During_High,
    
    MIN(During_Close_Increase) AS Min_During_Close,
    MAX(During_Close_Increase) AS Max_During_Close,
    AVG(During_Close_Increase) AS Avg_During_Close,
    
    MIN(After_High_Increase) AS Min_After_High,
    MAX(After_High_Increase) AS Max_After_High,
    AVG(After_High_Increase) AS Avg_After_High,
    
    MIN(After_Close_Increase) AS Min_After_Close,
    MAX(After_Close_Increase) AS Max_After_Close,
    AVG(After_Close_Increase) AS Avg_After_Close,

    COUNT(CASE WHEN During_High_Increase > 0 THEN 1 END) AS Num_Increases_During_High,
    COUNT(CASE WHEN During_Close_Increase > 0 THEN 1 END) AS Num_Increases_During_Close,
    COUNT(CASE WHEN After_High_Increase > 0 THEN 1 END) AS Num_Increases_After_High,
    COUNT(CASE WHEN After_Close_Increase > 0 THEN 1 END) AS Num_Increases_After_Close,

    COUNT(CASE WHEN During_High_Increase > 0 THEN 1 END) * 1.0 / COUNT(*) AS Consistency_During_High,
    COUNT(CASE WHEN During_Close_Increase > 0 THEN 1 END) * 1.0 / COUNT(*) AS Consistency_During_Close,
    COUNT(CASE WHEN After_High_Increase > 0 THEN 1 END) * 1.0 / COUNT(*) AS Consistency_After_High,
    COUNT(CASE WHEN After_Close_Increase > 0 THEN 1 END) * 1.0 / COUNT(*) AS Consistency_After_Close
FROM 
	prices_increases
GROUP BY 
	Symbol;
