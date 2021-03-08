# Rails chat application


This is a Ruby on Rails app running on Docker using Elastic Search and Go Lang, for a challenge by Instabug.
The app could work on both APi and GUI each has steps to follow and build (not working at the same time)

## Environment

* Ruby 2.6.2
* Rails 5.2
* Elasticsearch 5.4.0
* Redis 4.0
* Sidekiq
* Go Lang

## Requirements

* Docker
* Your favorite API test tool, Postman is great

## Usage

1. Make sure ```docker``` and ```docker-compose``` are installed
2. Clone repository
3. Run the following command in the root folder of the repo

```
$ docker-compose build
```

This builds the docker containers needed.

Namely they are **4 main docker containers**:

1. The Rails app
2. Sidekiq
3. The ElasticSearch app
4. The Redis app

*Note: If you are using a fresh docker installation, fetching the resources will download around half a gigabyte (mainly the ElasticSearch and the Rails libraries)*

Then to run application (API calls)

```
$ sudo docker-compose --build
$ sudo docker-compose up
$ bundle exec whenever -w  //this for cron job to start
$ cd to db folder and type ./workers  // this to run go worker and start processing insert message into db from go instead of rails 
```

## Program Flow

client visit our site and obligated to sign in other wise nothing to do is authorized if dont have account he could create one by sign up. If you are using postman or any other tool for testing Api you must recognize jwt token generated after sigining in and attach it any other request while testing API in order to verfy you are authorized user.
After sigining in you have to start by creating application a token will be returned it is an auto generated one from rails and return if application successfully created.
Use App token to create Room by assiging both name and token in this Room you could chat with other people in it (I am streaming data with web sockets and messages written to database with GO and sidekiq).
Also inside each room you could search on messages (I implemented elastic search for this).

## Race Conditions
While testing I noticed if we run multiple servers at same time we are in risk to face race condition in two variables massege_count and chat_count if two users at same time
updating the value by increment it our application will increment only one not the two users it is handled by setting locks.

## Challenging part Go and Elastic search
Last days while developing I noticed that Elastice search when integrated by rails it waits rails till finish database transaction and send call back then elastic search start reindex and refreshing to take effect of new rows after making GO part bonus point I noticed that Go call back is local and dont reach rails which makes elastic search not feel new transactions. I followed a lot tutorial some of them reindexing from scrach but all of them have big issues like down time . Finally solved by creating reindex_callback function manully acutally it is very small function but it do what we want.

## Cron job
I recognized from the requirments that we dont want message_count or room_count to be lagged more than 1 hour I created cron job for this two runner tasks work in background and logs when ever they are invoked you could check it.

## Queue System (Rails and Go togather)
In order to provide concurrency and multi-threading on queue of tasks (in case our app became large scale) sidekiq is effiecnt in it. I integrated it with rails and take jobs (message creation) and insert it in queue after that worker wrote by GO connect to sidekiq to consume the task.

## Rspec and unit tests
Sadly, I did not have time enough to write all possible tests. But there is test read to run by you in spec directory called scheduler.rb it tests if cron job successs or not.
This tests works on both enviroment GUI and API.
Anther two tests for user registiration and user login found in /spec/features unfourtanley time didn't fit to work on it for API enviroment works only on GUI.

## API Description

If settings kept as default, rails server will run on http://localhost:3000 and hence append that with the paths in the table below.
Please take care when the paramters are placed in body or in params.

| Action                                                                   | HTTP Verb | Path                                                                        | Parameters                                                                        | Response                                                |
|--------------------------------------------------------------------------|-----------|-----------------------------------------------------------------------------|-----------------------------------------------------------------------------------|---------------------------------------------------------|
| Sign up for new user                                                     | POST      |  /users                                                                     | :email, :username ,:password                                                      | {:id, :created_at, ::updated_at, :email, :username}     |
| Sign in for current user                                                 | POST      | /users/sign_in                                                              | :email, :password                                                                 | {:id, :created_at, :updated_at, :email, :username}      |
| View all applications                                                    | Get       | /apps                                                                       |  N/A                                                                              | {:app_id, :app_token, :name, :count}                    |
| Create a new application                                                 | POST      | /apps                                                                       | :name                                                                             | {:name, :app_token, :count, :id}                        |
| Get number of chats under an application                                 | GET       | /apps/:app_token/chats/count                                                | :app_token                                                                        | {:chats_count}                                          |
| Delete an application by its token                                       | DELETE    | /apps/:app_token/delete                                                     | :app_token                                                                        | Status message about action completion/fail             |
| Create a new chat under an application                                   | POST      | /rooms/create                                                               | :app_id, :app_token, :name                                                        | {:id, :name, :created_at, :updated_at}                  |
| Get list of all chats under an application                               | GET       | /rooms?app_token=:app_token                                                 | :app_token                                                                        | [{:chat_number, :created_at}]                           |
| Get number of messages under an application                              | GET       | /rooms/:app_token/chats/:chat_number/messages/count                         | :app_token, :chat_number                                                          | {:messages_count}                                       |
| Delete a specific chat                                                   | DELETE    | /applications/:app_token/chats/:chat_number/delete                          | :app_token, :chat_number                                                          | Status message about action completion/fail             |
| Create a new message (Don't forget to open go worker before sending)     | POST      | /room_messages/                                                             | :room_id, :message                                                                | Status if Go worker performing this operation or failed |
| Search                                                                   | GET       | /room_search_messages?search_message=:query                                 | :search_message (from params in postman)                                          | {"results":(:message, :room_id, :user_id)}               |
| Get all messages under a specific chat                                   | GET       | /messages/:app_token/chats/:chat_number/display                             | :app_token, :chat_number                                                          | {:message, :id, :created_at, :updated_at} |
| Get details about a specific message                                     | GET       | /room_messages?id=:id                                                       | :id       | Delete a specific message                                                | DELETE    | /message/:id/delete                                                         | :id                                                                               | Status message about action completion/fail             |                                                                        | {:message, :id, :created_at, :updated_at}   |


To run application (GUI)

1.in session_store.rb<br/>
2.comment this line
    Rails.application.config.session_store :disabled I added this line to prevent postman from storing cookies.<br/>
3.Also you need to comment in every controller 
   "respond_to :json" added to respond on postman by json
   "skip_forgery_protection" added to by passes authenication alert by rails during testing<br/>
4.After that run the server and go to /users/sign_in<br/>

Here is how it looks like: 


![Bash completion demo](https://iridakos.com/assets/images/posts/rails-chat-tutorial/rails-chat-tutorial.gif)

## Things left working on them:
1. Rspecs on (Sidekiq, Elastic Search, MessageCreation, RoomCreation, ApplicationCreation)
2. Ngnix load balancer
3. Finishing caching on data

