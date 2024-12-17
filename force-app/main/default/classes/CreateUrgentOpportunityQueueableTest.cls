@isTest
public class CreateUrgentOpportunityQueueableTest {
    @isTest
    static void testExecute() {
        // Creează date de test
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        // Creează jobul Queueable
        CreateUrgentOpportunityQueueable job = new CreateUrgentOpportunityQueueable(
            testAccount.Id, 'Test Opportunity', 'Prospecting', 1000, Date.today()
        );

        Test.startTest();
        System.enqueueJob(job); // Rulează jobul asincron
        Test.stopTest();

        // Verifică dacă oportunitatea a fost creată
        List<Opportunity> opps = [SELECT Id, Name, StageName FROM Opportunity WHERE AccountId = :testAccount.Id];
        System.assert(opps.size() == 1, 'Opportunity was not created');
        System.assertEquals('Test Opportunity', opps[0].Name);
    }

    @isTest
    static void testExecuteWithError() {
        // Creează jobul Queueable cu un AccountId invalid
        CreateUrgentOpportunityQueueable job = new CreateUrgentOpportunityQueueable(
            null, 'Test Opportunity', 'Prospecting', 1000, Date.today()
        );

        Test.startTest();
        System.enqueueJob(job); // Rulează jobul asincron
        Test.stopTest();

        // Verifică dacă eroarea a fost logată
        List<Error_Log__c> logs = [SELECT Id, Message__c FROM Error_Log__c];
        System.assert(logs.size() > 0, 'Error was not logged');
    }
}
