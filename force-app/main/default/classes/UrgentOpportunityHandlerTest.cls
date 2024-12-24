@isTest
public class UrgentOpportunityHandlerTest {

    private static void makeData() {
        Account testAccount = new Account(
            Name = 'Test Account'
        );
        insert testAccount;

        User testUser1 = [SELECT Id FROM User WHERE IsActive = true LIMIT 1]; 
        AccountTeamMember teamMember = new AccountTeamMember(
            AccountId = testAccount.Id,
            UserId = testUser1.Id,
            TeamMemberRole = 'Manager'
        );
        insert teamMember;

        Opportunity urgentOpportunity = new Opportunity(
            Name = 'Urgent Opportunity 1',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(10),
            Amount = 1000,
            AccountId = testAccount.Id,
            Urgent__c = true 
        );
        Opportunity nonUrgentOpportunity = new Opportunity(
            Name = 'Non-Urgent Opportunity 1',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(10),
            Amount = 500,
            AccountId = testAccount.Id,
            Urgent__c = false 
        );

        insert new List<Opportunity>{urgentOpportunity, nonUrgentOpportunity};
    }

    @isTest
    static void testHandleAfterInsert() {
        makeData();
        List<Opportunity> insertedOpportunities = [SELECT Id, Name, AccountId, Urgent__c FROM Opportunity];

        CustomNotificationType cnType = [SELECT Id FROM CustomNotificationType WHERE DeveloperName = 'UrgentOpportunityNotification' LIMIT 1];
        System.assertNotEquals(null, cnType, 'CustomNotificationType must exist in the org for the test.');
        EmailTemplate emailTemplate = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'UrgentOpportunityNotification' LIMIT 1];
        System.assertNotEquals(null, emailTemplate, 'EmailTemplate must exist in the org for the test.');

        Test.startTest();
        UrgentOpportunityHandler.handleAfterInsert(insertedOpportunities);
        Test.stopTest();

        Integer emailInvocations = Limits.getEmailInvocations();
        System.assertEquals(1, emailInvocations, 'One email should be sent for the urgent opportunity.');

        Opportunity urgentOpportunity = [SELECT Id, Name FROM Opportunity WHERE Urgent__c = true LIMIT 1];
        System.assertNotEquals(null, urgentOpportunity, 'Urgent opportunity should exist.');
    }
}
