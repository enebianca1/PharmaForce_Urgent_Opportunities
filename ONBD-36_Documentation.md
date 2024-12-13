# Documentation for Ticket ONBD-36: Develop Urgent Opportunities Datatable Component with Search and Pagination

## Overview
The `Urgent Opportunities` component provides a paginated and searchable datatable for urgent opportunities linked to a specific account.

### Features Implemented:
- Search functionality for filtering opportunities.
- Pagination to handle large data sets.
- Hyperlinked opportunity names that redirect to the opportunity details page.
- New Opportunity Button:
Opens a modal to input opportunity details (Name, Stage, Amount, Close Date).
Automatically links the new opportunity to the current account and flags it as urgent.

#### Apex Controller
The `UrgentOpportunitiesController`  handles:
- getUrgentOpportunities Method:
Retrieves urgent opportunities with filters for:
Account ID: Ensures only opportunities linked to the current account are fetched.
Search Keyword: Filters opportunities by name based on the provided input.
Pagination: Implements pagination using LIMIT and OFFSET.

- createOpportunityAsync Method:
Creates a new urgent opportunity asynchronously.
Accepts account ID and opportunity details (Name, Stage, Amount, Close Date) as parameters.

#### Lightning Web Component (LWC)
The `UrgentOpportunitiesTable` LWC handles:
- Dynamic Datatable Creation:
Displays Name, Amount, Stage, and Close Date.
The Name column contains clickable links to the opportunity detail page.
- Search Input:
Filters the displayed opportunities based on the entered keyword.
- Pagination:
Uses Previous and Next buttons to navigate through paginated records.
- New Opportunity Modal:
Triggered by the New Opportunity button.
Accepts opportunity details and creates a new urgent opportunity upon saving.

### Testing
1. Linked Opportunities: Verified that only urgent opportunities linked to the current account are displayed.
2.  Search: Tested filtering functionality with various keywords.
3. Pagination: Confirmed correct navigation through multiple pages of data.
4. Clickable Names: Validated that clicking an opportunity name redirects to its detail page.
5. New Opportunity Creation:
Tested modal functionality and data submission.
Verified that newly created opportunities are linked to the account and flagged as urgent.

---
