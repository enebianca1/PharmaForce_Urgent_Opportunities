# ONBD-38: Create Reports and Dashboards for Urgent Opportunities

## Purpose
To create a **Report** and a **Dashboard** for urgent opportunities and integrate them into the **Home Page** for enhanced visibility and prioritization.

---

## 1. Urgent Opportunities Report

### **Objective**
The report displays all opportunities flagged as **Urgent**, enabling users to focus on time-sensitive deals.

### **Configuration**
- **Report Type**: Opportunities
- **Filter**:
  - Field: `Urgent__c` (Custom Urgent Flag)
  - Condition: `Equals TRUE`
- **Columns Added**:
  - Opportunity Name  
  - Stage  
  - Amount  
  - Close Date  
  - Account Name  
  - Opportunity Owner  
- **Grouping**:
  - By **Stage** (e.g., Prospecting, Negotiation, Closed Won)
- **Summarization**:
  - SUM of **Amount**
- **Chart**:
  - **Bar Chart**
    - X-Axis: Stage  
    - Y-Axis: Record Count
- **Folder**:
  - Saved in **Public Reports**.

---

## 2. Urgent Opportunities Dashboard

### **Objective**
The dashboard provides a visual representation of urgent opportunities to facilitate quick decision-making.

### **Components**
1. **Top 5 Urgent Opportunities**:
   - **Type**: Table Component
   - **Source**: Urgent Opportunities Report
   - **Sort Order**: Descending by Amount

2. **Total Opportunity Amount**:
   - **Type**: Metric Component
   - **Source**: Urgent Opportunities Report
   - **Field**: SUM(Amount)

3. **Opportunities by Stage**:
   - **Type**: Bar Chart
   - **Grouping**: Stage
   - **Y-Axis**: Record Count

4. **Recent Records**:
   - Displays recently updated urgent opportunities.

---

## 3. Custom Home Page Integration

### **Objective**
To provide a single pane of glass for urgent opportunities data on the PharmaForce app's **Home Page**.

### **Configuration**
- Created a **Custom Home Page** named **"Custom Urgent Opportunities Home Page"** using the **Lightning App Builder**.
- Added the following components:
  - **Urgent Opportunities Dashboard**
  - **Top 5 Urgent Opportunities Table**
  - **Total Opportunity Amount Metric**
  - **Recent Records**

### **Activation**
- Set the **Custom Home Page** as the **App Default** for the PharmaForce app.

---

## 4. Benefits

### **For Sales Teams**:
- Quickly identify opportunities that require immediate attention.  
- Focus on high-priority and high-value deals.  

### **For Sales Managers**:
- Monitor team performance and track opportunities by stage.  
- Gain insights into the total revenue impact of urgent opportunities.  

### **For Executives**:
- Obtain a high-level overview of critical opportunities and their status.

---

## Final Outcome
1. **Urgent Opportunities Report** provides filtered and summarized data on urgent deals.
2. **Urgent Opportunities Dashboard** visualizes key metrics and prioritizes high-value opportunities.
3. **Custom Home Page** integrates all components for easy access and improved productivity.

---

## Testing and Verification
- Verified that the report displays **only urgent opportunities**.  
- Confirmed that the dashboard reflects accurate and up-to-date metrics.  
- Ensured the Home Page appears as the default for the PharmaForce app.

