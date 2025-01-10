import { LightningElement, api, track, wire } from 'lwc';
import getUrgentOpportunities from '@salesforce/apex/UrgentOpportunitiesController.getUrgentOpportunities';
import createOpportunity from '@salesforce/apex/UrgentOpportunitiesController.createOpportunity';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import OPPORTUNITY_OBJECT from '@salesforce/schema/Opportunity';
import STAGE_NAME_FIELD from '@salesforce/schema/Opportunity.StageName';

export default class UrgentOpportunitiesTable extends LightningElement {
    @api recordId; 
     opportunities = [];
     searchKey = '';
     offsetValue = 0;
     limitValue = 10;
     showModal = false; 
     newOpportunity = {}; 
     stageOptions = [];
     totalRecords = 0;
     currentPage = 1; 
     totalPages = 0; 

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
            fieldName: 'recordLink', 
            type: 'url', 
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
        this.offsetValue = 0; 
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
                const opportunities = result.opportunities;
    
                this.opportunities = opportunities.map((opp) => {
                    return {
                        ...opp,
                        recordLink: `/lightning/r/Opportunity/${opp.Id}/view`
                    };
                });
    
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

    handleNewOpportunity() {
        this.newOpportunity = {};
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
            .then((isSuccess) => {
                if (isSuccess) {
                    this.showModal = false;
                    this.fetchOpportunities();
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Opportunity created successfully',
                            variant: 'success'
                        })
                    );
                } else {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error',
                            message: 'Failed to create opportunity',
                            variant: 'error'
                        })
                    );
                }
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
