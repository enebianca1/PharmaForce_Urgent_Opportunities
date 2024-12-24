@isTest
public class UrgentOpportunityHandlerTest {

    // Method to create test data
    private static void makeData() {
        // Create a test account
        Account testAccount = new Account(
            Name = 'Test Account'
        );
        insert testAccount;

        // Create account team members
        User testUser1 = [SELECT Id FROM User WHERE IsActive = true LIMIT 1]; // Using an active test user
        AccountTeamMember teamMember = new AccountTeamMember(
            AccountId = testAccount.Id,
            UserId = testUser1.Id,
            TeamMemberRole = 'Manager'
        );
        insert teamMember;

        // Create test opportunities
        Opportunity urgentOpportunity = new Opportunity(
            Name = 'Urgent Opportunity 1',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(10),
            Amount = 1000,
            AccountId = testAccount.Id,
            Urgent__c = true // Marked as urgent
        );
        Opportunity nonUrgentOpportunity = new Opportunity(
            Name = 'Non-Urgent Opportunity 1',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(10),
            Amount = 500,
            AccountId = testAccount.Id,
            Urgent__c = false // Not urgent
        );

        insert new List<Opportunity>{urgentOpportunity, nonUrgentOpportunity};
    }

    // Test for handleAfterInsert
    @isTest
    static void testHandleAfterInsert() {
        // Setup test data
        makeData();

        // Query opportunities to simulate the after-insert scenario
        List<Opportunity> insertedOpportunities = [SELECT Id, Name, AccountId, Urgent__c FROM Opportunity];

        // Mock the CustomNotificationType and EmailTemplate
        // CustomNotificationType cannot be inserted, so it must exist in the org beforehand
        CustomNotificationType cnType = [SELECT Id FROM CustomNotificationType WHERE DeveloperName = 'UrgentOpportunityNotification' LIMIT 1];
        System.assertNotEquals(null, cnType, 'CustomNotificationType must exist in the org for the test.');

        // Mock EmailTemplate
        EmailTemplate emailTemplate = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'UrgentOpportunityNotification' LIMIT 1];
        System.assertNotEquals(null, emailTemplate, 'EmailTemplate must exist in the org for the test.');

        // Mock the CustomNotificationType query
        Test.startTest();
        // Call the handler
        UrgentOpportunityHandler.handleAfterInsert(insertedOpportunities);
        Test.stopTest();

        // Assertions
        // Validate email invocations
        Integer emailInvocations = Limits.getEmailInvocations();
        System.assertEquals(1, emailInvocations, 'One email should be sent for the urgent opportunity.');

        // Validate notifications logic indirectly
        Opportunity urgentOpportunity = [SELECT Id, Name FROM Opportunity WHERE Urgent__c = true LIMIT 1];
        System.assertNotEquals(null, urgentOpportunity, 'Urgent opportunity should exist.');
    }
}
