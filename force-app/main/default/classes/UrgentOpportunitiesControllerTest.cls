@isTest
public class UrgentOpportunitiesControllerTest {
    
    private static void makeData() {
        Account testAccount = new Account(
            Name = 'Test Account'
        );
        insert testAccount;
        
        List<Opportunity> opportunities = new List<Opportunity>();
        for (Integer i = 1; i <= 5; i++) {
            opportunities.add(new Opportunity(
                AccountId = testAccount.Id,
                Name = 'Urgent Opportunity ' + i, 
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(i),
                Amount = 1000 * i,
                Urgent__c = true 
            ));
        }
        insert opportunities;
    }
    
    @isTest
    static void testGetUrgentOpportunities() {
        makeData();
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        Test.startTest();
        
        Map<String, Object> result = UrgentOpportunitiesController.getUrgentOpportunities(
            'Urgent', 
            testAccount.Id, 
            0, 
            3
        );
        Test.stopTest();

        List<Opportunity> opportunities = (List<Opportunity>) result.get('opportunities');
        Integer totalCount = (Integer) result.get('totalCount');

        Assert.areEqual(3, opportunities.size(), 'Expected 3 urgent opportunities returned.');
        Assert.areEqual(5, totalCount, 'Expected total count of urgent opportunities to be 5.');
        Assert.areEqual('Urgent Opportunity 1', opportunities[0].Name, 'Expected the first opportunity to be sorted by CloseDate ASC.');
    }

    @isTest
    static void testGetUrgentOpportunitiesException() {
        makeData();
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];

        Test.startTest();
        try {
            UrgentOpportunitiesController.getUrgentOpportunities(
                'Urgent', 
                testAccount.Id, 
                0, 
                -1 
            );
            Assert.fail('Expected an exception to be thrown.');
        } catch (Exception e) {
            Assert.isTrue(e != null, 'Exception successfully caught.');
        }
        Test.stopTest();
    }

    @isTest
    static void testCreateOpportunity() {
        makeData();
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        
        Test.startTest();
        Boolean isSuccess = UrgentOpportunitiesController.createOpportunity(
            testAccount.Id,
            'New Urgent Opportunity',
            'Negotiation',
            5000,
            Date.today().addDays(10)
        );
        Test.stopTest();
    
        Assert.isTrue(isSuccess, 'Expected the opportunity creation to be successful.');
    
        Opportunity insertedOpp = [SELECT Name, StageName, Amount, CloseDate, Urgent__c 
                                   FROM Opportunity 
                                   WHERE Name = 'New Urgent Opportunity' LIMIT 1];
    
        Assert.areEqual('New Urgent Opportunity', insertedOpp.Name, 'Opportunity Name mismatch.');
        Assert.areEqual('Negotiation', insertedOpp.StageName, 'StageName mismatch.');
        Assert.areEqual(5000, insertedOpp.Amount, 'Amount mismatch.');
        Assert.areEqual(Date.today().addDays(10), insertedOpp.CloseDate, 'CloseDate mismatch.');
        Assert.areEqual(true, insertedOpp.Urgent__c, 'Urgent flag mismatch.');
    }

    @isTest
    static void testCreateOpportunityMissingName() {
        makeData();
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];

        Test.startTest();
        try {
            UrgentOpportunitiesController.createOpportunity(
                testAccount.Id,
                null, 
                'Prospecting',
                3000,
                Date.today()
            );
            Assert.fail('Expected AuraHandledException for missing Name.');
        } catch (AuraHandledException e) {
            Assert.areEqual('Opportunity Name is required.', e.getMessage(), 'Incorrect exception message for missing Name.');
        }
        Test.stopTest();
    }

    @isTest
    static void testCreateOpportunityMissingStageName() {
        makeData();
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];

        Test.startTest();
        try {
            UrgentOpportunitiesController.createOpportunity(
                testAccount.Id,
                'Test Opportunity',
                null, 
                3000,
                Date.today()
            );
            Assert.fail('Expected AuraHandledException for missing StageName.');
        } catch (AuraHandledException e) {
            Assert.areEqual('Stage Name is required.', e.getMessage(), 'Incorrect exception message for missing StageName.');
        }
        Test.stopTest();
    }

    @isTest
    static void testCreateOpportunityMissingAmount() {
        makeData();
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];

        Test.startTest();
        try {
            UrgentOpportunitiesController.createOpportunity(
                testAccount.Id,
                'Test Opportunity',
                'Prospecting',
                null, 
                Date.today()
            );
            Assert.fail('Expected AuraHandledException for missing Amount.');
        } catch (AuraHandledException e) {
            Assert.areEqual('Amount is required.', e.getMessage(), 'Incorrect exception message for missing Amount.');
        }
        Test.stopTest();
    }

    @isTest
    static void testCreateOpportunityMissingCloseDate() {
        makeData();
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];

        Test.startTest();
        try {
            UrgentOpportunitiesController.createOpportunity(
                testAccount.Id,
                'Test Opportunity',
                'Prospecting',
                3000,
                null 
            );
            Assert.fail('Expected AuraHandledException for missing CloseDate.');
        } catch (AuraHandledException e) {
            Assert.areEqual('Close Date is required.', e.getMessage(), 'Incorrect exception message for missing CloseDate.');
        }
        Test.stopTest();
    }
}
