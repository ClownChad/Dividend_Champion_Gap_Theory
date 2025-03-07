-- CREATE TEMP TABLE _target_percent(Target_Percent FLOAT);
-- INSERT INTO _target_percent (Target_Percent) VALUES ("1.1");

SELECT
	Symbol,
	CASE
		WHEN SUM(
			CASE
				WHEN
					During_High_Increase > "1.1" OR
					During_Close_Increase > "1.1" OR
					After_High_Increase > "1.1" OR
					After_Close_Increase > "1.1"
-- 					During_High_Increase > (SELECT Target_Percent FROM _target_percent LIMIT 1) OR
-- 					During_Close_Increase > (SELECT Target_Percent FROM _target_percent LIMIT 1) OR
-- 					After_High_Increase > (SELECT Target_Percent FROM _target_percent LIMIT 1) OR
-- 					After_Close_Increase > (SELECT Target_Percent FROM _target_percent LIMIT 1)
				THEN 1 
				ELSE 0
			END
		) = 5
		THEN TRUE
		ELSE FALSE
	END AS Hit_Target_Every_Increase
FROM
	prices_increases
GROUP BY
	Symbol;

-- DROP TABLE _target_percent;
