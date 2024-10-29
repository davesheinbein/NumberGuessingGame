#!/bin/bash

# Connect to PostgreSQL using the specified database
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# Prompt user for their username
echo "Enter your username:"
read USERNAME

# Validate username input
if [[ -z $USERNAME || ${#USERNAME} -gt 22 ]]
then
  echo "Invalid username. Please enter a username with 1-22 characters."
  exit 1
fi

# Check if the username exists
USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")

if [[ -z $USER_ID ]]
then
  # New user
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  INSERT_USER=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
else
  # Returning user
  GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE user_id=$USER_ID")
  BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE user_id=$USER_ID")
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses., with $USERNAME being a users name from the database, $GAMES_PLAYED being the total number of games that user has played, and $BEST_GAME being the fewest number of guesses it took that user to win the game"
fi

# Generate a random number between 1 and 1000
SECRET_NUMBER=$(( RANDOM % 1000 + 1 ))
echo "Guess the secret number between 1 and 1000:"
NUMBER_OF_GUESSES=0

# Guessing loop
while true
do
  read GUESS
  NUMBER_OF_GUESSES=$(( NUMBER_OF_GUESSES + 1 ))

  # Check if input is a valid integer
  if ! [[ $GUESS =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
    continue
  fi

  # Check the guess against the secret number
  if [[ $GUESS -eq $SECRET_NUMBER ]]
  then
    echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"
    
    # Update the user's game stats in the database
    UPDATE_GAMES_PLAYED=$($PSQL "UPDATE users SET games_played = games_played + 1 WHERE user_id=$USER_ID")
    
    if [[ -z $BEST_GAME || $NUMBER_OF_GUESSES -lt $BEST_GAME ]]
    then
      UPDATE_BEST_GAME=$($PSQL "UPDATE users SET best_game = $NUMBER_OF_GUESSES WHERE user_id=$USER_ID")
    fi
    break
  elif [[ $GUESS -gt $SECRET_NUMBER ]]
  then
    echo "It's lower than that, guess again:"
  else
    echo "It's higher than that, guess again:"
  fi
done