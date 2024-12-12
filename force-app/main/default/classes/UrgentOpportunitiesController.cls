
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
        String query = 'SELECT Id, Name, Amount, StageName, CloseDate FROM Opportunity WHERE Urgent__c = true';

        // Filtrare după AccountId
        if (!String.isBlank(accountId)) {
            query += ' AND AccountId = :accountId';
        }

        if (!String.isBlank(searchKey)) {
            query += ' AND Name LIKE \'%' + String.escapeSingleQuotes(searchKey) + '%\'';
        }

        query += ' ORDER BY CloseDate ASC LIMIT :limitValue OFFSET :offsetValue';
        return Database.query(query);
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
    @future
    public static void createOpportunityAsync(Id accountId, String name, String stageName, Decimal amount, Date closeDate) {
        Opportunity newOpportunity = new Opportunity(
            AccountId = accountId,
            Name = name,
            StageName = stageName,
            Amount = amount,
            CloseDate = closeDate,
            Urgent__c = true
        );
        insert newOpportunity;
    }
    
}
