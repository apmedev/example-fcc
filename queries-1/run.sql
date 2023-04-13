CREATE DATABASE universe;
\c universe;

CREATE TABLE galaxy (
  galaxy_id SERIAL PRIMARY KEY,
  name VARCHAR NOT NULL UNIQUE,
  age INT,
  size NUMERIC(10,2),
  has_life BOOLEAN NOT NULL,
  shape TEXT
);

CREATE TABLE star (
  star_id SERIAL PRIMARY KEY,
  name VARCHAR NOT NULL UNIQUE,
  type VARCHAR NOT NULL,
  mass INT,
  temperature INT,
  has_planets BOOLEAN NOT NULL,
  galaxy_id INT REFERENCES galaxy(galaxy_id)
);

CREATE TABLE planet (
  planet_id SERIAL PRIMARY KEY,
  name VARCHAR NOT NULL UNIQUE,
  type VARCHAR NOT NULL,
  size NUMERIC(10,2),
  habitable BOOLEAN NOT NULL,
  star_id INT REFERENCES star(star_id)
);

CREATE TABLE moon (
  moon_id SERIAL PRIMARY KEY,
  name VARCHAR NOT NULL UNIQUE,
  distance_from_planet NUMERIC(10,2),
  is_satellite BOOLEAN NOT NULL,
  planet_id INT REFERENCES planet(planet_id),
  size INT
);

CREATE TABLE comet (
  comet_id SERIAL PRIMARY KEY,
  name VARCHAR NOT NULL UNIQUE,
  type VARCHAR NOT NULL,
  orbit_period NUMERIC(10,2),
  has_tail BOOLEAN NOT NULL,
  galaxy_id INT REFERENCES galaxy(galaxy_id)
);

INSERT INTO galaxy (name, age, size, has_life, shape) VALUES 
  ('Milky Way', 13000, 100000, FALSE, 'Spiral'),
  ('Andromeda', 11000, 140000, FALSE, 'Spiral'),
  ('Whirlpool', 15000, 50000, FALSE, 'Spiral'),
  ('Sombrero', 28000, 35000, FALSE, 'Lenticular'),
  ('Pinwheel', 20000, 52000, FALSE, 'Spiral'),
  ('Cigar', 4000, 12000, FALSE, 'Irregular');

INSERT INTO star (name, type, mass, temperature, has_planets, galaxy_id) VALUES 
  ('Sun', 'G', 1, 5778, TRUE, 1),
  ('Betelgeuse', 'M', 15, 3600, FALSE, 1),
  ('Vega', 'A', 2, 9600, TRUE, 1),
  ('Proxima Centauri', 'M', 0.12, 3042, TRUE, 1),
  ('Sirius', 'A', 2.02, 9940, TRUE, 1),
  ('Alpha Centauri A', 'G', 1.1, 5790, TRUE, 1),
  ('Alpha Centauri B', 'K', 0.907, 5260, TRUE, 1),
  ('Antares', 'M', 18, 3400, FALSE, 2),
  ('Bellatrix', 'B', 8.6, 22000, FALSE, 2),
  ('Pollux', 'K', 1.8, 4750, TRUE, 2),
  ('Arcturus', 'K', 1.1, 4286, TRUE, 2),
  ('Aldebaran', 'K', 1.7, 3910, TRUE, 2);

INSERT INTO planet (name, type, size, habitable, star_id) VALUES 
  ('Mercury', 'Terrestrial', 0.055, FALSE, 1),
  ('Ddd', 'Terrestrial', 0.055, FALSE, 1),
  ('FF', 'Terrestrial', 0.055, FALSE, 1),
  ('dde', 'Terrestrial', 0.055, FALSE, 1),
  ('zz', 'Terrestrial', 0.055, FALSE, 1),
  ('sda', 'Terrestrial', 0.055, FALSE, 1),
  ('xzc', 'Terrestrial', 0.055, FALSE, 1),
  ('qqq', 'Terrestrial', 0.055, FALSE, 1),
  ('ttt', 'Terrestrial', 0.055, FALSE, 1),
  ('hhhh', 'Terrestrial', 0.055, FALSE, 1),
  ('ththt', 'Terrestrial', 0.055, FALSE, 1),
  ('Venus', 'Terrestrial', 0.815, FALSE, 1);


  INSERT INTO moon (name, distance_from_planet, is_satellite, planet_id, size) VALUES 
  ('TTT', '4', TRUE, 5, 3),
  ('sad', '4', TRUE, 5, 3),
  ('eqw', '4', TRUE, 5, 3),
  ('fdgf', '4', TRUE, 5, 3),
  ('hjk', '4', TRUE, 5, 3),
  ('656', '4', TRUE, 5, 3),
  ('wwer', '4', TRUE, 5, 3),
  ('88', '4', TRUE, 5, 3),
  ('324', '4', TRUE, 5, 3),
  ('lioo', '4', TRUE, 5, 3),
  ('cvb', '4', TRUE, 5, 3),
  ('2343d', '4', TRUE, 5, 3),
  ('TdddTT', '4', TRUE, 5, 3),
  ('TThhT', '4', TRUE, 5, 3),
  ('TTyyyT', '4', TRUE, 5, 3),
  ('TT555T', '4', TRUE, 5, 3),
  ('TT88T', '4', TRUE, 5, 3),
  ('TTjkjjT', '4', TRUE, 5, 3),
  ('TTnmnT', '4', TRUE, 5, 3),
  ('TT5454T', '4', TRUE, 5, 3);
  


  INSERT INTO comet (name, type, orbit_period, has_tail, galaxy_id) VALUES 
  ('TTT', '4', 4, true, 2),
  ('yyy', '4', 4, true, 2),
  ('56', '4', 4, true, 2),
  ('99', '4', 4, true, 2);
