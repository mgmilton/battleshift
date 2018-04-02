# An Explanation of the Endpoints in Battleshift

## Game Endpoints
These are the necessary endpoints for playing a game of battleshift. For all of these endpoints, the user's api key must be specified ```headers = {"X-Api-Key" => user.api_key}```.

### Display a Game
* ```GET localhost:3000//api/v1/games/#{game.id}``` allows a user to display a game.

### Place a Ship
* ```POST localhost:3000/api/v1/games/#{game.id}/ships``` allows a user to place a ship with the following params```params =  {ship_size: 3,
  start_space: "A1",
  end_space: "A3"} ```.

### Fire at a Ship
* ```POST localhost:3000/api/v1/games/#{initial_game.id}/shots ``` allows a player to fire at an opponents ship with the target specified in the params ```params = {target: "A1"}```.
