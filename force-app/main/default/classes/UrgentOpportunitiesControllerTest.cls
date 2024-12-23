@isTest
public class UrgentOpportunitiesControllerTest {

    // Test pentru getUrgentOpportunities - succes, fără searchKey
    @isTest
    static void testGetUrgentOpportunitiesSuccess() {
        // Create test data
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
        // Adjust to handle Map<String, Object>
        Map<String, Object> result = UrgentOpportunitiesController.getUrgentOpportunities(
            '', // searchKey empty
            testAccount.Id, // valid AccountId
            0, // offset
            10 // limit
        );
        Test.stopTest();
    
        // Extract the opportunities list from the result
        List<Opportunity> opportunities = (List<Opportunity>) result.get('opportunities');
        Integer totalCount = (Integer) result.get('totalCount');
    
        // Assertions
        System.assertEquals(1, opportunities.size(), 'There should be one urgent opportunity returned');
        System.assertEquals('Urgent Opportunity 1', opportunities[0].Name, 'Opportunity name mismatch');
        System.assertEquals(1, totalCount, 'Total count should match the number of records created');
    }
    
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
        // Adjust to handle Map<String, Object>
        Map<String, Object> result = UrgentOpportunitiesController.getUrgentOpportunities(
            'SearchKey', // searchKey
            testAccount.Id,
            0,
            10
        );
        Test.stopTest();
    
        // Extract the opportunities list from the result
        List<Opportunity> opportunities = (List<Opportunity>) result.get('opportunities');
        Integer totalCount = (Integer) result.get('totalCount');
    
        // Assertions
        System.assertEquals(1, opportunities.size(), 'Filter did not return expected results');
        System.assertEquals('SearchKey Opportunity', opportunities[0].Name, 'Filtered opportunity name mismatch');
        System.assertEquals(1, totalCount, 'Total count should match the number of records created');
    }

    // Test pentru getUrgentOpportunities - exception
    @isTest
static void testGetUrgentOpportunitiesException() {
    Test.startTest();
    try {
        // Transmitem valori invalide pentru filtrul searchKey și offsetValue
        UrgentOpportunitiesController.getUrgentOpportunities(
            null, null, -1, 10 // Apostrof special și offset negativ
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


     // Test pentru createOpportunity - succes
     @isTest
     static void testCreateOpportunitySuccess() {
         Account testAccount = new Account(Name = 'Test Account');
         insert testAccount;
 
         Test.startTest();
         Opportunity result = UrgentOpportunitiesController.createOpportunity(
             testAccount.Id,
             'Test Opportunity',
             'Prospecting',
             2000,
             Date.today()
         );
         Test.stopTest();
 
         System.assertNotEquals(null, result, 'Opportunity should be created successfully');
         System.assertEquals('Test Opportunity', result.Name, 'Opportunity Name should match');
         System.assertEquals('Prospecting', result.StageName, 'StageName should match');
     }
 
     // Test pentru createOpportunity - eșec
     @isTest
     static void testCreateOpportunityFailure() {
         Account testAccount = new Account(Name = 'Test Account');
         insert testAccount;
 
         Test.startTest();
         try {
             Opportunity result = UrgentOpportunitiesController.createOpportunity(
                 testAccount.Id, 'Opportunity Failure', '', 1000, Date.today() // StageName gol
             );
             System.assert(false, 'Expected an exception for missing StageName');
         } catch (AuraHandledException e) {
             System.assertEquals('All fields are required.', e.getMessage(), 'Error message should match the validation error');
         }
         Test.stopTest();
     }
    



}
