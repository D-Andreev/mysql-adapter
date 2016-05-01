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


  Scenario: I can select specific columns in a table without where clause
    When I set to select the following columns
      | id         |
      | first_name |
    And I perform the select on "users"
    Then I receive the following results
      | id         | 1              |
      | first_name | first          |


  Scenario: I can select specific columns in a table without where clause
    When I set to select the following columns
      | id         |
      | first_name |
    And I set the where clause to
      | first_name | first |
    And I perform the select on "users"
    Then I receive the following results
      | id         | 1              |
      | first_name | first          |
