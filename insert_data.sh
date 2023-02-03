#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo "$($PSQL "TRUNCATE TABLE games, teams")"
cat games.csv | while IFS="," read YEAR ROUND WTEAM LTEAM WGOALS LGOALS
do
  if [[ $YEAR != "year" ]]
  then
    WTEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name LIKE '$WTEAM'")
    if [[ -z $WTEAM_ID ]]
    then
      INSERT_WTEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WTEAM')")
    fi
    LTEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name LIKE '$LTEAM'")
    if [[ -z $LTEAM_ID ]]
    then
      INSERT_LTEAM=$($PSQL "INSERT INTO teams(name) VALUES('$LTEAM')")
    fi
    NEW_WTEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name LIKE '$WTEAM'")
    NEW_LTEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name LIKE '$LTEAM'")
    INSERT_GAME="$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $NEW_WTEAM_ID, $NEW_LTEAM_ID, $WGOALS, $LGOALS)")"
  fi
done