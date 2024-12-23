public with sharing class ErrorHandler {
    public static void logException(Exception ex, String className, String methodName) {
        Error_Log__c errorLog = new Error_Log__c();
        errorLog.ClassName__c = className;
        errorLog.MethodName__c = methodName;
        errorLog.Level__c = 'ERROR';
        errorLog.Message__c = ex.getMessage();
        errorLog.StackTrace__c = ex.getStackTraceString();

        insert errorLog;
    }
}