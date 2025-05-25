-- Active: 1747511255420@@127.0.0.1@5432@assignment_2
CREATE TABLE rangers(
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    region VARCHAR(50) NOT NULL
);

CREATE TABLE species(
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(50) NOT NULL,
    scientific_name VARCHAR(50) NOT NULL,
    discovery_date DATE NOT NULL,
    conservation_status VARCHAR(20) NOT NULL
)

CREATE TABLE sightings(
    sighting_id SERIAL PRIMARY KEY,
    ranger_id INTEGER REFERENCES rangers(ranger_id) ON DELETE CASCADE,
    species_id INTEGER REFERENCES species(species_id) ON DELETE CASCADE,
    sighting_time TIMESTAMP NOT NULL,
    location VARCHAR(30) NOT NULL,
    notes TEXT
)

--Insert data to rangers table
INSERT INTO rangers (name,region) VALUES 
    ('Alice Green','Northern Hills'),
    ('Bob White','River Delta '),
    ('Carol King','Mountain Range');


----Insert data to species table
INSERT INTO species (common_name,scientific_name,discovery_date,conservation_status) VALUES 
    ('Snow Leopard','Panthera uncia ','1775-01-01','Endangered'),
    ('Bengal Tiger','Panthera tigris tigris','1758-01-01','Endangered'),
    ('Red Panda','Ailurus fulgens','1825-01-01','Vulnerable'),
    ('Asiatic Elephant','Elephas maximus indicus','1758-01-01','Endangered');

----Insert data to sightings table
INSERT INTO sightings (ranger_id,species_id,location,sighting_time,notes) VALUES
    (1,1,'Peak Ridge','2024-05-10 07:45:00','Camera trap image captured'),
    (2,2,'Bankwood Area','2024-05-12 16:20:00','Juvenile seen'),
    (3,3,'Bamboo Grove East','2024-05-15 09:10:00','Feeding observed'),
    (1,2,'Snowfall Pass','2024-05-18 18:30:00',NULL);


-- Problem 1: Register a new ranger with provided data with name = 'Derek Fox' and region = 'Coastal Plains'
INSERT INTO rangers (name,region) VALUES ('Derek Fox','Coastal Plains');


-- Problem 2: Count unique species ever sighted.
SELECT count(DISTINCT species_id) as unique_species_count from sightings;


-- Problem 3: Find all sightings where the location includes "Pass".
SELECT * FROM sightings WHERE location ILIKE '%Pass%';


-- Problem 4: List each ranger's name and their total number of sightings.
SELECT name,count(*) as total_sightings from rangers JOIN sightings USING(ranger_id) GROUP BY NAME;


-- Problem 5: List species that have never been sighted.
select common_name FROM species 
    WHERE species_id NOT IN (
        SELECT species_id FROM sightings);


-- Problem 6: Show the most recent 2 sightings.
SELECT common_name,sighting_time,name FROM species 
    JOIN sightings USING(species_id) 
    JOIN rangers USING(ranger_id) 
    ORDER BY sighting_time DESC LIMIT 2;


-- Problem 7: Update all species discovered before year 1800 to have status 'Historic'.
UPDATE species
    SET conservation_status='Historic'
    WHERE extract(year from discovery_date) < 1800;


-- Problem 8: Label each sighting's time of day as 'Morning', 'Afternoon', or 'Evening'.
CREATE or REPLACE FUNCTION time_of_day(p_timestamp TIMESTAMP)
RETURNS TEXT
LANGUAGE SQL
AS
$$
    SELECT CASE
        WHEN p_timestamp::time < '12:00 PM' THEN 'Morning'
        WHEN p_timestamp::time BETWEEN '12:00 PM' and '5:00 PM' THEN 'Afternoon'
        when p_timestamp::time > '5:00 PM' then 'Evening'
    END;
$$;

SELECT sighting_id, time_of_day(sighting_time) from sightings;


-- Problem 9: Delete rangers who have never sighted any species
DELETE from rangers
    WHERE NOT EXISTS (
        SELECT * from sightings 
         WHERE rangers.ranger_id=ranger_id);


