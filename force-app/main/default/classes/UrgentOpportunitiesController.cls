
public with sharing class UrgentOpportunitiesController {
/******************************************************************************************************************
* @author       : Bianca Ene
* @date         : 2024-12-11
* @description  : This method retrieves urgent opportunities linked to a specific account with support for search 
*                 filtering, pagination, and sorting by Close Date in ascending order. It returns both the list of 
*                 opportunities and the total count of matching records.
* @param        : String searchKey : A search keyword to filter opportunities by their names. Supports partial matching.
* @param        : String accountId : The unique identifier of the account for which opportunities are retrieved.
* @param        : Integer offsetValue : The starting index for retrieving records, used for pagination.
* @param        : Integer limitValue : The maximum number of records to retrieve per page.
* @return       : Map<String, Object> : A map containing two keys:
*                                        - 'opportunities': A list of urgent opportunities matching the criteria.
*                                        - 'totalCount': The total number of matching urgent opportunities.
******************************************************************************************************************/
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getUrgentOpportunities(String searchKey, String accountId, Integer offsetValue, Integer limitValue) {
        Map<String, Object> result = new Map<String, Object>();
        List<Opportunity> opportunities = new List<Opportunity>();
        Integer totalCount = 0;
    
        try {
            String baseQuery = 'SELECT Id, Name, Amount, StageName, CloseDate FROM Opportunity WHERE Urgent__c = true';
            if (!String.isBlank(accountId)) {
                baseQuery += ' AND AccountId = :accountId';
            }
            if (!String.isBlank(searchKey)) {
                baseQuery += ' AND Name LIKE \'%' + String.escapeSingleQuotes(searchKey) + '%\'';
            }
    
            totalCount = (Integer) [SELECT COUNT() FROM Opportunity WHERE Urgent__c = true AND AccountId = :accountId AND Name LIKE :('%' + searchKey + '%')];

            baseQuery += ' ORDER BY CloseDate ASC LIMIT :limitValue OFFSET :offsetValue';
            opportunities = Database.query(baseQuery);
    
        } catch (Exception ex) {
            ErrorHandler.logException(ex, 'UrgentOpportunitiesController', 'getUrgentOpportunities');
        }
    
        result.put('opportunities', opportunities);
        result.put('totalCount', totalCount);
    
        return result;
    }
    
    

/******************************************************************************************************************
* @author       : Bianca Ene
* @date         : 2024-12-11
* @description  : This method synchronously creates a new opportunity marked as urgent and associates it with 
*                 a specific account. It performs input validation to ensure all required fields are provided 
*                 and handles exceptions to ensure smooth error reporting.
* @param        : Id accountId : The ID of the account to which the opportunity will be linked.
* @param        : String name : The name of the opportunity to be created (required).
* @param        : String stageName : The stage of the opportunity (required).
* @param        : Decimal amount : The monetary value of the opportunity (required).
* @param        : Date closeDate : The expected close date of the opportunity (required).
* @return       : Boolean : Returns true if the opportunity is successfully created; otherwise, false.
******************************************************************************************************************/
@AuraEnabled
public static Boolean createOpportunity(Id accountId, String name, String stageName, Decimal amount, Date closeDate) {
    if (String.isBlank(name)) {
        throw new AuraHandledException('Opportunity Name is required.');
    }
    if (String.isBlank(stageName)) {
        throw new AuraHandledException('Stage Name is required.');
    }
    if (amount == null) {
        throw new AuraHandledException('Amount is required.');
    }
    if (closeDate == null) {
        throw new AuraHandledException('Close Date is required.');
    }

    try {
        Opportunity opp = new Opportunity(
            AccountId = accountId,
            Name = name,
            StageName = stageName,
            Amount = amount,
            CloseDate = closeDate,
            Urgent__c = true
        );
        insert opp;
        return true; 
    } catch (Exception ex) {
        ErrorHandler.logException(ex, 'UrgentOpportunitiesController', 'createOpportunity');
        return false; 
    }
}



}
