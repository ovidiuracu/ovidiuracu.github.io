USE test;
DROP TABLE pokemon;

CREATE TABLE pokemon (
  pokedex_number BIGINT,
  name VARCHAR(1024),
  type1 VARCHAR(1024),
  type2 VARCHAR(1024) NULL,
  classfication VARCHAR(1024),
  abilities VARCHAR(1024),
  against_bug DOUBLE,
  against_dark DOUBLE,
  against_dragon DOUBLE,
  against_electric DOUBLE,
  against_fairy DOUBLE,
  against_fight DOUBLE,
  against_fire DOUBLE,
  against_flying DOUBLE,
  against_ghost DOUBLE,
  against_grass DOUBLE,
  against_ground DOUBLE,
  against_ice DOUBLE,
  against_normal DOUBLE,
  against_poison DOUBLE,
  against_psychic DOUBLE,
  against_rock DOUBLE,
  against_steel DOUBLE,
  against_water DOUBLE,
  base_egg_steps BIGINT,
  base_happiness BIGINT,
  capture_rate VARCHAR(1024),
  experience_growth BIGINT,
  height_m DOUBLE NULL,
  weight_kg DOUBLE NULL,
  percentage_male DOUBLE NULL,
  hp BIGINT,
  attack BIGINT,
  sp_attack BIGINT,
  defense BIGINT,
  sp_defense BIGINT,
  speed BIGINT,
  base_total BIGINT,
  generation BIGINT,
  is_legendary BIGINT,
  PRIMARY KEY (pokedex_number)
);

SET sql_mode = "";

LOAD DATA INFILE '\pokemon.csv'
INTO TABLE pokemon
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

-- Which Pokemon have the highest base total stats?
SELECT name, base_total
FROM pokemon
ORDER BY base_total DESC
LIMIT 10;

-- What is the average base total of Pokemon by type?
SELECT type1, AVG(base_total) AS average_base_total
FROM pokemon
GROUP BY type1
ORDER BY AVG(base_total) DESC;

SELECT name, base_total
FROM pokemon
WHERE is_legendary = 0
ORDER BY base_total DESC;

-- What is the distribution of Pokemon across generations?
SELECT generation, COUNT(name), 
	ROUND(COUNT(name) / (SELECT COUNT(name) FROM pokemon) * 100, 2) AS percentage
FROM pokemon
GROUP BY generation;

-- What are the tallest and heaviest Pokemon?
SELECT name, height_m
FROM pokemon
ORDER BY height_m DESC;

SELECT name, weight_kg
FROM pokemon
ORDER BY weight_kg DESC;

-- What percentage of Pokemon are classified as legendary by generation?
SELECT generation, COUNT(name) AS distribution, 
	ROUND(COUNT(name) / (SELECT COUNT(name) FROM pokemon WHERE is_legendary = 1)*100, 2) AS percentage
FROM pokemon
WHERE is_legendary = 1
GROUP BY generation;

SELECT generation, COUNT(name) AS total_pokemon, 
	COUNT(IF(is_legendary = 1, 1, NULL)) AS legendary_count, 
    ROUND(COUNT(IF(is_legendary = 1, 1, NULL))/COUNT(name)*100, 2) AS percentage
FROM pokemon
GROUP BY generation;

-- Which abilities are the most common among Pokemon?
SELECT abilities, COUNT(name) AS occurrence
FROM pokemon
GROUP BY abilities
ORDER BY occurrence DESC;

-- Number of pokemon for each type combination
SELECT COUNT(name) AS count, type1, type2
FROM pokemon
GROUP BY type1, type2
ORDER BY COUNT(name) DESC;

SELECT COUNT(name), type1
FROM pokemon
WHERE type2 = ''
GROUP BY type1
ORDER BY COUNT(name) DESC;

-- Which generation has the most powerful pokemon
SELECT generation, COUNT(name) AS distribution
FROM pokemon
WHERE base_total >= 500
GROUP BY generation
ORDER BY COUNT(name) DESC;

-- Top 5 Pokemon with the highest attack stat in each generation
CREATE VIEW highestattack AS
	SELECT generation, name, attack,
	RANK() OVER (PARTITION BY generation ORDER BY attack DESC) AS ranking
FROM pokemon;

SELECT * FROM highestattack
WHERE ranking <= 5;

-- Top 5 Pokemon with the higehst speed stat in each generation
CREATE VIEW highestspeed AS
	SELECT generation, name, speed,
	RANK() OVER (PARTITION BY generation ORDER BY attack DESC) AS ranking
FROM pokemon;

SELECT * FROM highestspeed
WHERE ranking <= 5;

-- Find the average base stat of Pokemon by generation
SELECT generation, AVG(base_total) AS avg_base_stat 
FROM pokemon 
GROUP BY generation;

-- List Pokemon that have the ability 'Chlorophyll'
SELECT name, abilities
FROM pokemon
WHERE abilities LIKE '%Chlorophyll%';

-- Gender distribution
SELECT name, percentage_male
FROM pokemon
WHERE percentage_male > 75;

SELECT COUNT(name) AS distribution, percentage_male
FROM pokemon
GROUP BY percentage_male
ORDER BY percentage_male DESC;