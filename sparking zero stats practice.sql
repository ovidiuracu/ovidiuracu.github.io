USE test;
DROP TABLE szstats;

CREATE TABLE szstats (
	id INT AUTO_INCREMENT,
    character_name VARCHAR(100),
    attack_melee INT,
    defense INT,
    ki_blast INT,
    health_bars INT,
    dp_points INT,
    atk_plus_def INT,
    is_huge CHAR(1),
    health_bonus INT,
    overall INT,
    PRIMARY KEY(id)
);

SET sql_mode = "";

LOAD DATA INFILE '\szstats.csv'
INTO TABLE szstats
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

-- Character Rankings:
-- Who are the strongest attackers/defenders?
SELECT character_name, attack_melee
FROM szstats
ORDER BY attack_melee DESC
LIMIT 10;

SELECT character_name, defense
FROM szstats
ORDER BY defense DESC
LIMIT 10;

-- Which characters have the highest overall rating?
SELECT character_name, overall
FROM szstats
ORDER BY overall DESC
LIMIT 10;

-- Who are the most balanced characters (good attack and defense)?
SELECT character_name, attack_melee, defense, atk_plus_def
FROM szstats
ORDER BY atk_plus_def DESC
LIMIT 10;

-- Character Form Analysis:
-- How do different forms of the same character compare? (e.g., different Super Saiyan forms)
SELECT *
FROM szstats
WHERE character_name LIKE '%Goku%';

-- What's the power progression across transformations?
SELECT *, overall - LEAD(overall) OVER (ORDER BY overall DESC) AS power_progression
FROM szstats
WHERE character_name LIKE '%Goku%Super%Sayian%';

-- Statistical Analysis:
-- What's the average attack/defense/ki blast across all characters?
SELECT AVG(attack_melee), AVG(defense), AVG(ki_blast)
FROM szstats;

-- How do huge characters compare to normal-sized ones?
SELECT is_huge,
       COUNT(*) as character_count,
       AVG(attack_melee) as avg_attack,
       AVG(defense) as avg_defense
FROM szstats
WHERE attack_melee >= 0 AND defense >= 0
GROUP BY is_huge;

-- What's the correlation between DP points and overall power?
SELECT dp_points, COUNT(character_name) count, AVG(attack_melee) avg_attack, AVG(defense) avg_defense, AVG(overall) avg_overall
FROM szstats
GROUP BY dp_points
ORDER BY dp_points DESC;

-- Character Type Analysis:
-- How do Saiyans compare to other races?
SELECT character_name LIKE '%Sayian%' race, COUNT(character_name) count, AVG(attack_melee) avg_attack, AVG(defense) avg_defense, AVG(overall) avg_overall
FROM szstats
GROUP BY character_name LIKE '%Sayian%';

-- Balance Analysis:
-- Which characters have the best attack-to-defense ratios?
SELECT character_name, attack_melee, defense, attack_melee/defense atk_def_ratio
FROM szstats
ORDER BY atk_def_ratio DESC;

-- Who has the most extreme stat distributions?
SELECT character_name, attack_melee, defense, attack_melee-defense AS atk_minus_def
FROM szstats
ORDER BY atk_minus_def DESC;

-- Which characters are the most well-rounded?
SELECT character_name,
       (attack_melee + defense + ki_blast) / 3 as average_stats
FROM szstats
WHERE attack_melee > 0 AND defense > 0 AND ki_blast > 0
ORDER BY average_stats DESC;