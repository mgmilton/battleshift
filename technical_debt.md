# Explanation of the Technical Debt in Battleshift
![technical_debt](https://imgur.com/a/yIYeO)

Upon inheriting this codebase, the first thing we recognized was the amount of extra code. As the above graphic shows, we reduced the technical debt of this project by over 4 hours. The primary way we accomplished this was by eliminating code that was not implemented throughout the project.

For instance, the board object contained about 150 lines of code whose methods were not called anywhere else within the project. It seemed the original developer anticipated a lot of functionality that would be needed. However, the final product never called for these features, leaving an excess of wasted code. Entire models (e.g. player) became superfluous by project completion. Perhaps, if this developer utilized a behavior driven development process the final codebase would have been more maintainable. 


## Our Technical Debt / Areas of Improvement

The calling of the Twilio Service in the shots controller is repetitive, and could be extracted as a decorator. There are also a lot of instance variables being called in the controllers that could be abstracted out, to clean up the controllers.

Inside the games controller we have a method in the game model that is being called that connects the users to the game that was started. While we have a joins table for the games and users, which means we could possibly have more than one player, connecting the players would require the calling of the method for the total amount many players there are. It would be nice to have a method that would take in the information from the params and only be called once to connect all players to the game.

There is also the possibility for the ships_placer model to be further refactored. To be specific, the method #message_formatter could possibly be broken apart into smaller methods. Additionally, the shots controller utilizes a similar method. Therefore, this method could be extracted into a module that would then be included in each controller.

Another example of technical debt is the linking between user boards. So far we have to call a method that is a conditional to set the opponents board, but there is possibly a more elegant way of connecting the two boards.
