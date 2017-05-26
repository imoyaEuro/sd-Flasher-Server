# sd-flasher-server
Ruby on Rails API.

#Table of contents
* [Institutional](#institutional)
* [Description](#description)
* [Rails admin](#rails_admin)
* [Setup with Docker](#setup-with-docker)
* [Production](#production)
* [Updating production code](#updating-production-code)
* [Model](#model)
* [Create provider manually](#create-provider-manually)
* [Create an admin](#create-an-admin)
* [Sign up and credits](#sign-up-and-credits)
* [API](#api)
* [API Errors](#api-errors)

### Institutional
Eurocase develops and sells tablets aimed for kids. This Rails app is both the auth system of the sd-flasher and the new version of the [TABI tablet](http://listado.mercadolibre.com.ar/tabi) once flashed. Also it has an admin panel for Eurocase admins.
### Description
The providers have credits.
A provider can buy packages with credits.
Packages have many games.
A game can belong to many packages.
When a provider buys a package it sends to the server a key which will be saved into the SdCard he is flashing.
The API returns status ok, or an error.

The encrypted games flashed into the SdCard.(See [sd-flasher](https://github.com/cran-io/sd_flasher) )

When the android app lanuches for the first time, it sends the key and tablet id (from now on "tablet").
If the key in the database has no tablet associated with it, it saves the tablet recieved.
If the key in the database has a tablet associated with it, it must match the tablet recieved. If it doesn't it returns an error.

The first time the android app wants to play a game, it sends the key and tablet id, and the API checks if that key/tablet combination bought a package that contains that game. If it does, it returns the cryptographic keys to decrypt the game.

###rails_admin
There is an admin panel on ```/admin``` which uses the gem [rails_admin](https://github.com/sferik/rails_admin) with [devise](https://github.com/plataformatec/devise). Users can login to the admin panel. Depending on what permissions have they can view/edit more models. If the User has permisson 'admin' then he can do everything, including editing other users permissions. Roles system use [cancancan](https://github.com/CanCanCommunity/cancancan) and [role_model](https://github.com/martinrehfeld/role_model). The list of existing permissions is on ```app/models/user.rb```. New roles can be added, but older roles should not be deleted. Also the order of the roles on that file should not be changed. This is because the roles is implemented as a bitmap. The file that actually gives the permissions is ```app/models/ability.rb```.

Versions on the credit attribute of ```Provider``` model is managed by gem [rails_admin_history_rollback](https://github.com/rikkipitt/rails_admin_history_rollback) which uses [paper_trail](https://github.com/airblade/paper_trail).

Configuration of what is being displayed in each model is in ```config/initializers/rails_admin.rb```

###Ugly stuff
 - User roles edited in rails_admin are saved in the application controller after a few validations. I wasn't able to make this work in the model.
 - I wasn't able to add a custom js only to the edit Provider 'view' in rails_admin. So I created a rails_admin partial, but an attribute was needed in order to get the partial display. So I replaced the partial of the credit attribute. and added the jquery there. ```/app/views/rails_admin/main/_add_jquery_partial.erb```. ugly ugly fix. (probably both ugly stuff could be fixed by using [rails-admin-scaffold](https://github.com/dhampik/rails-admin-scaffold) but will need some code refactoring.

###Setup with docker
To use [Docker](http://www.docker.com) (requires [docker-compose](https://docs.docker.com/compose/))
```sh
git clone https://github.com/cran-io/sd-flasher-server.git
cd sd-flasher-server
cp config/database.docker.yml config/database.yml
docker-compose up
```
We wait until ```docker-compose up``` show us the familiar output:
```sh
web_1 | [2015-07-06 17:39:19] INFO  going to shutdown ...
web_1 | [2015-07-06 17:39:19] INFO  WEBrick::HTTPServer#start done.
web_1 | => Booting WEBrick
web_1 | => Rails 4.2.1 application starting in development on http://0.0.0.0:3000
web_1 | => Run `rails server -h` for more startup options
web_1 | => Ctrl-C to shutdown server
```
In a new terminal, we "login" to the docker container y and load the db schema.
```sh
docker exec -i -t sdflasherserver_web_1 /bin/bash
rake db:schema:load RAILS_ENV=development
rake db:create RAILS_ENV=test
rake db:schema:load RAILS_ENV=test
rake db:seed RAILS_ENV=development
exit
```
We use ```docker-compose up``` only the first time. After that, we can use ```docker-compose start``` or ```docker-compose stop```.
```sh
docker-compose <start|stop>
```
### Production
The production server will be on an unknown version of Windows, 64 bits. That's why we prepared a Virtual Machine image in Virtual Box. The image has a Debian Jessie 64bits with docker and docker-compose. It start the container at start-up. The use of Docker toolbox for Windows was rejected because it's buggy and is not production ready (as 2015-10-19).

Default ```user:password``` is ```eurocase:sdflasherserverpassword```. This should be changed by Eurocase. ```root``` has the same password (and should also be changed). OpenSSH server is installed and accepts Password Login for user ```eurocase```. X does not start automatically on boot. To start X manually type ```startx``` on the command line.

### Updating production code
The easiest way to upgrade is to stop the container, update the files, and start the container.
```
docker-comopse stop
git pull origin master
docker-compose start
```
This will work if there are no new migrations.
If there are migrations, sysadmin will have to 
```sh
docker exec -i -t sdflasherserver_web_1 /bin/bash
rake db:migrate
exit
```
### Model
![Model](/doc/models_complete.png?raw=true "ERM")
Attributes underlined in red are the only relevant to the user of the API.
####Create provider manually
```sh
$ rails c
```
```ruby
u=Provider.new
u.email="asdf@asdf.com"
u.save!
u.api_token
```
####Create an admin
```ruby
admin = FactoryGirl.create(User,:email => "admin@example.com", :roles => [:admin], :name => "Admin",
                          :password => "123456", :password_confirmation => "123456")
```
####Sign up and credits
An admin, or a user with the permissions to manage providers, can create a provider. A new provider starts with 0 credits and doesn't know his api_token. All information can be viewed by the admin from the admin panel located at /admin. Currenly an admin has to manually inform a Provider his api_token (which is generated automatically when the Provider is created). If a Provider wants to buy more credits, he has to contact an admin. The admin has to manually edit the credit number in the admin panel. An automatic payment method is out of the scope of this API.
###To seed database with test data
```sh
$ rake db:seed
```
###API
```sh
$ rake routes
Verb URI Pattern                        Controller#Action
GET  /api/v1/profile                      api_providers#me
POST /api/v1/sdpackage/tablet             api_sd_packages#tablet
GET  /api/v1/packages                     api_packages#index
GET  /api/v1/games                        api_games#index
POST /api/v1/games/:id                    api_games#show
GET  /api/v1/packages/:id                 api_packages#show
POST /api/v1/packages/:id/buy             api_packages#buy
```

* query: view "profile" of current user
```sh
$ curl -H "Content-Type: application/json" "http://127.0.0.1:3000/api/v1/profile/?api_token=jwqIYBwpdqCKJOwRlhUhJjKujIZCvknUDUYYcfouerGOdNkWAoHvBcjGexWtRrva"
```
returns json with id, email and credit
```json
{
    "id": 15,
    "email": "asdf1@asdf.com",
    "credit": 9
}
```
* query: asign a tablet id to a specific SdPackage key. Returns all the games associated to the SdPackage through SdPackage-Sales-Package relation. If the SdPackage didn't have a tablet assigned, or if the tablet assigned is the same. Returns error 8 otherwise.
```sh
$ curl -X POST -H "Content-Type: application/json" -d '{"key": "ASDFASDF", "tablet": "2342341342"}' http://127.0.0.1:3000/api/v1/sdpackage/tablet
```
```json
[
    {
        "games":[
         { 
            "id":5,
            "gamekey":"2343243"
         },
         {
            "id":6,
            "gamekey":"2SFAs3sfd"
         }]
    }
 ]
```
* query: get array of all packages
```sh
$ curl -H "Content-Type: application/json" "http://127.0.0.1:3000/api/v1/packages/?api_token=jwqIYBwpdqCKJOwRlhUhJjKujIZCvknUDUYYcfouerGOdNkWAoHvBcjGexWtRrva" 
```
returns an array of jsons:
```json
[
    {
        "id": 10,
        "name": "arcade games",
        "description": "juegos ochenteros",
        "price": 1,
        "logo": null
    },
    {
        "id": 12,
        "name": "Battlefield pack",
        "description": "Counter-Strike pack",
        "price": 2,
        "logo": null
    },
    {
        "id": 11,
        "name": "CS Pack",
        "description": "Counter-Strike pack",
        "price": 5,
        "logo": "http://files.gamebanana.com/img/ss/srends/4e62f19671330.jpg"
    }
]
```
* query: get array of all games
```sh
$ curl -H "Content-Type: application/json" "http://127.0.0.1:3000/api/v1/games/?api_token=jwqIYBwpdqCKJOwRlhUhJjKujIZCvknUDUYYcfouerGOdNkWAoHvBcjGexWtRrva" 
```
```json
[
    {
        "id": 25,
        "name": "Counter Strike",
        "version": 1,
        "version_description": null,
        "description": "Counter-Strike is a first-person shooter game",
        "short_description": null,
        "company": null,
        "apk_link": null,
        "logo": null,
        "images": []
    },
    {
        "id": 26,
        "name": "Counter Strike 1.5",
        "version": 1,
        "version_description": null,
        "description": "Counter-Strike 1.5 is a first-person shooter game",
        "short_description": null,
        "company": null,
        "apk_link": null,
        "logo": null,
        "images": []
    },
    {
        "id": 27,
        "name": "Counter Strike 1.6",
        "version": 1,
        "version_description": null,
        "description": "Counter-Strike   1.6 is a first-person shooter game",
        "short_description": null,
        "company": null,
        "apk_link": null,
        "logo": null,
        "images": []
    },
    {
        "id": 28,
        "name": "Counter Strike Go",
        "version": 1,
        "version_description": null,
        "description": "Counter-Strike Go is a first-person shooter game",
        "short_description": null,
        "company": null,
        "apk_link": null,
        "logo": null,
        "images": []
    },
    {
        "id": 29,
        "name": "Battlefield 1942",
        "version": 1,
        "version_description": null,
        "description": "Battlefield 1942 is the first game in the Battlefield series. ",
        "short_description": null,
        "company": null,
        "apk_link": null,
        "logo": null,
        "images": []
    },
    {
        "id": 30,
        "name": "Battlefield Vietnam",
        "version": 1,
        "version_description": null,
        "description": "Battlefield Vietnam is a first-person shooter video game, the second in the Battlefield franchise after Battlefield 1942",
        "short_description": null,
        "company": null,
        "apk_link": null,
        "logo": null,
        "images": []
    },
    {
        "id": 31,
        "name": "Pacman",
        "version": 1,
        "version_description": null,
        "description": "Pacman description",
        "short_description": null,
        "company": null,
        "apk_link": null,
        "logo": null,
        "images": []
    },
    {
        "id": 32,
        "name": "Asteroids",
        "version": 1,
        "version_description": null,
        "description": "Asteroids description",
        "short_description": null,
        "company": null,
        "apk_link": null,
        "logo": null,
        "images": []
    },
    {
        "id": 33,
        "name": "Tetris",
        "version": 1,
        "version_description": "v1.0",
        "description": "Soviet tile-matching puzzle video game originally designed and programmed by Alexey Pajitnov.",
        "short_description": null,
        "company": "Nintendo",
        "apk_link": null,
        "logo": "https://upload.wikimedia.org/wikipedia/en/8/8d/NES_Tetris_Box_Front.jpg",
        "images": [
            "http://tetrisaxis.nintendo.com/_ui/img/bg/bg-tetris-10.png",
            "http://www.geeksofdoom.com/GoD/img/2014/09/tetris-video-game.jpg"
        ]
    }
]
```
* query: get an specific gamekey
```sh
$ curl -X POST -H "Content-Type: application/json" -d '{"tablet": "1234567", "key": "123455"}' "http://127.0.0.1:3000/api/v1/games/3/" 
```
```json
{
    "id": 3,
    "name": "Pacman",
    "gamekey": "111111"
}
```
* query: get details about specific package (includes games of that package). Example with package 13.
```sh
$ curl -H "Content-Type: application/json" "http://127.0.0.1:3000/api/v1/packages/13/?api_token=jwqIYBwpdqCKJOwRlhUhJjKujIZCvknUDUYYcfouerGOdNkWAoHvBcjGexWtRrva" 
```
returns a json with "package"(json) and "games"(array of jsons).
```json
{
    "package": {
        "id": 11,
        "name": "CS Pack",
        "description": "Counter-Strike pack",
        "price": 5,
        "logo": "http://files.gamebanana.com/img/ss/srends/4e62f19671330.jpg"
    },
    "games": [
        {
            "id": 25,
            "name": "Counter Strike",
            "version": 1,
            "version_description": null,
            "description": "Counter-Strike is a first-person shooter game",
            "short_description": null,
            "company": null,
            "apk_link": null,
            "logo": null,
            "images": []
        },
        {
            "id": 26,
            "name": "Counter Strike 1.5",
            "version": 1,
            "version_description": null,
            "description": "Counter-Strike 1.5 is a first-person shooter game",
            "short_description": null,
            "company": null,
            "apk_link": null,
            "logo": null,
            "images": []
        },
        {
            "id": 27,
            "name": "Counter Strike 1.6",
            "version": 1,
            "version_description": null,
            "description": "Counter-Strike   1.6 is a first-person shooter game",
            "short_description": null,
            "company": null,
            "apk_link": null,
            "logo": null,
            "images": []
        },
        {
            "id": 28,
            "name": "Counter Strike Go",
            "version": 1,
            "version_description": null,
            "description": "Counter-Strike Go is a first-person shooter game",
            "short_description": null,
            "company": null,
            "apk_link": null,
            "logo": null,
            "images": []
        }
    ]
}
```
* query: buy a package
```sh
$ curl -X POST -H "Content-Type: application/json" -d '{"api_token": "jwqIYBwpdqCKJOwRlhUhJjKujIZCvknUDUYYcfouerGOdNkWAoHvBcjGexWtRrva", "key": "ASDFASDF"}' http://127.0.0.1:3000/api/v1/packages/13/buy 
```
returns in array of games (each game has id, name and gamekey)
```json
{"status": "ok"}
```
###API Errors
error:message
```json
{"error":1,"message":"Not enough credits"}
{"error":2,"message":"Package not found"}
{"error":3,"message":"api_token missing"}
{"error":4,"message":"unauthorized"}
{"error":5,"message":"SdPackage key missing"}
{"error":6,"message":"SdPackage not found"}
{"error":7,"message":"tablet id missing"}
{"error":8,"message":"Tablet id does not correspond to the one assigned for this SdPackage"}
{"error":9,"message":"SdPackage key already in use"}
{"error":10,"message":"Invalid key/tablet combination"}
{"error":11,"message":"tablet id and SdPackage key missing"}
{"error":12,"message":"Game not found"}
{"error":13,"message":"This SdPackage has a package which didn't include this game"}
```
