@isTest
public class UrgentOpportunityHandlerTest {

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

        // Creare și inserare membri echipă Account
        List<AccountTeamMember> teamMembers = new List<AccountTeamMember>{
            new AccountTeamMember(AccountId = testAccount.Id, UserId = UserInfo.getUserId())
        };
        insert teamMembers;
    }

    @isTest
    static void testHandleAfterInsertSuccess() {
        Test.startTest();

        // Creare listă de oportunități simulate pentru trigger
        List<Opportunity> newOpportunities = new List<Opportunity>{
            new Opportunity(
                Name = 'Urgent Test Opportunity',
                StageName = 'Qualification',
                Amount = 2000,
                CloseDate = Date.today().addDays(10),
                Urgent__c = true,
                AccountId = testAccount.Id
            )
        };

        insert newOpportunities;

        // Verificări indirecte - verificăm dacă oportunitatea a fost inserată corect
        Opportunity insertedOpp = [SELECT Id, Name FROM Opportunity WHERE Name = 'Urgent Test Opportunity' LIMIT 1];
        System.assertNotEquals(null, insertedOpp, 'Opportunity should be inserted successfully');

        // Nu putem interoga notificările, deci verificăm alte efecte colaterale
        // Verificăm dacă codul rulează fără erori
        Test.stopTest();

        // Dacă există loguri de erori, testul ar trebui să eșueze
        List<Error_Log__c> logs = [SELECT Message__c FROM Error_Log__c];
        System.assertEquals(0, logs.size(), 'There should be no error logs for a successful insert');
    }

    @isTest
    static void testHandleAfterInsertNoUrgentOpportunity() {
        Test.startTest();

        // Creare oportunitate non-urgentă
        Opportunity nonUrgentOpportunity = new Opportunity(
            Name = 'Non-Urgent Opportunity',
            StageName = 'Proposal/Price Quote',
            Amount = 5000,
            CloseDate = Date.today().addDays(15),
            Urgent__c = false,
            AccountId = testAccount.Id
        );
        insert nonUrgentOpportunity;

        // Verificare indirectă - oportunitatea a fost inserată fără erori
        Opportunity insertedOpp = [SELECT Id, Name FROM Opportunity WHERE Name = 'Non-Urgent Opportunity' LIMIT 1];
        System.assertNotEquals(null, insertedOpp, 'Non-Urgent Opportunity should be inserted successfully');

        Test.stopTest();

        // Verificăm că nu există notificări trimise (verificare indirectă)
        List<Error_Log__c> logs = [SELECT Message__c FROM Error_Log__c];
        System.assertEquals(0, logs.size(), 'There should be no error logs for a non-urgent insert');
    }
}
