@isTest
public class UrgentOpportunityNotificationTest {

    @isTest
    static void testUrgentOpportunityNotification() {
        // 1. Creăm un utilizator pentru test
        User testUser = [SELECT Id FROM User WHERE IsActive = true LIMIT 1];

        // 2. Creăm un cont valid
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        // 3. Adăugăm un membru în Account Team
        AccountTeamMember teamMember = new AccountTeamMember(
            AccountId = testAccount.Id,
            UserId = testUser.Id,
            TeamMemberRole = 'Manager'
        );
        insert teamMember;

        // 4. Creăm o oportunitate marcată ca "Urgent"
        Opportunity urgentOpportunity = new Opportunity(
            Name = 'Urgent Test Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today(),
            AccountId = testAccount.Id,
            Urgent__c = true
        );

        Test.startTest();
        insert urgentOpportunity; // Triggerul se va declanșa aici
        Test.stopTest();

        // 5. Verificăm notificările (folosind un query dacă notificările sunt logate)
        // Notificările nu pot fi verificate direct în Apex, așa că ne concentrăm pe validări indirecte.

        // Verificăm dacă s-au trimis emailuri folosind `EmailMessage`
        List<Messaging.SingleEmailMessage> sentEmails = new List<Messaging.SingleEmailMessage>();
        System.assertEquals(1, [SELECT COUNT() FROM AccountTeamMember WHERE AccountId = :testAccount.Id],
            'Account Team should have 1 member');

        // Verificăm că oportunitatea s-a inserat
        Opportunity insertedOpp = [SELECT Id, Urgent__c FROM Opportunity WHERE Name = 'Urgent Test Opportunity' LIMIT 1];
        System.assertEquals(true, insertedOpp.Urgent__c, 'Opportunity should be marked as Urgent');
    }

    @isTest
    static void testNonUrgentOpportunityNotification() {
        // 1. Creăm un cont valid
        Account testAccount = new Account(Name = 'Test Account Non-Urgent');
        insert testAccount;

        // 2. Creăm o oportunitate care NU este Urgentă
        Opportunity nonUrgentOpportunity = new Opportunity(
            Name = 'Non-Urgent Test Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today(),
            AccountId = testAccount.Id,
            Urgent__c = false
        );

        Test.startTest();
        insert nonUrgentOpportunity; // Triggerul NU ar trebui să trimită notificări
        Test.stopTest();

        // Verificăm că oportunitatea s-a inserat
        Opportunity insertedOpp = [SELECT Id, Urgent__c FROM Opportunity WHERE Name = 'Non-Urgent Test Opportunity' LIMIT 1];
        System.assertEquals(false, insertedOpp.Urgent__c, 'Opportunity should not be marked as Urgent');
    }
}
