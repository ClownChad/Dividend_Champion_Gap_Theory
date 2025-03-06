CREATE TEMP TABLE _target_percent(Target_Percent FLOAT);
INSERT INTO _target_percent (Target_Percent) VALUES ("2.0");

SELECT
	Symbol,
	CASE 
		WHEN MAX(
			CASE
				WHEN
					During_High_Increase > (SELECT Target_Percent FROM _target_percent LIMIT 1) OR
					During_Close_Increase > (SELECT Target_Percent FROM _target_percent LIMIT 1) OR
					After_High_Increase > (SELECT Target_Percent FROM _target_percent LIMIT 1) OR
					After_Close_Increase > (SELECT Target_Percent FROM _target_percent LIMIT 1)
				THEN 1 
				ELSE 0
			END
		) = 1
		THEN TRUE
		ELSE FALSE
	END AS Hit_Target_Every_Increase
FROM
	prices_increases
-- WHERE
-- 	Hit_Target_Every_Increase = TRUE
-- GROUP BY
-- 	Symbol
;

DROP TABLE _target_percent;
