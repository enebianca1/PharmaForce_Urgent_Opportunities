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
    @track stageOptions = [
        { label: 'Prospecting', value: 'Prospecting' },
        { label: 'Qualification', value: 'Qualification' },
        { label: 'Need Analysis', value: 'Need Analysis' },
        { label: 'Value Proposition', value: 'Value Proposition' },
        { label: 'Id. Decision Maker', value: 'Id. Decision Maker' },
        { label: 'Perception Analysis', value: 'Perception Analysis' },
        { label: 'Proposal/Price Quote', value: 'Proposal/Price Quote' },
        { label: 'Negotiation/Review', value: 'Negotiation/Review' },
        { label: 'Closed Won', value: 'Closed Won' },
        { label: 'Closed Lost', value: 'Closed Lost' }
    ];
    @track totalRecords = 0;
    @track currentPage = 1; 
    @track totalPages = 0; 
    
    // valori pt Stage name
    handleModalInputChange(event) {
        const field = event.target.name;
        const value = event.detail.value;
        this.newOpportunity[field] = value;
    }
    
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
        this.currentPage = 1;
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
                // Extrage oportunitățile din răspuns
                const opportunities = result.opportunities;
    
                // Creează un link pentru fiecare oportunitate
                this.opportunities = opportunities.map((opp) => {
                    return {
                        ...opp,
                        recordLink: `/lightning/r/Opportunity/${opp.Id}/view`
                    };
                });
    
                // Obține numărul total de înregistrări și calculează numărul total de pagini
                this.totalRecords = result.totalCount;
                this.totalPages = Math.ceil(this.totalRecords / this.limitValue);
            })
            .catch((error) => {
                console.error('Error fetching urgent opportunities:', error);
            });
    }
    

    handlePrevious() {
        if (this.currentPage > 1) {
            this.currentPage--;
            this.offsetValue = (this.currentPage - 1) * this.limitValue;
            this.fetchOpportunities();
        }
    }
    
    handleNext() {
        if (this.currentPage < this.totalPages) {
            this.currentPage++;
            this.offsetValue = (this.currentPage - 1) * this.limitValue;
            this.fetchOpportunities();
        }
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
        // Validăm câmpurile local
        if (!this.newOpportunity.Name || !this.newOpportunity.StageName || !this.newOpportunity.Amount || !this.newOpportunity.CloseDate) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'All fields are required.',
                    variant: 'error'
                })
            );
            return;
        }
    
        // Apelăm metoda Apex
        createOpportunityAsync({
            accountId: this.recordId,
            name: this.newOpportunity.Name,
            stageName: this.newOpportunity.StageName,
            amount: this.newOpportunity.Amount,
            closeDate: this.newOpportunity.CloseDate
        })
            .then(() => {
                this.showModal = false; // Închide modalul
                this.fetchOpportunities(); // Reîmprospătează tabelul
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
                        message: error.body.message || 'Error creating opportunity',
                        variant: 'error'
                    })
                );
            });
    }
    
    

    closeModal() {
        this.showModal = false; // Close modal
    }
    
}
