import { LightningElement, api, wire } from 'lwc';
import mc_GetSubscriptionDataList from '@salesforce/apex/mc_SubscriptionData.mc_GetSubscriptionDataList';

export default class Mc_SubscriptionDataViewer extends LightningElement {
    // Global Variables
    // Change domainURL to window.location.origin
    //https://milestoneconsulting--lwcdev.sandbox.my.salesforce.com/services/data/v55.0/analytics/notifications?source=lightningReportSubscribe
    domainURL = 'https://milestoneconsulting--lwcdev.sandbox.my.salesforce.com';
    baseURL = this.domainURL + '/services/data/v55.0/analytics/notifications';
    subData;

    // API Variables
    @api source;
    @api userId;
    @api recordId;

    // On Connected Callback load the subscription data
    connectedCallback() {
        console.log('Connected Callback');
        console.log('source: ' + this.source);
        console.log('userId: ' + this.userId);
        console.log('recordId: ' + this.recordId);

        if (this.source) {
            this.getSubscriptionDataFromApex();
        } else {
            console.log('No Source');
        }
    }

    // Get the subscription data from the HTTP request from source
    getSubscriptionData(source) {
        console.log('Get Subscription Data');
        console.log('source: ' + source);

        let callbackURL = this.baseURL + '?source=' + source;

        fetch(callbackURL, {
            method: "GET",
            mode: 'cors',
            headers: {
                'Content-Type': 'application/json',
                'Allow-Control-Allow-Origin': '*',
                'Access-Control-Allow-Origin': '*'
            }
        }).then((response) => response.json())
            .then(repos => {
                console.log(repos);
                this.subData = repos;
            });
    }

    // Get Subscription from Apex
    getSubscriptionDataFromApex() {
        console.log('Get Subscription Data From Apex');
        console.log('source: ' + this.source);

        mc_GetSubscriptionDataList({ source: this.source, userId: this.userId, recordId: this.recordId })
            .then(result => {
                console.log('Result: ' + result);
                this.subData = result;
            })
            .catch(error => {
                console.log('Error: ' + error);
                console.log('Error: ' + JSON.stringify(error));
            });
        console.log('wiredSubscriptionData: ' + this.subData);
        
    }

    // Get subscription data by userId
    getSubDataByUserId(source, userId) {
        let callbackURL = this.baseURL + '?source=' + source & 'userId=' + userId;

        fetch(callbackURL, {
            method: "GET"
        }).then((response) => response.json())
            .then(repos => {
                console.log(repos);
                this.subData = repos;
            });
    }


    // Refresh the subscription data
    refreshData() {
        this.getSubscriptionData(source);
    }

    // Source Change Event
    handleSourceChange(event) {
        this.source = event.target.value;
        this.getSubscriptionData(event.target.value);
    }
    
}