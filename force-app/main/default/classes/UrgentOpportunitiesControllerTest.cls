@isTest
public class UrgentOpportunitiesControllerTest {

    static Account testAccount;
    static Opportunity testOpportunity;

    @testSetup
    static void makeData() {
        // Creare și inserare Account
        testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        // Creare și inserare Opportunity
        testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Prospecting',
            Amount = 1000,
            CloseDate = Date.today(),
            Urgent__c = true,
            AccountId = testAccount.Id
        );
        insert testOpportunity;
    }

    @isTest
    static void testGetUrgentOpportunitiesSuccess() {
        Test.startTest();
        Map<String, Object> result = UrgentOpportunitiesController.getUrgentOpportunities(
            '', // Fără searchKey
            testAccount.Id, // ID valid de Account
            0, // Offset
            10 // Limită
        );
        Test.stopTest();

        List<Opportunity> opportunities = (List<Opportunity>) result.get('opportunities');
        Integer totalCount = (Integer) result.get('totalCount');

        System.assertEquals(1, opportunities.size(), 'There should be one urgent opportunity returned');
        System.assertEquals('Test Opportunity', opportunities[0].Name, 'Opportunity name mismatch');
        System.assertEquals(1, totalCount, 'Total count should match the number of records created');
    }

    @isTest
    static void testGetUrgentOpportunitiesWithSearchKey() {
        Test.startTest();
        Map<String, Object> result = UrgentOpportunitiesController.getUrgentOpportunities(
            'Test', // SearchKey
            testAccount.Id,
            0,
            10
        );
        Test.stopTest();

        List<Opportunity> opportunities = (List<Opportunity>) result.get('opportunities');
        Integer totalCount = (Integer) result.get('totalCount');

        System.assertEquals(1, opportunities.size(), 'Filter did not return expected results');
        System.assertEquals('Test Opportunity', opportunities[0].Name, 'Filtered opportunity name mismatch');
        System.assertEquals(1, totalCount, 'Total count should match the number of records created');
    }

    @isTest
    static void testGetUrgentOpportunitiesException() {
        Test.startTest();
        try {
            UrgentOpportunitiesController.getUrgentOpportunities(
                null, null, -1, 10 // Offset negativ
            );
            System.assert(false, 'An AuraHandledException should have been thrown');
        } catch (AuraHandledException ex) {
            System.assertEquals('Error retrieving urgent opportunities.', ex.getMessage(), 'Incorrect exception message');
        }
        Test.stopTest();

        List<Error_Log__c> logs = [SELECT Message__c, ClassName__c, MethodName__c FROM Error_Log__c];
        System.assertEquals(1, logs.size(), 'Error should be logged');
        System.assertEquals('UrgentOpportunitiesController', logs[0].ClassName__c, 'ClassName mismatch in log');
        System.assertEquals('getUrgentOpportunities', logs[0].MethodName__c, 'MethodName mismatch in log');
    }

    @isTest
    static void testCreateOpportunitySuccess() {
        Test.startTest();
        Opportunity result = UrgentOpportunitiesController.createOpportunity(
            testAccount.Id,
            'New Opportunity',
            'Qualification',
            2000,
            Date.today()
        );
        Test.stopTest();

        System.assertEquals('New Opportunity', result.Name, 'Opportunity Name should match');
        System.assertEquals('Qualification', result.StageName, 'StageName should match');
        System.assertEquals(2000, result.Amount, 'Opportunity Amount should match');
        System.assertEquals(Date.today(), result.CloseDate, 'Opportunity Close Date should match');
    }

    @isTest
    static void testCreateOpportunityFailure() {
        Test.startTest();
        try {
            UrgentOpportunitiesController.createOpportunity(
                testAccount.Id, '', 'Prospecting', 1000, Date.today() // Name gol
            );
            System.assert(false, 'Expected an exception for missing Name');
        } catch (AuraHandledException ex) {
            System.assertEquals('Opportunity Name is required.', ex.getMessage(), 'Error message should match validation error');
        }
        Test.stopTest();
    }
}
