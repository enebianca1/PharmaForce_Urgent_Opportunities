import { LightningElement, api, track, wire } from 'lwc';
import getUrgentOpportunities from '@salesforce/apex/UrgentOpportunitiesController.getUrgentOpportunities';
import createOpportunity from '@salesforce/apex/UrgentOpportunitiesController.createOpportunity';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import OPPORTUNITY_OBJECT from '@salesforce/schema/Opportunity';
import STAGE_NAME_FIELD from '@salesforce/schema/Opportunity.StageName';

export default class UrgentOpportunitiesTable extends LightningElement {
    @api recordId; // ID-ul contului curent
    @track opportunities = [];
    @track searchKey = '';
    @track offsetValue = 0;
    @track limitValue = 10; // Numărul de înregistrări pe pagină
    @track showModal = false; // Track modal visibility
    @track newOpportunity = {}; // Track new opportunity fields
    @track stageOptions = [];
    @track totalRecords = 0;
    @track currentPage = 1; 
    @track totalPages = 0; 

    @wire(getObjectInfo, { objectApiName: OPPORTUNITY_OBJECT })
    opportunityMetadata;

    @wire(getPicklistValues, {
        recordTypeId: '$opportunityMetadata.data.defaultRecordTypeId',
        fieldApiName: STAGE_NAME_FIELD
    })
    wiredStageOptions({ data, error }) {
        if (data) {
            this.stageOptions = data.values.map((option) => {
                return { label: option.label, value: option.value };
            });
        } else if (error) {
            console.error('Error fetching stage options:', error);
        }
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

    validateFields() {
        const requiredFields = ['Name', 'StageName', 'Amount', 'CloseDate'];
        let isValid = true;
        let firstInvalidField=null;

        requiredFields.forEach((field) => {
            const input = this.template.querySelector(`[name="${field}"]`);
            if (input && !input.value) {
                input.setCustomValidity(`${field} is required`);
                input.reportValidity();
                isValid = false;
                if (!firstInvalidField) {
                    firstInvalidField = input;
                }
            } else if (input) {
                input.setCustomValidity('');
                input.reportValidity();
            }
        });

        if (firstInvalidField) {
            firstInvalidField.focus();
        }

        return isValid;
    }


    saveOpportunity() {
        if (!this.validateFields()) {
            return;
        }
        createOpportunity({
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
                        message: error.body.message || 'Error creating opportunity',
                        variant: 'error'
                    })
                );
            });
    } 

    closeModal() {
        this.showModal = false;
    }
    
}
