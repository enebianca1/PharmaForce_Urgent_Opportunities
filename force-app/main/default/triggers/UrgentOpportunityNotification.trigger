trigger UrgentOpportunityNotification on Opportunity (after insert) {
    // Fetch the custom notification type
    CustomNotificationType cnType = [
        SELECT Id 
        FROM CustomNotificationType 
        WHERE DeveloperName = 'UrgentOpportunityNotification'
    ];

    // Email Template ID 
    EmailTemplate emailTemplate = [
        SELECT Id 
        FROM EmailTemplate 
        WHERE DeveloperName = 'UrgentOpportunityNotification'
    ];

    for (Opportunity opp : Trigger.New) {
        // Check if the Opportunity is marked as "Urgent" and has an AccountId
        if (opp.Urgent__c == true && opp.AccountId != null) { 
            // Notify the current user (creator)
            Messaging.CustomNotification customNotificationObj = new Messaging.CustomNotification();
            customNotificationObj.setBody('You\'ve successfully created the ' + opp.Name + ' urgent opportunity.');
            customNotificationObj.setTitle('Urgent Opportunity Alert');
            customNotificationObj.setNotificationTypeId(cnType.Id);
            customNotificationObj.setSenderId(UserInfo.getUserId());
            customNotificationObj.setTargetId(opp.Id);

            // Send the notification to the current user
            customNotificationObj.send(new Set<String> {UserInfo.getUserId()});

            // Query Account Team Members for the associated Account
            List<AccountTeamMember> teamMembers = [
                SELECT UserId 
                FROM AccountTeamMember 
                WHERE AccountId = :opp.AccountId 
            ];

            // Prepare a list to hold email messages
            List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();

            // Notify other team members
            for (AccountTeamMember member : teamMembers) {
                // Send custom notification
                Messaging.CustomNotification teamNotification = new Messaging.CustomNotification();
                teamNotification.setBody('User ' + UserInfo.getName() + ' created a new urgent opportunity (' + opp.Name + ').');
                teamNotification.setTitle('Urgent Opportunity Alert');
                teamNotification.setNotificationTypeId(cnType.Id);
                teamNotification.setSenderId(UserInfo.getUserId());
                teamNotification.setTargetId(opp.Id);
                teamNotification.send(new Set<String> {member.UserId});

                // Send email notification
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setTemplateId(emailTemplate.Id); // Use the email template
                email.setTargetObjectId(member.UserId); // Send to the team member
               
                email.setSaveAsActivity(false); 
                emailMessages.add(email);
            }

            // Send all emails at once
            if (!emailMessages.isEmpty()) {
                Messaging.sendEmail(emailMessages);
            }
        }
    }
}