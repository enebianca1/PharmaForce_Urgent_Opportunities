# Documentation for Ticket ONBD-36: Develop Urgent Opportunities Datatable Component with Search and Pagination

## Overview
The `Urgent Opportunities` component provides a paginated and searchable datatable for urgent opportunities linked to a specific account.

### Features Implemented:
- Search functionality for filtering opportunities.
- Pagination to handle large data sets.
- Hyperlinked opportunity names that redirect to the opportunity details page.

### Code Changes:
#### Apex Controller
The `UrgentOpportunitiesController` class retrieves urgent opportunities with filters for:
- Account ID (linked to the current account).
- Search keyword.
- Pagination using `LIMIT` and `OFFSET`.

#### Lightning Web Component (LWC)
The `UrgentOpportunitiesTable` LWC handles:
- Dynamic datatable creation.
- Search input for live filtering.
- Navigation for paginated records.
- URL links for opportunity records.

### Testing
1. Verified functionality on the `Account Record Page`.
2. Tested search and pagination with multiple opportunities linked to accounts.
3. Confirmed redirection links work as expected.

### Branch Details
- **Branch Name:** `feature/ONBD-36`
- **Purpose:** Implementation of urgent opportunities datatable with search and pagination.

---


