# Sleep Tracker
Implemented Api for Sleep tracking of following users.

## Getting Started

Project setup for development and testing purposes.

## Features

- User Create
- User Can Follow And Un-follow Each Other
- User Can Tracking Sleeping Time (Using Clock In And Clock Out Event)
- User Can View It's Friend Sleep Time Data

### Prerequisites

* Ruby version

  - Ruby-3.2.2

* Rails vesrion

  - Rails-7.0.5

* Testing framework
  - RSpec

## Gems used

- Factory_bot_rails
- Database_cleaner (clean the database before running tests)
- shoulda-matchers (Simple one-liner tests for common Rails functionality)

## DB Design

- [User](https://github.com/vishalsabhaya/good-night-backend/wiki/Database-Design#users)
- [Sleep Tracking](https://github.com/vishalsabhaya/good-night-backend/wiki/Database-Design#sleep_trackings)
- [followers](https://github.com/vishalsabhaya/good-night-backend/wiki/Database-Design#followers)


## Setup

- Clone this repository

```
$ git clone https://github.com/vishalsabhaya/good-night-backend.git
```

- Install a compatible version of PostgreSQL

```
$ cd good-night-backend
```

- Initialize a new gemset (if using RVM) then install bundler

```
$ gem install bundler
```

- Install the application dependencies

```
$ bundle install
```

#### Database Configuration
*PostgreSQL* used as database for this application.
> Make sure PostgreSQL is installed in your machine and you have setup the  `database.yml` file correctly

- Database creation
```
$ rails db:create
```

# Create Database
rails db:create

- Tables migration

```
$ rails db:migrate
```
- insert initial user data
```
$ rails db:seed
```
- check the *db/schema.rb* after migration completed successfully
#### Running Tests

Test cases written using *RSpec*

Run test cases using this command

```
$ bundle exec rspec
```

All the tests should be *GREEN* to pass all test cases

#### Running Application

- Starting application

> Make sure you are in the application folder and already installed application dependencies

```
$ rails s
```

- Check the application on browser, open the any browser of your choice and hit the following in the browser url *http://localhost:3000/*


```
localhost:3000
```

## APIs List

| No. | End Point                                            | Request Type | Description                                   |
| --- | ---------------------------------------------------- | ------------ | --------------------------------------------- |
| 1.  | /api/v1/users                                    | POST         | Create User                                   |
| 2.  | /api/v1/users/:user_id/follow/:following_id      | POST         | Follow User                                   |
| 3.  | /api/v1/users/:user_id/unfollow/:following_id    | DELETE       | Un-Follow User                                |
| 4.  | /api/v1/users/:user_id/sleep_trackings           | GET          | User Friends Last Week Sleep Tracking Records |
| 5.  | /api/v1/users/:user_id/sleep_trackings/clock_in  | POST         | Clock In Event                                |
| 6.  | /api/v1/users/:user_id/sleep_trackings/clock_out | PATCH        | Clock Out Event                               |


## APIs documentation with [Postman](https://www.postman.com/)

- [Documentation](https://documenter.getpostman.com/view/17581673/2s93mBvyLU)

## Author

* **Vishal Sabhaya** - [GitHub profile](https://github.com/vishalsabhaya)