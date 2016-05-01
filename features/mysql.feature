Feature: I can do different mysql interactions

  Scenario: I can connect to mysql server
    When I connect to mysql
    Then I can ping
