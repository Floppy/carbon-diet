Feature: iPhone interface
  In order to enter data easily
  As an iPhone owner
  I want to enter data on my iPhone

  Scenario: iPhone login page
    Given I am using Mobile Safari
    When I go to the home page
    Then I should see "Log In"
    And I should not see "Saving the planet. Together."

  @javascript
  Scenario: iPhone login
    Given I am using Mobile Safari
    And I go to the home page
    When I fill in the following:
     | user[login]    | James   |
     | user[password] | testing |
    And I follow "Log In"
    Then I should see "Electricity"
    And I should see "Natural Gas"
    And I should see "Ambulance"
    And I should see "Fire Engine"
    And I should not see "Blog"

  @javascript
  Scenario: iPhone electricity data entry page
    Given I am using Mobile Safari
    And I am logged in as "James" with password "testing"
#    When I follow "Electricity"
#    Then I should see "Reading"
#    And I should see "Date"