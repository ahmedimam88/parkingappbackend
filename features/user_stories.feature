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
            | Raatuse 22, Tartu| 12:00      | 13:300   |
    And I sign in
    And I navigate to the parking menu
    And I open the Search Parking page
    And I enter the location address, start time & end time
    And I press "Search"
    And I should see a Map showing the parking locations nearby the destination address
    When I choose the desired parking slot 
    Then I should see the details of this particular parking slot such as Parking Slot, Zone, Hourly rate, Estimated Price per hour and per real-time
    When I press confirm
    Then I should reveive a confimration message "Booking is created"

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
    And I see the area name, and the cost of hourly & real-time
    And I choose the billing option
    When I submit the parking request
    Then I receive a confirmation message indicating that My Booking is created
    And I am redirected to My Booking History
    And I see my parking, start time, end time, area name and the chosen billing option, status
    And I have the option to Extend or Cancel my booking

Feature: User Story6: Upate User Account
As a customer
So that I can update my personal information
I want to navigate to my Account

    Scenario: Update User Account
        Given the following options
            | username | password	   | email        | dob        | address | fullname | usertype | isactive |         
            | ahmed    | parool      | ahmed@email.com| 10/05/1988| Raatuse| Ahmed Samir| customer | N        |
    And I sign in
    And I have the option to navigate to my account
    And I can see and update my personal information
    When I press "Save"
    Then I receive a confimration message and my account status changes to Updated Account
    And I am redirected to the dashboard

Feature: User Story7: Manually check remaining parking time
As an customer
So that I can see and extend the parking time of my booking 
I want to check the remaining parking time

    Scenario: Manually check the remaining parking time
        Given the following options
            | destination     | start time | end time |
            | Raatuse 22, Tartu| 12:00      | 13:300   |
    And I sign in
    And I start a new parking
    And I enter the destination, start time & end time
    And I should see a Map showing the parking locations nearby the destionation address
    And I choose a desired parking spot
    And I choose the HOURLY payment method
    And I navigate to my booking
    And I manually check the remaining time
    And I edit the endtime 
    When I press "Extend"
    Then my parking status gets updated and parking time gets extended
    When there are 10 minutes of parking reamining 
    Then the system sends me a notification to remind me of my booking time
    When there are only 2 minutes left of my parking
    Then I cannot extend the parking anymore and the same parking spot stauts is changed to available







