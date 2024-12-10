# Permission Set and User Creation for ONBD-33

## Description
This document explains the steps to configure a custom Permission Set and create a User for the ONBD-33 ticket.

## Steps:
### Permission Set Creation
1. Navigate to **Setup > Permission Sets** in Salesforce.
2. Click **New** and fill in the following:
   - **Label**: PharmaForce Urgent Opps Admin.
   - **API Name**: PharmaForce_Urgent_Opps_Admin.
   - **Description**: Permission Set with necessary permissions for managing Urgent Opportunities.
3. Configure permissions:
   - Go to **Object Settings > Opportunity**.
   - Enable:
     - Read, Create, Edit, Delete, View All.
     - Field-level security: Read + Edit for `Urgent__c`.

### User Creation
1. Navigate to **Setup > Users > Users** in Salesforce.
2. Click **New User** and fill in the following:
   - **First Name**: John.
   - **Last Name**: Doe.
   - **Email/Username**: john.doe@example.com.
   - **Profile**: Standard User.
3. Save and assign the permission set created above.

## Testing
1. Log in as the user created to verify access.
2. Ensure the user can only access the apps, tabs, objects, and fields specified.

## Related Files
None.

