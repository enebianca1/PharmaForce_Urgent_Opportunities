public class CreateUrgentOpportunityQueueable implements Queueable {
    private Id accountId;
    private String name;
    private String stageName;
    private Decimal amount;
    private Date closeDate;

    public CreateUrgentOpportunityQueueable(Id accountId, String name, String stageName, Decimal amount, Date closeDate) {
        this.accountId = accountId;
        this.name = name;
        this.stageName = stageName;
        this.amount = amount;
        this.closeDate = closeDate;
    }

    public void execute(QueueableContext context) {
        try {
            Opportunity opp = new Opportunity();
            opp.AccountId = accountId;
            opp.Name = name;
            opp.StageName = stageName;
            opp.Amount = amount;
            opp.CloseDate = closeDate;
            opp.Urgent__c = true;

            insert opp;
        } catch (Exception ex) {
            ErrorHandler.logException(ex, 'CreateUrgentOpportunityQueueable', 'execute');
            
        }
    }
}
