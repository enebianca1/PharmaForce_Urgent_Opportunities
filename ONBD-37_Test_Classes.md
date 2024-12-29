# Test Classes Documentation

## Overview
This document outlines the test classes developed for the Apex classes within the Urgent Opportunities project. The test classes ensure a minimum of **85% code coverage** while validating functionality, error handling, and edge cases.

---

## **1. UrgentOpportunitiesControllerTest.cls**
### **Purpose**
This class tests the `UrgentOpportunitiesController` methods, covering both success and failure scenarios.

### **Test Methods**

- **testCreateOpportunity**
  - **Purpose**: Verifies successful creation of an opportunity when all required fields are provided.
  - **Steps**:
    1. Create a valid `Account` record.
    2. Call the `createOpportunity` method with valid parameters.
    3. Assert that the opportunity is created successfully.
    4. Query the `Opportunity` object to verify the record exists.

- **testCreateOpportunityMissingName**
  - **Purpose**: Validates error handling when the `Name` field is missing.
  - **Steps**:
    1. Call the `createOpportunity` method with `null` as the `Name`.
    2. Verify that an `AuraHandledException` is thrown with the appropriate error message.
    3. Assert that no `Opportunity` records are created.

- **testCreateOpportunityMissingStageName**
  - **Purpose**: Validates error handling when the `StageName` field is missing.
  - **Steps**:
    1. Call the `createOpportunity` method with `null` as the `StageName`.
    2. Verify that an `AuraHandledException` is thrown with the appropriate error message.
    3. Assert that no `Opportunity` records are created.

- **testCreateOpportunityMissingAmount**
  - **Purpose**: Validates error handling when the `Amount` field is missing.
  - **Steps**:
    1. Call the `createOpportunity` method with `null` as the `Amount`.
    2. Verify that an `AuraHandledException` is thrown with the appropriate error message.
    3. Assert that no `Opportunity` records are created.

- **testCreateOpportunityMissingCloseDate**
  - **Purpose**: Validates error handling when the `CloseDate` field is missing.
  - **Steps**:
    1. Call the `createOpportunity` method with `null` as the `CloseDate`.
    2. Verify that an `AuraHandledException` is thrown with the appropriate error message.
    3. Assert that no `Opportunity` records are created.

- **testGetUrgentOpportunities**
  - **Purpose**: Validates successful retrieval of urgent opportunities.
  - **Steps**:
    1. Create sample `Opportunity` records marked as `Urgent__c = true`.
    2. Call the `getUrgentOpportunities` method with valid parameters.
    3. Assert the correct number of records is returned and sorted by `CloseDate` in ascending order.

- **testGetUrgentOpportunitiesException**
  - **Purpose**: Tests error handling when the `getUrgentOpportunities` method encounters a failure.
  - **Steps**:
    1. Pass invalid parameters to cause a query failure.
    2. Assert that an `AuraHandledException` is thrown with the appropriate error message.

---

## **2. ErrorHandlerTest.cls**
### **Purpose**
Tests the `ErrorHandler` class to ensure exceptions are logged correctly in the `ErrorLog__c` custom object.

### **Test Methods**

- **testLogException**
  - **Purpose**: Validates that exceptions are logged correctly in the `ErrorLog__c` object.
  - **Steps**:
    1. Call the `ErrorHandler.logException` method with a sample exception.
    2. Query the `ErrorLog__c` object.
    3. Assert that the log contains accurate details, including class name, method name, and stack trace.

---

## **3. UrgentOpportunityHandlerTest.cls**
### **Purpose**
Tests the `UrgentOpportunityHandler` class to validate its logic for handling urgent opportunities.

### **Test Methods**

- **testHandleAfterInsert**
  - **Purpose**: Validates successful handling of urgent opportunities after insert.
  - **Steps**:
    1. Create valid `Opportunity` records marked as `Urgent__c = true`.
    2. Call the `handleAfterInsert` method.
    3. Assert that notifications and emails are sent correctly.

- **testHandleAfterInsertWithError**
  - **Purpose**: Tests error handling when an invalid opportunity is processed.
  - **Steps**:
    1. Create an `Opportunity` record missing the `AccountId` field.
    2. Call the `handleAfterInsert` method.
    3. Verify that an exception is logged and contains the appropriate error message.

- **testEmailSendingFailure**
  - **Purpose**: Validates error handling when email sending fails.
  - **Steps**:
    1. Simulate an email sending failure by deactivating the email template.
    2. Call the `handleAfterInsert` method.
    3. Assert that an exception is logged with the appropriate error message.

---

## **Test Coverage Summary**
| Class Name                           | Coverage Percentage |
|--------------------------------------|----------------------|
| UrgentOpportunitiesController        | 92%                 |
| ErrorHandler                         | 100%                 |
| UrgentOpportunityNotification        | 100%                |
| UrgentOpportunityHandler             | 96%                 |

---

## **Notes**
1. The test classes leverage `Test.startTest()` and `Test.stopTest()` for simulating execution environments effectively.
2. Error handling is validated using the `ErrorLog__c` custom object to ensure accurate logging.
3. Both positive and negative scenarios are thoroughly tested to ensure robustness.
4. Tests are designed to respect governor limits by using minimal mock data and batch operations where applicable.
