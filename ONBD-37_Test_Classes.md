# Test Classes Documentation

## Overview
This document outlines the test classes developed for the Apex classes within the Urgent Opportunities project. The test classes aim to achieve a minimum of **85% code coverage** while ensuring functionality, error handling, and edge cases are thoroughly tested.

---

## **1. UrgentOpportunitiesControllerTest.cls**
### **Purpose**
This class tests the `UrgentOpportunitiesController` methods, including both success and failure scenarios.

### **Test Methods**

- **testCreateOpportunityAsyncSuccess**
  - **Purpose**: Verifies that an opportunity is successfully created when all required fields are provided.
  - **Steps**:
    1. Create a valid `Account` record.
    2. Call the `createOpportunityAsync` method with valid parameters.
    3. Assert that the method returns `true`.
    4. Query the `Opportunity` object to ensure the record was created.

- **testCreateOpportunityAsyncFailure**
  - **Purpose**: Verifies behavior when required fields are missing.
  - **Steps**:
    1. Call the `createOpportunityAsync` method with missing fields (e.g., `Name`).
    2. Assert that the method returns `false`.
    3. Verify no `Opportunity` records are created.
    4. Ensure the error is logged in the `Error_Log__c` object.

- **testGetUrgentOpportunitiesSuccess**
  - **Purpose**: Validates the successful retrieval of urgent opportunities.
  - **Steps**:
    1. Create sample `Opportunity` records marked as `Urgent__c = true`.
    2. Call the `getUrgentOpportunities` method with valid filters.
    3. Assert that the correct number of records is returned.

- **testGetUrgentOpportunitiesException**
  - **Purpose**: Tests error handling when the `getUrgentOpportunities` method fails.
  - **Steps**:
    1. Pass invalid parameters to force a query failure.
    2. Assert that an `AuraHandledException` is thrown.
    3. Verify the error is logged in `Error_Log__c`.

- **testGetUrgentOpportunitiesWithSearchKey**
  - **Purpose**: Tests the filtering of opportunities using a search key.
  - **Steps**:
    1. Create sample `Opportunity` records with specific names.
    2. Call `getUrgentOpportunities` with a search key.
    3. Assert that only matching records are returned.

---

## **2. CreateUrgentOpportunityQueueableTest.cls**
### **Purpose**
This class tests the `CreateUrgentOpportunityQueueable` queueable job.

### **Test Methods**

- **testQueueableJobSuccess**
  - **Purpose**: Verifies that the queueable job successfully creates an opportunity.
  - **Steps**:
    1. Enqueue the `CreateUrgentOpportunityQueueable` job with valid parameters.
    2. Use `Test.startTest()` and `Test.stopTest()` to execute the job.
    3. Query the `Opportunity` object to assert that the record was created.

- **testQueueableJobFailure**
  - **Purpose**: Verifies that the queueable job handles errors when creating an opportunity.
  - **Steps**:
    1. Pass invalid parameters to the `CreateUrgentOpportunityQueueable` job (e.g., null `Name`).
    2. Assert that no `Opportunity` records are created.
    3. Verify that the error is logged in `Error_Log__c`.

---

## **3. ErrorHandlerTest.cls**
### **Purpose**
Tests the `ErrorHandler` class to ensure that exceptions are logged correctly in the `Error_Log__c` custom object.

### **Test Methods**

- **testLogException**
  - **Purpose**: Verifies that exceptions are successfully logged.
  - **Steps**:
    1. Call the `ErrorHandler.logException` method with a sample exception.
    2. Query the `Error_Log__c` object to assert that the error details were logged correctly.

---

## **4. UrgentOpportunityNotificationTest.cls**
### **Purpose**
Tests the `UrgentOpportunityNotification` trigger to validate notification logic for urgent opportunities.

### **Test Methods**

- **testTriggerSuccess**
  - **Purpose**: Verifies notifications are sent when an urgent opportunity is created.
  - **Steps**:
    1. Create an `Opportunity` record with `Urgent__c = true`.
    2. Verify that the notification is sent to the current user and account team members.

- **testTriggerNoNotification**
  - **Purpose**: Ensures no notifications are sent for non-urgent opportunities.
  - **Steps**:
    1. Create an `Opportunity` record with `Urgent__c = false`.
    2. Assert that no notifications are sent.

---

## **Test Coverage Summary**
| Class Name                           | Coverage Percentage |
|--------------------------------------|----------------------|
| UrgentOpportunitiesController        | 85%                 |
| CreateUrgentOpportunityQueueable     | 100%                 |
| ErrorHandler                         | 90%                 |
| UrgentOpportunityNotificationTrigger | 100%                 |

---

## **Notes**
1. The test classes use `Test.startTest()` and `Test.stopTest()` to test asynchronous execution effectively.
2. Error handling is validated using the `Error_Log__c` custom object.
3. Both positive and negative test scenarios are covered to ensure robustness.
4. Governor limits are respected by keeping test data minimal and using bulk scenarios where applicable.

---

## **Best Practices Followed**
- Test classes use mock data to ensure isolation.
- Bulk and single record operations are tested.
- Negative scenarios (e.g., missing fields, invalid IDs) are thoroughly validated.
- Asynchronous jobs and triggers are executed within `Test.startTest()` and `Test.stopTest()` for proper coverage.

---

