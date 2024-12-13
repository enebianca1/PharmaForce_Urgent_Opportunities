# ONBD-34: Implement Notifications for Urgent Opportunities

## Introduction
The goal of this task was to implement notifications for urgent opportunities in Salesforce. By leveraging both custom notifications and email alerts, users are informed in real-time about newly created urgent opportunities. This functionality improves team communication and enhances the efficiency of managing critical accounts and opportunities.

---

## Custom Notifications

### Description
Custom notifications allow direct alerts to be displayed to users within the Salesforce app, accessible from the notification bell icon. These notifications are sent to the user who created the urgent opportunity and to the account team members associated with it.

### Implementation
A custom notification type, named `UrgentOpportunityNotification`, was created under **Notification Builder** in Salesforce Setup. 

A trigger was implemented to send these notifications:
- The creator of the opportunity receives a notification with the details.
- Other account team members also receive a notification to keep them informed of new developments.

These notifications improve collaboration and ensure timely updates for all stakeholders.

---

## Email Notifications

### Description
Email notifications provide an additional layer of communication, ensuring users are informed even if they are not actively logged into Salesforce. Emails are sent to users involved with the urgent opportunity.

### Implementation
A **Classic Email Template** was created to standardize the content of the email notifications. The template includes essential details such as the opportunity name, amount, and closing date.

The trigger logic was extended to:
- Send an email to the creator of the opportunity.
- Notify other relevant users via email with the same details.

This ensures important updates reach the intended audience promptly and effectively.

---

## Trigger Workflow

### Functionality
The trigger executes after an opportunity is inserted:
1. It checks if the opportunity is marked as urgent.
2. Custom notifications are created and sent to relevant users.
3. Email notifications are triggered for the creator and account team members.

This automated workflow ensures a seamless process for notifying all stakeholders about critical opportunities.

---

## Testing and Validation

### Methodology
The functionality was thoroughly tested by:
- Creating multiple urgent opportunities.
- Verifying the receipt of custom notifications in the app's notification center.
- Confirming email notifications were delivered to the appropriate recipients.

### Results
Both notification types worked as expected. Custom notifications appeared in the Salesforce notification bell, and email alerts were received with accurate details.

---
