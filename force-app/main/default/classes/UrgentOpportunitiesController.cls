
public with sharing class UrgentOpportunitiesController {
    /******************************************************************************************************************
    * @author       : Bianca Ene
    * @date         : 2024-12-11
    * @description  : This method is used to retrieve a list of urgent opportunities linked to a specific account with pagination and search functionality.
    * @param        : String searchKey : The search keyword for filtering opportunities by name.
    * @param        : String accountId : The ID of the account to filter opportunities.
    * @param        : Integer offsetValue : The offset for pagination.
    * @param        : Integer limitValue : The limit of records to retrieve per page.
    * @return       : List<Opportunity> : A list of filtered and paginated urgent opportunities.
    ******************************************************************************************************************/
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getUrgentOpportunities(String searchKey, String accountId, Integer offsetValue, Integer limitValue) {
    List<Opportunity> opportunities = new List<Opportunity>();

    try {
        // Construirea query-ului
        String baseQuery = 'SELECT Id, Name, Amount, StageName, CloseDate FROM Opportunity WHERE Urgent__c = true';
        
        // Construirea filtrării după AccountId
        if (!String.isBlank(accountId)) {
            baseQuery += ' AND AccountId = :accountId';
        }

        // Adăugarea filtrului de căutare
        if (!String.isBlank(searchKey)) {
            baseQuery += ' AND Name LIKE \'%' + String.escapeSingleQuotes(searchKey) + '%\'';
        }

        baseQuery += ' ORDER BY CloseDate ASC LIMIT :limitValue OFFSET :offsetValue';

        // Executarea query-ului
        opportunities = Database.query(baseQuery);
    } catch (Exception ex) {
        // Loghează eroarea folosind ErrorHandler
        ErrorHandler.logException(ex, 'UrgentOpportunitiesController', 'getUrgentOpportunities');
        throw new AuraHandledException('Error retrieving urgent opportunities.');
    }
    return opportunities;
}


    /******************************************************************************************************************
* @author       : Bianca Ene
* @date         : 2024-12-11
* @description  : This method asynchronously creates a new urgent opportunity and links it to a specific account.
* @param        : Id accountId : The ID of the account to which the opportunity is linked.
* @param        : String name : The name of the opportunity to be created.
* @param        : String stageName : The stage of the opportunity.
* @param        : Decimal amount : The amount value of the opportunity.
* @param        : Date closeDate : The close date of the opportunity.
* @return       : void
******************************************************************************************************************/
@AuraEnabled
public static void createOpportunityAsync(Id accountId, String name, String stageName, Decimal amount, Date closeDate) {
    System.enqueueJob(new CreateUrgentOpportunityQueueable(accountId, name, stageName, amount, closeDate));
}

    
}
