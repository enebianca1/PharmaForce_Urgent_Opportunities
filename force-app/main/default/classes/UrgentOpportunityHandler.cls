public class UrgentOpportunityHandler {

    /******************************************************************************************************************
* @author       : Bianca Ene
* @date         : 2024-12-23
* @description  : This method handles the post-insert event for Opportunities marked as urgent. It sends custom 
*                 notifications to the opportunity creator and account team members, as well as email notifications 
*                 using a predefined email template. Notifications and emails are only sent for opportunities 
*                 associated with an account and flagged as urgent.
* @param        : List<Opportunity> opportunities : A list of opportunities that were recently inserted.
* @logic        : - Queries the custom notification type and email template needed for notifications and emails.
*                 - Identifies opportunities marked as urgent and their associated accounts.
*                 - Maps account team members to their respective accounts.
*                 - Sends custom notifications to the opportunity creator and account team members.
*                 - Sends email notifications to account team members using a predefined email template.
******************************************************************************************************************/
    public static void handleAfterInsert(List<Opportunity> opportunities) {
        CustomNotificationType cnType = [
            SELECT Id 
            FROM CustomNotificationType 
            WHERE DeveloperName = 'UrgentOpportunityNotification'
        ];

        EmailTemplate emailTemplate = [
            SELECT Id 
            FROM EmailTemplate 
            WHERE DeveloperName = 'UrgentOpportunityNotification'
        ];

        Set<Id> accountIds = new Set<Id>();
        for (Opportunity opp : opportunities) {
            if (opp.Urgent__c == true && opp.AccountId != null) {
                accountIds.add(opp.AccountId);
            }
        }

        Map<Id, List<AccountTeamMember>> accountTeamMap = new Map<Id, List<AccountTeamMember>>();
        for (AccountTeamMember member : [
            SELECT UserId, AccountId 
            FROM AccountTeamMember 
            WHERE AccountId IN :accountIds
        ]) {
            if (!accountTeamMap.containsKey(member.AccountId)) {
                accountTeamMap.put(member.AccountId, new List<AccountTeamMember>());
            }
            accountTeamMap.get(member.AccountId).add(member);
        }

        List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();

        for (Opportunity opp : opportunities) {
            if (opp.Urgent__c == true && opp.AccountId != null) { 
                Messaging.CustomNotification customNotificationObj = new Messaging.CustomNotification();
                customNotificationObj.setBody('You\'ve successfully created the ' + opp.Name + ' urgent opportunity.');
                customNotificationObj.setTitle('Urgent Opportunity Alert');
                customNotificationObj.setNotificationTypeId(cnType.Id);
                customNotificationObj.setSenderId(UserInfo.getUserId());
                customNotificationObj.setTargetId(opp.Id);

                customNotificationObj.send(new Set<String> {UserInfo.getUserId()});

                List<AccountTeamMember> teamMembers = accountTeamMap.get(opp.AccountId);

                if (teamMembers != null) {
                    for (AccountTeamMember member : teamMembers) {
                        Messaging.CustomNotification teamNotification = new Messaging.CustomNotification();
                        teamNotification.setBody('User ' + UserInfo.getName() + ' created a new urgent opportunity (' + opp.Name + ').');
                        teamNotification.setTitle('Urgent Opportunity Alert');
                        teamNotification.setNotificationTypeId(cnType.Id);
                        teamNotification.setSenderId(UserInfo.getUserId());
                        teamNotification.setTargetId(opp.Id);
                        teamNotification.send(new Set<String> {member.UserId});

                        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                        email.setTemplateId(emailTemplate.Id); 
                        email.setTargetObjectId(member.UserId); 
                        email.setSaveAsActivity(false); 
                        emailMessages.add(email);
                    }
                }
            }
        }

        if (!emailMessages.isEmpty()) {
            Messaging.sendEmail(emailMessages);
        }
    }
}

