Feature:User Story1: User Registration
  As a customer
  Such that I go to register
  I want to register a user

  Scenario: Register a user with success
    Given the following users available
          | username | password	   | email        | dob        | address | fname  | lname | isactive | 
          | fred     | parool      | fred@ut.ee   | 10/04/1988 | AAA     | Fred   | Fred  | N        |
          | barney   | parool      | barney@ut.ee | 10/05/2000 | BBB     | Barney | Fred  | N        |
          | ahmed    | parool      | ahmed@email.com| 10/05/1988| Raatuse| Ahmed  | Samir | N        |
    And I want to create a user for Mohamed
    And I open USERS' web page
    And I enter the user information
    When I submit the registration request
    Then I should receive a confirmation message

Feature:User Story2: User Login
As a customer
So that I go to login
I want to sign in as a user

  Scenario: Login with valid credentials
    Given I am on the sign_in page
    | username | password |	 
    | ahmed    | parool   | 
  And I fill in "username" with "ahmed"
  And I fill in "password" with "parool"
  When I press "Login"
  Then I should be on the users home page
  And I should see "Login successful" confirmation message 


Feature: User Story3: View parking space availability
As a customer
So that I can view information about parking space availability for a specific area
I want to type the destination address & start time 

    Scenario: Enter the destionation address & start time of parking
        Given the following destionation address and start time
        | location | start time | end time |
        | Kaubamaja| 12:00      | 13:30    |
    And I sign in
    And I open the Parking Search Page 
    And I enter the destination address & start time
    When I press "Search" 
    Then I should see a Map showing the parking locations nearby the destionation address
    And I should choose one parking location and submit the request
    And I should see the details of this particular parking slot such as Category, Price per hour and real-time
    And I press confirm 


Feature: User Story4: Search desired parking slot 
As a customer
So that I can search for nearby desired parking slot
I want to submit the specific destination address, start time & end time of parking

    Scenario: Enter the destination address, start time & end time of parking
        Given the following destination address, start time & end time
            | destination     | start time | end time |
            | Kaubamaja, Tartu| 12:00      | 13:300   |
    And I sign in
    And I start new parking
    And I enter the destionation address, start time & end time
    And I press "Search"
    And I should see a Map showing the parking locations nearby the destination address
    When I choose the desired parking slot 
    Then I should see the details of this particular parking slot such as Category, TOTAL Price per hour and TOTAL price per real-time
    And I press confirm

Feature: User Story5: View billing options
As a customer
So that I can choose between hourly and real-time payment
I want to view the billing options

    Scenario: Choose billing option
        Given the following options
            | Payment/Billing Options |
            | hourly |
            | real-time |
    And I sign in
    And I start new parking
    And I enter the destionation address, start time and end time
    And I press "Search"
    And I should see a Map showing the parking locations nearby the destionation address
    And I submit an availability request
    And I see the availability of the parking spot
    And I request the cost of parking
    And I see the area name, and the cost of hourly & real-time
    And I choose the billing option
    When I submit the parking request
    Then I see my parking, area name and the chosen billing option 




