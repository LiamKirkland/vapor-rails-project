# Vapor - Game Collection Manager
Vapor is a platform to manage your game collection, review games, and see other people's reviews! Users can view the full games list, add them to their collection, leave reviews, and view other users with their respective collections. Users can add each other as friends to more easily access their game list/reviews.  
Admins are responsible for adding/updating games. Admins can also change a user's username or remove their profile picture if they deem it innapropriate.

## Project Setup
- Pull the app down from GitHub
  - `git clone git@github.com:LiamKirkland/vapor-rails-project.git`
- Navigate to the project directory, install the required gems, and seed the data
  - This can be done by running `cd vapor-game-collection-manager`, `bundle install`, and `rails db:prepare`
  - *Note that the seed data includes an admin user, which is necessary for adding games. An admin user can also be created via rails console by creating a user and setting their `admin` attribute to `true`*
  - *Additional note: User and Game pictures are not included in the seed data, but can be uploaded via their respective edit pages*
- Once set up, run `rails s` and visit `http://localhost:3000/login` to begin using the app!

## Core Features
- ***User Accounts***
  - A user can create a new account via signup page
  - Once created, the user can sign in
  - Users can view a list of all games and other users
  - Users can add games to their collections, optionally with a score and review
  - Users can update their profile, including username, profile picture, and password
  - Users can add other users as friends
    - If a user has a pending friend request with another user (either out going or incoming), then they cannot do anything until that request is either accepted or declined
  - A user with admin status can add/edit games and edit other users, including giving them admin status
- ***Games***
  - Games can belong to many users, and have many users belong to it
  - Two games can exist with the same name and developer, but if all attributes match (Name, Dev, Release Date) it is then flagged as a dupe
    - This is to account for games with the same title, or remasters of games
  - Games will calculate their average user score and display it on their view page
  - Game will display all scores/reviews left on it
- ***Home Page***
  - Displays the current user's game and friends
  - Displays games the user has in their collection but has not rated yet
  - Displays friend suggestions (based on mutual friends)
  - Displays the most recently added games to the website

## User Notes
- Admins cannot view their own admin-edit pages
  - This is to prevent admins from removing their own admin status and potientially leaving the app with no admin users
- Username are restricted to alphanumeric plus periods and dashes, passwords can contain any characters
- The logos are hand drawn and I spent a very long 5 minutes on them 😁
