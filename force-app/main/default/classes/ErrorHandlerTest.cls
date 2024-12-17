@isTest
public class ErrorHandlerTest {
    @isTest
    static void testLogException() {
        try {
            Integer result = 1 / 0;
        } catch (Exception ex) {
            ErrorHandler.logException(ex, 'TestClass', 'testLogException');
        }

        List<Error_Log__c> logs = [SELECT Id, ClassName__c, MethodName__c FROM Error_Log__c];
        System.assert(logs.size() > 0, 'Log entry was not created');
    }
}
