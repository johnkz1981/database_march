RENAME TABLE Countries TO countries;
RENAME TABLE Areas TO regions;
RENAME TABLE Cities TO cities;

ALTER TABLE countries RENAME COLUMN Name TO name;

ALTER TABLE regions RENAME COLUMN Name TO name;
ALTER TABLE regions RENAME COLUMN Countries_id TO country_id;
ALTER TABLE cities DROP FOREIGN KEY fk_Cities_Areas1;
ALTER TABLE regions MODIFY COLUMN id INT NOT NULL; 
ALTER TABLE regions DROP PRIMARY KEY;
ALTER TABLE regions ADD CONSTRAINT regions_pk PRIMARY KEY (id);
ALTER TABLE regions RENAME INDEX fk_Areas_Countries_idx TO fk_regions_countries_idx;
ALTER TABLE regions DROP FOREIGN KEY fk_Areas_Countries;
ALTER TABLE regions ADD CONSTRAINT fk_regions_countries
  FOREIGN KEY (country_id)
  REFERENCES countries(id);
  
ALTER TABLE cities
  RENAME COLUMN Name TO name,
  RENAME COLUMN Areas_id TO region_id,
  DROP COLUMN Areas_countries_id;

ALTER TABLE cities MODIFY id INT NOT NULL;
ALTER TABLE cities DROP PRIMARY KEY;
ALTER TABLE cities ADD PRIMARY KEY (id);
ALTER TABLE cities MODIFY id INT NOT NULL AUTO_INCREMENT;
ALTER TABLE regions MODIFY id INT NOT NULL AUTO_INCREMENT;
ALTER TABLE cities RENAME INDEX fk_Cities_Areas1_idx TO fk_cities_regions_idx;

CREATE TABLE districts (
  id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  name VARCHAR(150) NOT NULL,
  region_id INT NOT NULL,
  CONSTRAINT fk_districts_regions
    FOREIGN KEY (region_id)
    REFERENCES regions(id)
    ON DELETE CASCADE
);

ALTER TABLE cities
  ADD COLUMN district_id INT,
  ADD CONSTRAINT fk_cities_districts
  FOREIGN KEY (district_id)
  REFERENCES districts(id);
 
ALTER TABLE cities 
  ADD COLUMN detailed_type ENUM('city', 'village', 'settlement');
