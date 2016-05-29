Feature: I can do different mysql interactions

  Background: I connect to mysql
    Given I am connected to mysql


  Scenario: I ping
    Then I can ping


  Scenario: I close the connection
    Then I close the connection


  Scenario: I destroy the connection
    Then I destroy the connection


  Scenario: I can write custom queries
    When I send the query "SELECT * FROM `users`"
    Then I receive the following results
      | id         | 1              |
      | first_name | first          |
      | last_name  | last           |
      | email      | email@mail.com |
      | password   | pass           |


  Scenario: I can select all columns in a table without where clause
    When I select all columns in "users" without where clause
    Then I receive the following results
      | id         | 1              |
      | first_name | first          |
      | last_name  | last           |
      | email      | email@mail.com |
      | password   | pass           |


  Scenario: I can select all columns in a table with where clause
    When I select all columns in "users" where
      | id         | 1              |
      | first_name | first          |
    Then I receive the following results
      | id         | 1              |
      | first_name | first          |
      | last_name  | last           |
      | email      | email@mail.com |
      | password   | pass           |


  Scenario: I can select all columns in a table with where clause and OR operator
    And I set the where operator to "OR"
    When I select all columns in "users" where
      | id         | 1     |
      | first_name | first |
    Then I receive the following results
      | id         | 1              |
      | first_name | first          |
      | last_name  | last           |
      | email      | email@mail.com |
      | password   | pass           |


  Scenario: I can select specific columns in a table without where clause
    When I set to select the following columns
      | id         |
      | first_name |
    And I perform the select on "users"
    Then I receive the following results
      | id         | 1     |
      | first_name | first |


  Scenario: I can select specific columns in a table without where clause
    When I set to select the following columns
      | id         |
      | first_name |
    And I set the where clause to
      | first_name | first |
    And I perform the select on "users"
    Then I receive the following results
      | id         | 1     |
      | first_name | first |


  Scenario: I can join results from selecting all columns from two tables without where clause
    When I set to join the results from the tables "users", "user_pictures"
    And I set the join type to "RIGHT"
    And I set to join by
      | id | user_id |
    And I perform the join
    Then I receive the following results
      | id         | 1              |
      | first_name | first          |
      | last_name  | last           |
      | email      | email@mail.com |
      | password   | pass           |
      | picture_id | 1              |
      | user_id    | 1              |


  Scenario: I can join results from selecting specific columns from two tables without where clause
    When I set to select the following columns
      | id         |
      | first_name |
    And I set to join the results from the tables "users", "user_pictures"
    And I set the join type to "RIGHT"
    And I set to join by
      | id | user_id |
    And I perform the join
    Then I receive the following results
      | id         | 1              |
      | first_name | first          |


  Scenario: I can join results from selecting all columns from two tables with where clause
    When I set to join the results from the tables "users", "user_pictures"
    And I set the where clause to
      | picture_id | 1 |
    And I set the join type to "RIGHT"
    And I set to join by
      | id | user_id |
    And I perform the join
    Then I receive the following results
      | id         | 1              |
      | first_name | first          |
      | last_name  | last           |
      | email      | email@mail.com |
      | password   | pass           |
      | picture_id | 1              |
      | user_id    | 1              |


  Scenario: I can join results from selecting specific columns from two tables with where clause
    When I set to select the following columns
      | id         |
      | first_name |
    And I set the where clause to
      | picture_id | 1 |
    And I set to join the results from the tables "users", "user_pictures"
    And I set the join type to "RIGHT"
    And I set to join by
      | id | user_id |
    And I perform the join
    Then I receive the following results
      | id         | 1              |
      | first_name | first          |


  Scenario: I can insert one row in a table
    When I insert into "users" the row
      | first_name | first2          |
      | last_name  | last2           |
      | email      | email@mail.com2 |
      | password   | pass2           |
    When I select all columns in "users" where
      | id         | 2      |
      | first_name | first2 |
    Then I receive the following results
      | id         | 2               |
      | first_name | first2          |
      | last_name  | last2           |
      | email      | email@mail.com2 |
      | password   | pass2           |


  Scenario: I can insert rows in a table
    When I insert into "users" the rows
      | first_name | first2          |
      | last_name  | last2           |
      | email      | email1          |
      | password   | pass2           |
      | first_name | first3          |
      | last_name  | last3           |
      | email      | email2          |
      | password   | pass3           |
    When I select all columns in "users" where
      | id         | 2      |
      | first_name | first2 |
    Then I receive the following results
      | id         | 2               |
      | first_name | first2          |
      | last_name  | last2           |
      | email      | email1          |
      | password   | pass2           |
    When I select all columns in "users" where
      | id         | 3      |
      | first_name | first3 |
    Then I receive the following results
      | id         | 3               |
      | first_name | first3          |
      | last_name  | last3           |
      | email      | email2          |
      | password   | pass3           |


  Scenario: I can update a row in a table
    When I set the updated row to
      | first_name | first3          |
      | last_name  | last3           |
      | email      | email@mail.com3 |
      | password   | pass3           |
    And I update the row in "users"
    When I select all columns in "users" where
      | email      | email@mail.com3 |
      | first_name | first3          |
    Then I receive the following results
      | id         | 2               |
      | first_name | first3          |
      | last_name  | last3           |
      | email      | email@mail.com3 |
      | password   | pass3           |


  Scenario: I can delete from a table with where clause and OR operator
    And I set the where operator to "OR"
    When I delete from "users" where
      | id         | 1     |
      | first_name | first |


  Scenario: I can truncate a table
    Then I truncate "users"
