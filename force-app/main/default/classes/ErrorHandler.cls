public with sharing class ErrorHandler {
    public static void logException(Exception ex, String className, String methodName) {
        System.debug('Step 1: Entered logException');
        try {
            Error_Log__c errorLog = new Error_Log__c();
            errorLog.ClassName__c = className;
            errorLog.MethodName__c = methodName;
            errorLog.Level__c = 'ERROR';
            errorLog.Message__c = ex.getMessage();
            errorLog.StackTrace__c = ex.getStackTraceString();

            System.debug('Step 2: Preparing to insert ErrorLog: ' + errorLog);
            insert errorLog;
            System.debug('Step 3: ErrorLog inserted successfully');
        } catch (Exception logEx) {
            System.debug('Step 4: Failed to insert ErrorLog: ' + logEx.getMessage());
        }
        System.debug('Step 5: Exiting logException');
    }
}

