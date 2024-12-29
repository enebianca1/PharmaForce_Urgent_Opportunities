# Documentation for Ticket ONBD-36: Develop Urgent Opportunities Datatable Component with Search and Pagination

## Overview
The `Urgent Opportunities` component provides a paginated and searchable datatable for urgent opportunities linked to a specific account. It enhances user experience by enabling streamlined data visualization, searching, and creation of urgent opportunities.

---

## Features Implemented

### 1. **Search Functionality**
   - Allows users to filter opportunities by name.
   - Dynamically updates the datatable based on the search input.

### 2. **Pagination**
   - Enables navigation through large datasets using Previous and Next buttons.
   - Displays the current page and total pages for better usability.

### 3. **Hyperlinked Opportunity Names**
   - Opportunity names in the datatable are clickable links.
   - Redirect users to the opportunity's detail page in Salesforce.

### 4. **New Opportunity Modal**
   - Triggered by the "New Opportunity" button.
   - Allows users to input opportunity details:
     - Name
     - Stage
     - Amount
     - Close Date
   - Automatically links the new opportunity to the current account and flags it as urgent.

---

## Implementation Details

### **Apex Controller: `UrgentOpportunitiesController`**

#### Methods:

1. **`getUrgentOpportunities`**:
   - Retrieves urgent opportunities based on:
     - **Account ID**: Ensures only opportunities linked to the specified account are fetched.
     - **Search Keyword**: Filters opportunities by name using partial matching.
     - **Pagination**: Implements LIMIT and OFFSET to handle large datasets.
   - Returns a map with:
     - A list of urgent opportunities.
     - The total count of matching opportunities for pagination.

2. **`createOpportunity`**:
   - Creates a new urgent opportunity synchronously.
   - Accepts parameters: Account ID, Name, Stage, Amount, and Close Date.
   - Validates input fields and handles exceptions using `ErrorHandler`.

---

### **Lightning Web Component: `UrgentOpportunitiesTable`**

#### Key Features:

1. **Dynamic Datatable**:
   - Displays columns: Name, Amount, Stage, and Close Date.
   - The Name column contains hyperlinks to the opportunity detail page.

2. **Search Input**:
   - Allows users to filter displayed opportunities based on the entered keyword.
   - Triggers a server-side fetch for updated data.

3. **Pagination Controls**:
   - Implements Previous and Next buttons to navigate through pages.
   - Displays the current page and total pages for user reference.

4. **New Opportunity Modal**:
   - Opens when the "New Opportunity" button is clicked.
   - Allows users to input details and submit the form.
   - Creates a new urgent opportunity linked to the current account.

---

## Testing

### 1. **Linked Opportunities**
   - Verified that only urgent opportunities associated with the current account are displayed.

### 2. **Search**
   - Tested filtering functionality with various keywords to ensure accurate results.

### 3. **Pagination**
   - Validated navigation through multiple pages of data.
   - Ensured accurate display of current page and total pages.

### 4. **Clickable Names**
   - Confirmed that clicking an opportunity name redirects to the correct opportunity detail page.

### 5. **New Opportunity Creation**
   - Tested the modal for entering and submitting opportunity details.
   - Verified that:
     - Newly created opportunities are flagged as urgent.
     - They are correctly linked to the current account.


