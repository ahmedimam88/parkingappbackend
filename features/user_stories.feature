Feature:User Story1: User Registration
  As a customer
  Such that I go to register
  I want to register a user

    Scenario: Register a user with success
        Given I am on the sign_in page
        When I press signup ?
        Then I should be on the sign_up page
        And I fill in fullname with "Octanty"
        And I fill in username with "tanty"
        And I fill in password with "parool"
        And I fill in email with "tanty@gmail.com"
        And I fill in age with "27"
        And I fill in address with "Tartu"
        When I press Register
        Then I should see "h5" with "Username: tanty" confirmation message in the Dashboard

        Scenario: Register a user without success
        Given I am on the sign_in page
        When I press signup ?
        Then I should be on the sign_up page
        And I fill in fullname with "Octanty"
        And I fill in username with "tanty"
        And I fill in password with "parool"
        And I fill in email with "tanty@gmail.com"
        And I fill in age with "27"
        And I fill in address with "Tartu"
        When I press Register
        Then I cannot redirect to any other page as Dashboard
        #Then I should see "h5" with "User Already Exists" confirmation message 

Feature:User Story2: User Login
As a customer
So that I go to login
I want to sign in as a user

    Scenario: Login with valid credentials
        Given I am on the sign_in page
        And I fill in username with "ahmed"
        And I fill in password with "parool"
        When I press Sign in
        Then I should see "h5" with "Username: ahmed" confirmation message 

    Scenario: Login with invalid credentials
        Given I am on the sign_in page
        And I fill in username with "ahmed"
        And I fill in password with "parool1"
        When I press Sign in
        Then I should see "h4" with "Invalid Username or Password" confirmation message  


Feature: User Story3: View parking space availability
As a customer
So that I can view information about parking space availability for a specific area
I want to type the destination address, start time & end time

    Scenario: Enter valid destionation address, start time and end time of parking
        Given I am on the sign_in page
        And I fill in username with "ahmed"
        And I fill in password with "parool"
        When I press Sign in
        Then I should see "h5" with "Username: ahmed" confirmation message
        And I am in the Dashboard
        And I click on Parkings
        And I click on Search
        And I open the Search Page
        And I enter the destination_address with "Raatuse 22, Tartu"
        And I fill in start_time with "12/12/2019 5:50 PM"
        And I fill in end_time with "12/12/2019 5:55 PM"
        When I press Search
        Then I should be on the same page SearchParking Page and can see the parking spaces in the map

        Scenario: View parking spaces in an incorrect destination address
        Given I am on the sign_in page
        And I fill in username with "ahmed"
        And I fill in password with "parool"
        When I press Sign in
        Then I should see "h5" with "Username: ahmed" confirmation message
        And I am in the Dashboard
        And I click on Parkings
        And I click on Search
        And I open the Search Page
        And I enter the destination_address with "Annelinn, Tartu"
        And I fill in start_time with "12/12/2019 5:50 PM"
        And I fill in end_time with "12/12/2019 5:55 PM"
        When I press Search
        Then I should be on the same page SearchParking Page and no parking spaces appear on the map


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

Feature: User Story6: Update User Account
As a customer
So that I can update my personal information
I want to navigate to my Account

    Scenario: Update User Account Successfully
        Given I am on the sign_in page
        And I fill in username with "ahmed"
        And I fill in password with "parool"
        When I press Sign in
        Then I should see "h5" with "Username: ahmed" confirmation message
        And I am in the Dashboard
        And I click on ahmed
        And I click on Profile
        And I should be on the Profile page
        And I edit the fullname with "Ahmed I S"
        And I edit the email with "ahmedimamsamir@email.com"
        And I edit the age with "31"
        And I edit the address with "Egypt, Cairo"
        When I press Save
        Then I should remain on the Profile page while the data is successfully updated in the database

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

Feature: User Story8: Billing/Invoicing using the hourly payment scheme
As a customer
So that I can pay for my parking by choosing the hourly payment type
I want to choose between paying before parking or when extending my parking

	Scenario: Pay using options for hourly scheme billing
		Given the following options
		| destination |
		| Raatuse 22, Tartu |
		| hourly |
	And I sign in
	And I start new parking by entering the destination, start time and end time
	And I choose the Hourly Payment Method
	And I have the option to pay before parking or when extending my parking
	When I choose to pay before parking
	Then I am redirected to payment page
	And I complete the payment and start the parking
	When I choose to pay when extending the parking time
	Then I create the booking
	And I go to My_Booking Page
	And I see the option to Extend my parking
	When I click on the "Extend" button
	Then I am redirected to payment page
	And I complete the payment when extending the parking period


Feature: User Story9: Billing/Invoicing using the Real-Time Payment
As a customer
So that I can pay for my parking using the real-time payment type
I want to to choose between paying at the end of the parking or at the end of each month

	Scenario: Pay using options for real-time payment
		Given the following options
		| destination |
		| Raatuse 22, Tartu |
		| real-time |
	And I sign in
	And I start a new parking by entering the destination, start time and end time
	And I choose the real-time payment method
	And I have the option to pay at the end of the parking stay or at the end of each month
	When I choose to pay at the end of the parking stay
	Then I create the boking
	And I want to end the parking stay
	And I go to My Bookings page
	And I press the "Cancel" button
	And I am redirected to Payment page where I complete the real-time payment
	When I choose to pay at the end of each month
	Then I should configure this option myself 
	And I can make new parkings during each months
	And I go to My Payment (My Parking)
	And I see all my postponed payments
	When I click "Pay All"
	Then total of my postponed payments is substracted from my account


		  





