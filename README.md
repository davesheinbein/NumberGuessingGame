# Number Guessing Game

## Table of Contents

1. [Project Overview](#project-overview)
2. [Features](#features)
3. [Installation and Setup](#installation-and-setup)
4. [Usage](#usage)
5. [Example Session](#example-session)
6. [Database Structure](#database-structure)
   - [Entity-Relationship Diagram](#entity-relationship-diagram)
7. [Flowchart](#flowchart)

## Project Overview

The Number Guessing Game is a Bash-based command-line game that interacts with a PostgreSQL database to track user statistics. Users are prompted to guess a randomly generated number between 1 and 1000, with the game providing hints to guide them closer to the correct answer. The game also saves user data, including the number of games played and the best (fewest guesses) game score.

This project is part of the [FreeCodeCamp Relational Database Certification](https://www.freecodecamp.org/learn/relational-database).

View the project requirements here: [Number Guessing Game project](https://www.freecodecamp.org/learn/relational-database/build-a-number-guessing-game-project/build-a-number-guessing-game).

## Features

- **Username Recognition**: Tracks users based on username, welcoming new players and showing returning players' stats.
- **Database Interaction**: Uses PostgreSQL to save and retrieve user information.
- **Random Number Generation**: Randomly generates a target number between 1 and 1000.
- **Hint System**: Provides guidance if guesses are too high or too low.
- **Error Handling**: Validates input to ensure the guesses are integers.
- **Game Stats**: Records the number of guesses per game and updates if it’s a user’s best score.

## Installation and Setup

### Instructions

1. **Clone the Repository**:

   ```bash
   git clone https://github.com/davesheinbein/NumberGuessingGame.git
   cd NumberGuessingGame
   ```

2. **Database Setup**:

   - Connect to PostgreSQL and create the database:
     ```bash
     psql --username=freecodecamp --dbname=postgres -c "CREATE DATABASE number_guess;"
     ```

   - Create the `users` table:
     ```bash
     psql --username=freecodecamp --dbname=number_guess -c "
       CREATE TABLE IF NOT EXISTS users (
         user_id SERIAL PRIMARY KEY,
         username VARCHAR(22) UNIQUE,
         games_played INTEGER DEFAULT 0,
         best_game INTEGER
       );"
     ```

3. **Run the Game**:
   - Make the script executable:
     ```bash
     chmod +x number_guess.sh
     ```
   - Start the game:
     ```bash
     ./number_guess.sh
     ```

## Usage

- **Start the Game**: Run `./number_guess.sh` in the terminal.
- **Enter Username**: You’ll be prompted for a username. If it's your first time, a new profile will be created.
- **Guessing**: Enter guesses between 1 and 1000. The game provides hints if your guess is too high or too low.
- **Results**: Once you guess correctly, your score and the secret number are displayed, and your stats are updated.

## Example Session

```plaintext
$ ./number_guess.sh
Enter your username:
bro
Welcome back, bro! You have played 2 games, and your best game took 8 guesses.
Guess the secret number between 1 and 1000:
500
It's lower than that, guess again:
250
It's higher than that, guess again:
...
You guessed it in 11 tries. The secret number was 564. Nice job!
```

## Database Structure

### Entity-Relationship Diagram (ERD)

The ERD shows the structure of the `users` table used to store user data for the game.

```plaintext
+-------------+       +-----------------------------+
|   users     |       |         Attributes          |
+-------------+       +-----------------------------+
| user_id (PK)|       | user_id SERIAL PRIMARY KEY  |
| username    |       | username VARCHAR(22) UNIQUE |
| games_played|       | games_played INTEGER        |
| best_game   |       | best_game INTEGER           |
+-------------+       +-----------------------------+
```

## Flowchart

The following flowchart outlines the game process, from user login to guessing and updating scores:

```plaintext
              +-------------------------+
              | Start Game              |
              +-----------+-------------+
                          |
              +-----------v-------------+
              | Enter Username          |
              +-----------+-------------+
                          |
              +-----------v-------------+
      +-----> | Existing User?          |
      |       +-----------+-------------+
      |                   |
      |     +-------------+------------+
      |     |                            |
      v     | No                         | Yes
   +---------v---------+       +---------v---------+
   | Insert New User   |       | Retrieve Stats    |
   +---------+---------+       +---------+---------+
             |                           |
+------------v-------------+     +-------v---------+
| Generate Random Number   |     | Print Stats     |
+------------+-------------+     +-------+---------+
             |                           |
+------------v-------------+     +-------v---------+
|      Prompt for Guess    |<---+Guess Correct?    |
+------------+-------------+      Update Score     |
             |                           |
             +---------------------------+
                          |
                    +-----v-----+
                    | End Game  |
                    +-----------+
```

## Commit Changes

# Make some changes and commit them
# For example, adding input validation
git commit -am "fix: add input validation for username"

# Another change, for example, improving user feedback
git commit -am "feat: improve user feedback messages"

# Another change, for example, refactoring code
git commit -am "refactor: clean up code structure"

# Another change, for example, adding error handling
git commit -am "chore: add error handling for database operations"