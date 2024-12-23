trigger UrgentOpportunityNotification on Opportunity (after insert) {
    if (Trigger.isAfter && Trigger.isInsert) {
        UrgentOpportunityHandler.handleAfterInsert(Trigger.new);
    }
}
