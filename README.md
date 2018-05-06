# BattleShift
[![Maintainability](https://api.codeclimate.com/v1/badges/5c7d6df27102140dc5a3/maintainability)](https://codeclimate.com/github/mgmilton/battleshift/maintainability)
[![Dependency Status](https://beta.gemnasium.com/badges/github.com/mgmilton/battleshift.svg)](https://beta.gemnasium.com/projects/github.com/mgmilton/battleshift)
[![Issues](https://img.shields.io/github/issues/mgmilton/battleshift.svg?style=flat-square)](https://github.com/mgmilton/battleshift/issues)
[![License](https://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat-square)](http://opensource.org/licenses/MIT)

This project created an API implementation of the game Battleship. After authorization and activation through an email, a player can play against another player through an API. To see all the endpoints utilized, in a game look this [endpoint explanation](https://github.com/mgmilton/battleshift/blob/master/endpoint_explanations.md). Through utilizing Twilio's API, the game also sends SMS updates after the opponent has taken his or her turn. A deployed verison of the api can be visited [here](https://battleshift.herokuapp.com/).

## Table of Contents
- [Getting Started](#getting-started)
- [Prerequisites](#prequisites)
- [Installing](#installing)
- [Running the Tests](#running-the-tests)
- [End to End Testing](#break-down-into-end-to-end-tests)
- [Built With](#built-with)
- [Contributing](#contributing)
- [Authors](#authors)
- [Acknowledgements](#acknowledgments)

## Getting Started

These instructions will get you a copy of the battleshift API up and running on your local machine for development and testing purposes.

## Prerequisites


* Ruby, version 2.5
* Rails, version 5.1.5
* Puma, version 3.7
* Rspec-Rails

After cloning down this repository, change into the directory ```battleshift``` and run:

```
bundle
```

## Installing

To setup the database necessary for this API, run the following commands:

```
rails db:create db:migrate db:seed
```



## Running the tests

In order to run the test suite, run the following command:
```
bundle exec rspec
```

## Break Down of Test Suite

* This test suite implements mocks, stubs, doubles, and spies. The following common edge cases in playing a game are tested.
  1. User cannot shoot at a position not on the board
      * ```rspec spec/requests/api/v1/games/shots_spec.rb```
  2. User cannot shoot twice in a row
      * ```rspec spec/requests/api/v1/games/shots_spec.rb```
  3. User cannot shoot after the game is over
      * ```rspec spec/requests/api/v1/games/shots_spec.rb```
  4. User cannot place an extra ship
      * ```rspec spec/requests/api/v1/games/ships_spec.rb```
  5. User cannot place a ship on a location not on the board
      * ```rspec spec/requests/api/v1/games/ships_spec.rb```
  6. User cannot place a ship that in a spot already occupied by another ship
      * ```rspec spec/requests/api/v1/games/ships_spec.rb```
  7. User must place ships in same column or row
      * ```rspec spec/requests/api/v1/games/ships_spec.rb```
  8. User cannot post to a game they’re not playing in
      * ```rspec spec/requests/api/v1/games/user_cannot_post_to_game_they_are_not_in_spec.rb```
  9. Inactive users cannot post to a game
      * ```spec/requests/api/v1/games/inactive_user_cannot_post_spec.rb```
  10. User cannot login in with bad info
      * ```spec/features/user_can_login_spec.rb```

## Built With
* [twilio](https://github.com/twilio/twilio-ruby)
* [active model serializers](https://github.com/rails-api/active_model_serializers)
* [factorybot](https://github.com/thoughtbot/factory_bot)
* [database cleaner](https://github.com/DatabaseCleaner/database_cleaner)
* [shoulda matchers](https://github.com/thoughtbot/shoulda-matchers)
* [vcr](https://github.com/vcr/vcr)
* [webmock](https://github.com/bblimke/webmock)


## Contributing

Please feel free to submit pull requests and suggestions to this repository. We would love your feedback.

## Authors

* [Joseph Jobes](https://github.com/AtmaVichara)
* [Matt Milton](https://github.com/mgmilton)


## Acknowledgments

* Thanks to our wonderful instructors at [Turing](https://github.com/turingschool)
