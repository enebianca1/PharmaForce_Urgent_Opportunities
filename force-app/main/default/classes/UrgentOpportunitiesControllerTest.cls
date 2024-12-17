@isTest
public class UrgentOpportunitiesControllerTest {

    // Test pentru getUrgentOpportunities - succes, fără searchKey
    @isTest
    static void testGetUrgentOpportunitiesSuccess() {
        // Creează date de test
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Opportunity opp1 = new Opportunity(
            Name = 'Urgent Opportunity 1',
            StageName = 'Prospecting',
            Amount = 500,
            CloseDate = Date.today(),
            Urgent__c = true,
            AccountId = testAccount.Id
        );
        insert opp1;

        Test.startTest();
        List<Opportunity> results = UrgentOpportunitiesController.getUrgentOpportunities(
            '', // searchKey gol
            testAccount.Id, // AccountId valid
            0, // offset
            10 // limit
        );
        Test.stopTest();

        // Verificăm rezultatul
        System.assertEquals(1, results.size(), 'There should be one urgent opportunity returned');
        System.assertEquals('Urgent Opportunity 1', results[0].Name, 'Opportunity name mismatch');
    }

    // Test pentru getUrgentOpportunities - succes, cu searchKey
    @isTest
    static void testGetUrgentOpportunitiesWithSearchKey() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Opportunity opp1 = new Opportunity(
            Name = 'SearchKey Opportunity',
            StageName = 'Prospecting',
            Amount = 1000,
            CloseDate = Date.today(),
            Urgent__c = true,
            AccountId = testAccount.Id
        );
        insert opp1;

        Test.startTest();
        List<Opportunity> results = UrgentOpportunitiesController.getUrgentOpportunities(
            'SearchKey', // searchKey
            testAccount.Id,
            0,
            10
        );
        Test.stopTest();

        System.assertEquals(1, results.size(), 'Filter did not return expected results');
        System.assertEquals('SearchKey Opportunity', results[0].Name, 'Filtered opportunity name mismatch');
    }

    // Test pentru getUrgentOpportunities - exception
    @isTest
static void testGetUrgentOpportunitiesException() {
    Test.startTest();
    try {
        // Transmitem valori invalide pentru filtrul searchKey și offsetValue
        UrgentOpportunitiesController.getUrgentOpportunities(
            '\'', null, -1, 10 // Apostrof special și offset negativ
        );
        System.assert(false, 'An AuraHandledException should have been thrown');
    } catch (AuraHandledException ex) {
        // Verificăm mesajul excepției
        System.assertEquals('Error retrieving urgent opportunities.', ex.getMessage(), 
            'Incorrect exception message');
    }
    Test.stopTest();

    // Verificăm logarea erorii în Error_Log__c
    List<Error_Log__c> logs = [SELECT Message__c, ClassName__c, MethodName__c FROM Error_Log__c];
    System.assertEquals(1, logs.size(), 'Error should be logged');
    System.assertEquals('UrgentOpportunitiesController', logs[0].ClassName__c, 'ClassName mismatch in log');
    System.assertEquals('getUrgentOpportunities', logs[0].MethodName__c, 'MethodName mismatch in log');
    System.assert(logs[0].Message__c.contains('unexpected token'), 
        'Error log should capture query exception details');
}


    
    

    // Test pentru createOpportunityAsync - succes
    @isTest
    static void testCreateOpportunityAsyncSuccess() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Test.startTest();
        Boolean result = UrgentOpportunitiesController.createOpportunityAsync(
            testAccount.Id,
            'Test Opportunity',
            'Prospecting',
            2000,
            Date.today()
        );
        Test.stopTest();

        System.assert(result, 'Job should have been enqueued successfully');
    }

    // Test pentru createOpportunityAsync - eșec
    @isTest
    static void testCreateOpportunityAsyncFailure() {
        // 1. Creează date de test
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
    
        // 2. Apelează metoda cu stageName gol pentru a forța eșec
        Test.startTest();
        Boolean result = UrgentOpportunitiesController.createOpportunityAsync(
            testAccount.Id, 'Opportunity Failure', '', 1000, Date.today() // StageName gol
        );
        Test.stopTest();
    
        // 3. Verificăm dacă eroarea este logată
        List<Error_Log__c> logs = [SELECT Message__c FROM Error_Log__c];
        System.assertEquals(1, logs.size(), 'Error should be logged when Queueable job fails');
        System.assert(logs[0].Message__c.contains('REQUIRED_FIELD_MISSING'), 
            'Error log should indicate missing required fields');
    }
    

}