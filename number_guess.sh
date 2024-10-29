#!/bin/bash

# Connect to PostgreSQL using the specified database
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# Prompt user for their username
echo "Enter your username:"
read USERNAME

# Validate username input
# Check if the username is empty or longer than 22 characters
if [[ -z $USERNAME || ${#USERNAME} -gt 22 ]]
then
  # If invalid, print an error message and exit the script
  echo "Invalid username. Please enter a username with 1-22 characters."
  exit 1
fi

# Check if the username exists in the database
# Query the database for the user_id associated with the given username
USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")

# If the user_id is empty, it means the user does not exist in the database
if [[ -z $USER_ID ]]
then
  # New user
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  
  # Insert the new username into the users table
  INSERT_USER=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
  
  # Retrieve the user_id of the newly inserted user
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
else
  # Returning user
  # Retrieve the number of games played by the user
  GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE user_id=$USER_ID")
  
  # Retrieve the best game (fewest guesses) of the user
  BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE user_id=$USER_ID")
  
  # Welcome the returning user and display their game stats
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

# Generate a random number between 1 and 1000
SECRET_NUMBER=$(( RANDOM % 1000 + 1 ))
echo "Guess the secret number between 1 and 1000:"
NUMBER_OF_GUESSES=0

# Guessing loop
while true
do
  # Read the user's guess
  read GUESS
  NUMBER_OF_GUESSES=$(( NUMBER_OF_GUESSES + 1 ))

  # Check if the input is a valid integer
  if ! [[ $GUESS =~ ^[0-9]+$ ]]
  then
    # If not, prompt the user to guess again
    echo "That is not an integer, guess again:"
    continue
  fi

  # Check the guess against the secret number
  if [[ $GUESS -eq $SECRET_NUMBER ]]
  then
    # If the guess is correct, congratulate the user
    echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"
    
    # Update the user's game stats in the database
    # Increment the games_played count for the user
    UPDATE_GAMES_PLAYED=$($PSQL "UPDATE users SET games_played = games_played + 1 WHERE user_id=$USER_ID")
    
    # If the user's current game is their best game (fewest guesses), update the best_game
    if [[ -z $BEST_GAME || $NUMBER_OF_GUESSES -lt $BEST_GAME ]]
    then
      UPDATE_BEST_GAME=$($PSQL "UPDATE users SET best_game = $NUMBER_OF_GUESSES WHERE user_id=$USER_ID")
    fi
    # Exit the loop
    break
  elif [[ $GUESS -gt $SECRET_NUMBER ]]
  then
    # If the guess is too high, prompt the user to guess lower
    echo "It's lower than that, guess again:"
  else
    # If the guess is too low, prompt the user to guess higher
    echo "It's higher than that, guess again:"
  fi
done