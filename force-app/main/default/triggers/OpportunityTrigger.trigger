trigger OpportunityTrigger on Opportunity (after insert) {
    try {
        for (Opportunity opp : Trigger.New) {
            // Cod pentru a simula o eroare validă
            Integer testValue = 1 / 0; // Declanșează excepția
           // System.debug('Test value: ' + testValue);
        }
    } catch (Exception ex) {
        // Loghează eroarea folosind ErrorHandler
        ErrorHandler.logException(ex, 'OpportunityTrigger', 'afterInsert');
    }
}
