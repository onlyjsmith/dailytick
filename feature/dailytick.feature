Feature: Basic function
  In order to improve my performance on ANY TASK
  As an any old person, I want to keep a record of the number of unbroken days in a row I've completed a specified challenge. I want to be able to clearly see the chain, and consequently be positively encouraged to maintain it.
  This should eventually be a mobile app, but will be ok to be desktop to start with.
  
  Scenario: Add new day
    Given a challenge called "Go running"
    When I complete a day's activity
    Then I want to see chain length increase by 1