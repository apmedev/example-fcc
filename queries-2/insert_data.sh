#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
#createdb -U freecodecamp worldcup 

$($PSQL "CREATE TABLE teams (
  team_id SERIAL PRIMARY KEY,
  name VARCHAR UNIQUE NOT NULL
);
")

$($PSQL "CREATE TABLE games (
  game_id SERIAL PRIMARY KEY,
  year INT NOT NULL,
  round VARCHAR NOT NULL,
  winner_id INT NOT NULL,
  opponent_id INT NOT NULL,
  winner_goals INT NOT NULL,
  opponent_goals INT NOT NULL,
  FOREIGN KEY (winner_id) REFERENCES teams (team_id),
  FOREIGN KEY (opponent_id) REFERENCES teams (team_id)
);
")

$($PSQL "TRUNCATE TABLE games, teams;
")



$($PSQL "INSERT INTO teams (name)
VALUES
    ('France'),
    ('Croatia'),
    ('Belgium'),
    ('England'),
    ('Sweden'),
    ('Russia'),
    ('Brazil'),
    ('Uruguay'),
    ('Portugal'),
    ('Argentina'),
    ('Spain'),
    ('Denmark'),
    ('Switzerland'),
    ('Japan'),
    ('Mexico'),
    ('Colombia'),
    ('Netherlands'),
    ('Costa Rica'),
    ('Algeria'),
    ('Nigeria'),
    ('Greece'),
    ('Germany'),
    ('Chile'),
    ('United States');
")


$($PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals)
VALUES
    (2018,'Final',(SELECT team_id FROM teams WHERE name='France'),(SELECT team_id FROM teams WHERE name='Croatia'),4,2),
    (2018,'Third Place',(SELECT team_id FROM teams WHERE name='Belgium'),(SELECT team_id FROM teams WHERE name='England'),2,0),
    (2018,'Semi-Final',(SELECT team_id FROM teams WHERE name='Croatia'),(SELECT team_id FROM teams WHERE name='England'),2,1),
    (2018,'Semi-Final',(SELECT team_id FROM teams WHERE name='France'),(SELECT team_id FROM teams WHERE name='Belgium'),1,0),
    (2018,'Quarter-Final',(SELECT team_id FROM teams WHERE name='Croatia'),(SELECT team_id FROM teams WHERE name='Russia'),3,2),
    (2018,'Quarter-Final',(SELECT team_id FROM teams WHERE name='England'),(SELECT team_id FROM teams WHERE name='Sweden'),2,0),
    (2018,'Quarter-Final',(SELECT team_id FROM teams WHERE name='Belgium'),(SELECT team_id FROM teams WHERE name='Brazil'),2,1),
    (2018,'Quarter-Final',(SELECT team_id FROM teams WHERE name='France'),(SELECT team_id FROM teams WHERE name='Uruguay'),2,0),
    (2018,'Eighth-Final',(SELECT team_id FROM teams WHERE name='England'),(SELECT team_id FROM teams WHERE name='Colombia'),2,1),
    (2018,'Eighth-Final',(SELECT team_id FROM teams WHERE name='Sweden'),(SELECT team_id FROM teams WHERE name='Switzerland'),1,0),
    (2018,'Eighth-Final',(SELECT team_id FROM teams WHERE name='Belgium'),(SELECT team_id FROM teams WHERE name='Japan'),3,2),
    (2018,'Eighth-Final',(SELECT team_id FROM teams WHERE name='Brazil'),(SELECT team_id FROM teams WHERE name='Mexico'),2,0),
    (2018,'Eighth-Final',(SELECT team_id FROM teams WHERE name='Croatia'),(SELECT team_id FROM teams WHERE name='Denmark'),2,1),
    (2018,'Eighth-Final',(SELECT team_id FROM teams WHERE name='Russia'),(SELECT team_id FROM teams WHERE name='Spain'),2,1),
    (2018,'Eighth-Final',(SELECT team_id FROM teams WHERE name='Uruguay'),(SELECT team_id FROM teams WHERE name='Portugal'),2,1),
    (2018,'Eighth-Final',(SELECT team_id FROM teams WHERE name='France'),(SELECT team_id FROM teams WHERE name='Argentina'),4,3),
    (2014,'Final',(SELECT team_id FROM teams WHERE name='Germany'),(SELECT team_id FROM teams WHERE name='Argentina'),1,0),
    (2014,'Third Place',(SELECT team_id FROM teams WHERE name='Netherlands'),(SELECT team_id FROM teams WHERE name='Brazil'),3,0),
    (2014,'Semi-Final',(SELECT team_id FROM teams WHERE name='Argentina'),(SELECT team_id FROM teams WHERE name='Netherlands'),1,0),
    (2014,'Semi-Final',(SELECT team_id FROM teams WHERE name='Germany'),(SELECT team_id FROM teams WHERE name='Brazil'),7,1),
    (2014,'Quarter-Final',(SELECT team_id FROM teams WHERE name='Netherlands'),(SELECT team_id FROM teams WHERE name='Costa Rica'),1,0),
    (2014,'Quarter-Final',(SELECT team_id FROM teams WHERE name='Argentina'),(SELECT team_id FROM teams WHERE name='Belgium'),1,0),
    (2014,'Quarter-Final',(SELECT team_id FROM teams WHERE name='Brazil'),(SELECT team_id FROM teams WHERE name='Colombia'),2,1),
    (2014,'Quarter-Final',(SELECT team_id FROM teams WHERE name='Germany'),(SELECT team_id FROM teams WHERE name='France'),1,0),
    (2014,'Eighth-Final',(SELECT team_id FROM teams WHERE name='Brazil'),(SELECT team_id FROM teams WHERE name='Chile'),2,1),
    (2014,'Eighth-Final',(SELECT team_id FROM teams WHERE name='Colombia'),(SELECT team_id FROM teams WHERE name='Uruguay'),2,0),
    (2014,'Eighth-Final',(SELECT team_id FROM teams WHERE name='France'),(SELECT team_id FROM teams WHERE name='Nigeria'),2,0),
    (2014,'Eighth-Final',(SELECT team_id FROM teams WHERE name='Germany'),(SELECT team_id FROM teams WHERE name='Algeria'),2,1),
    (2014,'Eighth-Final',(SELECT team_id FROM teams WHERE name='Netherlands'),(SELECT team_id FROM teams WHERE name='Mexico'),2,1),
    (2014,'Eighth-Final',(SELECT team_id FROM teams WHERE name='Costa Rica'),(SELECT team_id FROM teams WHERE name='Greece'),2,1),
    (2014,'Eighth-Final',(SELECT team_id FROM teams WHERE name='Argentina'),(SELECT team_id FROM teams WHERE name='Switzerland'),1,0),
    (2014,'Eighth-Final',(SELECT team_id FROM teams WHERE name='Belgium'),(SELECT team_id FROM teams WHERE name='United States'),2,1);
")

#
# Define variables
DB_NAME="worldcup"
DB_USER="freecodecamp"
DB_PASSWORD=""
SQL_FILE="create.sql"

# Run SQL script
# psql -d "$DB_NAME" -U "$DB_USER" -W "$DB_PASSWORD" -f "$SQL_FILE" 