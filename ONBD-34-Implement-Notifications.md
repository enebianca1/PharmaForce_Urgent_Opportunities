# ONBD-34: Implement Notifications for Urgent Opportunities

## Introduction
The goal of this task was to implement notifications for urgent opportunities in Salesforce. By leveraging both custom notifications and email alerts, users are informed in real-time about newly created urgent opportunities. This functionality improves team communication and enhances the efficiency of managing critical accounts and opportunities.

---

## Custom Notifications

### Description
Custom notifications allow direct alerts to be displayed to users within the Salesforce app, accessible from the notification bell icon. These notifications are sent to the user who created the urgent opportunity and to the account team members associated with it.

### Implementation
- A custom notification type, named `UrgentOpportunityNotification`, was created under **Notification Builder** in Salesforce Setup.
- An Apex Trigger was created to invoke a method in the `UrgentOpportunityHandler` class. This method contains the logic to:
  - Identify and process urgent opportunities.
  - Send notifications to the creator and account team members.

This approach ensures a clean separation of concerns, with the trigger delegating the processing logic to the handler class.

---

## Email Notifications

### Description
Email notifications provide an additional layer of communication, ensuring users are informed even if they are not actively logged into Salesforce. Emails are sent to users involved with the urgent opportunity.

### Implementation
- A **Classic Email Template** was created to standardize the content of email notifications. The template includes details such as:
  - Opportunity Name
  - Opportunity Amount
  - Closing Date
- The `UrgentOpportunityHandler` class handles email notification logic. The handler:
  - Sends an email to the creator of the opportunity.
  - Notifies other relevant users (e.g., account team members) via email with the same details.

This ensures that critical updates reach the intended audience promptly and effectively.

---

## Trigger Workflow

### Functionality
The trigger is designed to execute after an opportunity is inserted. Its role is to:
1. Check if the opportunity meets the criteria for being urgent.
2. Delegate processing to the `UrgentOpportunityHandler` class by calling its method.

This workflow ensures the trigger remains lightweight, while the handler class manages the notification logic.

---

## Testing and Validation

### Methodology
The functionality was thoroughly tested by:
- Creating multiple urgent opportunities.
- Verifying the receipt of custom notifications in the app's notification center.
- Confirming email notifications were delivered to the appropriate recipients.

### Results
- **Custom Notifications**: Appeared in the Salesforce notification bell for all intended users.
- **Email Alerts**: Delivered successfully to the correct recipients with accurate details.

---

## Conclusion
By delegating the logic to the `UrgentOpportunityHandler` class, the implementation ensures a clean and maintainable code structure. The combination of custom notifications and email alerts ensures timely updates and enhanced collaboration for managing urgent opportunities.
