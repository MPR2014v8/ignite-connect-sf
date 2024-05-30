import { LightningElement, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
// import getSessionActive from '@salesforce/apex/MessageApiCallout.getSessionActive;
import getSessionActive from '@salesforce/apex/MessageApiCallout.getSessionActive';

export default class TodayChats extends NavigationMixin(LightningElement) {

    @track records = [
        { id: '003IT00002m0QjJYAU', name: 'John', status: 'New', agent: 'Wachira' },
        { id: '003IT00002l02FYYAY', name: 'Liza', status: 'New', agent: 'Wachira' },
        { id: '003IT00002m0Qs6YAE', name: 'KENDO', status: 'Progress', agent: 'Weeraphap' }
    ];

    @track sessions = [];

    get chkSns() {
        return this.sessions.length > 0;
    }

    refreshInterval = 5000;

    connectedCallback() {
        this.scheduleAutoRefresh();
    }

    async refreshData() {
        await this.fetchDataFromService();
    }

    fetchDataFromService() {
        getSessionActive({})
            .then(data => {
                console.log('getDataFromSession...');
                console.log(data);
                if (data) {
                    const parsedData = JSON.parse(data);
                    console.log('GET_SESSION: ', parsedData);
                    this.mapJsonToSession(parsedData)
                }
            })
    }

    mapJsonToSession(jsonData) {

        console.log('jsonData: ', jsonData);
        this.sessions = jsonData.map((sessionData) => {
            const nameSession = sessionData.name;
            const startTime = sessionData.startTime;
            const endTime = sessionData.endTime;
            const status = sessionData.status;
            const cilentPlatformKey = sessionData.cilentPlatformKey;
            const platformType = sessionData.platformType;
            const caseId = sessionData.caseId === undefined ? 'empty' : sessionData.caseId;;
            const agentId = sessionData.agentId === undefined ? 'empty' : sessionData.agentId;
            const endUserId = sessionData.endUserId;
            const status_sesion = sessionData.status_sesion;
            const id = sessionData.id;
            const agentName = sessionData.agentName;
            const userName = sessionData.userName;
            const recordId = sessionData.recordId;
            const style = sessionData.status === 'New' ? 'padding:0.5rem;background:#40A578' : 'padding:0.5rem;background:#E6FF94';
            return {
                nameSession: nameSession,
                startTime: this.convertTimestampToAmPm(startTime),
                endTime: this.convertTimestampToAmPm(endTime),
                status: status,
                cilentPlatformKey: cilentPlatformKey,
                platformType: platformType,
                caseId: caseId,
                agentId: agentId,
                endUserId: endUserId,
                status_sesion: status_sesion,
                id: id,
                agentName: agentName,
                userName: userName,
                recordId: recordId,
                style: style,
            };
        });
    }

    convertTimestampToAmPm(timestamp) {
        try {
            const date = new Date(timestamp);
            const options = {
                hour: 'numeric',
                minute: 'numeric',
                second: 'numeric',
                hour12: true
            };
            const timeString = date.toLocaleString('en-US', options);
            return timeString;
        } catch (e) {
            return 'Empty';
        }


    }

    scheduleAutoRefresh() {
        if (!this.chkMsg) {
            this.refreshData();
        }

        setTimeout(() => {
            this.refreshData();
            this.scheduleAutoRefresh();
        }, this.refreshInterval);
    }

    handleSendClick(event) {
        console.log("Press enter...");
    }

    handleNavigate(event) {
        // Prevent the default action
        event.preventDefault();

        const recordId = event.currentTarget.dataset.id;

        console.log('recordId: ', recordId);

        // Use the NavigationMixin to navigate to the record page
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recordId, // Replace with your record Id
                objectApiName: 'Contact', // Replace with your object API name
                actionName: 'view'
            }
        });
    }
}