# Weploy Timesheet
This is a simple application that allows the entry of time periods to track and approve the time employee spent at work or on a task. Awarded pay is calculated based on these entries and it aligns to specific rates predetermined.

## Features
The application has the following features:

* Login authentication
* Submitting a new timesheet
* Viewing already submitted timesheets

## The Solution Design
Implemented the solution with the following assets:

* Session and Timesheet controllers
* Users and Timesheets models
* Views to render the login, new timesheet and timesheet list pages
* A seed file to seed the database

## Testing
Implemented unit and system testing as follows (run 'rspec' from the command line to execute the test suite):

* Unit tests for the session and timesheet controllers
* Unit tests for the timesheet and user models
* Feature test for the timesheet and session views mimicking all possible user interactions

## Login credentials
After deploying and seeding the DB, you can login to the application using the following credentials:

* User 1: email - john@smith.com, password - chicken
* User 2: email - jane@doe.com, password - chicken
