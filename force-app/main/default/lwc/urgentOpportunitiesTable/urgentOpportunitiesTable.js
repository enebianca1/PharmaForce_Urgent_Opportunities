import { LightningElement, api, track } from 'lwc';
import getUrgentOpportunities from '@salesforce/apex/UrgentOpportunitiesController.getUrgentOpportunities';
import createOpportunityAsync from '@salesforce/apex/UrgentOpportunitiesController.createOpportunityAsync';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class UrgentOpportunitiesTable extends LightningElement {
    @api recordId; // ID-ul contului curent
    @track opportunities = [];
    @track searchKey = '';
    @track offsetValue = 0;
    @track limitValue = 10; // Numărul de înregistrări pe pagină
    @track showModal = false; // Track modal visibility
    @track newOpportunity = {}; // Track new opportunity fields

    columns = [
        {
            label: 'Name',
            fieldName: 'recordLink', // Use a custom field for navigation
            type: 'url', // URL type for clickable links
            typeAttributes: { label: { fieldName: 'Name' }, target: '_blank' }
        },
        { label: 'Amount', fieldName: 'Amount', type: 'currency' },
        { label: 'Stage', fieldName: 'StageName' },
        { label: 'Close Date', fieldName: 'CloseDate', type: 'date' }
    ];

    connectedCallback() {
        this.fetchOpportunities();
    }

    handleSearch(event) {
        this.searchKey = event.target.value;
        this.offsetValue = 0; // Resetează la prima pagină
        this.fetchOpportunities();
    }

    handlePrevious() {
        if (this.offsetValue >= this.limitValue) {
            this.offsetValue -= this.limitValue;
            this.fetchOpportunities();
        }
    }

 
    handleNext() {
        this.offsetValue += this.limitValue;
        this.fetchOpportunities();
    }


    fetchOpportunities() {
        getUrgentOpportunities({
            searchKey: this.searchKey,
            accountId: this.recordId,
            offsetValue: this.offsetValue,
            limitValue: this.limitValue
        })
            .then((result) => {
                this.opportunities = result.map((opp) => {
                    return {
                        ...opp,
                        recordLink: `/lightning/r/Opportunity/${opp.Id}/view` // Add record URL
                    };
                });
            })
            .catch((error) => {
                console.error('Error fetching urgent opportunities:', error);
            });
    }

    // Show the modal for creating new opportunities
    handleNewOpportunity() {
        this.newOpportunity = {}; // Reset the form
        this.showModal = true;
    }

    handleModalInputChange(event) {
        const field = event.target.name;
        this.newOpportunity[field] = event.target.value;
    }

    saveOpportunity() {
        createOpportunityAsync({
            accountId: this.recordId,
            name: this.newOpportunity.Name,
            stageName: this.newOpportunity.StageName,
            amount: this.newOpportunity.Amount,
            closeDate: this.newOpportunity.CloseDate
        })
        .then(() => {
            this.showModal = false;
            this.fetchOpportunities();
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Opportunity created successfully',
                    variant: 'success'
                })
            );
        })
        .catch((error) => {
            console.error(error);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Error creating opportunity',
                    variant: 'error'
                })
            );
        });
    }
    

    closeModal() {
        this.showModal = false; // Close modal
    }
    
}
