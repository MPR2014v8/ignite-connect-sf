import { LightningElement, api, track, wire } from 'lwc';
import getMessage from '@salesforce/apex/MessageApiCallout.getMessage';
import sendMessageToEndUser from '@salesforce/apex/MessageApiCallout.sendMessageToEndUser';
import getLineProfile from '@salesforce/apex/LineProfileController.getLineProfile';
import updateSession from '@salesforce/apex/MessageApiCallout.updateSession';
import closedSession from '@salesforce/apex/MessageApiCallout.closedSession';

import Id from '@salesforce/user/Id';
import { getRecord } from 'lightning/uiRecordApi';
import UserNameFIELD from '@salesforce/schema/User.Name';

import { subscribe, unsubscribe } from 'lightning/empApi';


export default class ChatAgent extends LightningElement {

    subscription;

    @api recordId;
    @track sessionId;
    // @track messages = [
    //     {msg: 'Message 1', display: 'US', time: '1:10 PM', username: 'User',  class: 'slds-chat-message__text slds-chat-message__text_inbound', s_class: 'slds-chat-listitem slds-chat-listitem_inbound'},
    //     {msg: 'Message 2', display: 'AG', time: '2:10 PM', username: 'Agent',  class: 'slds-chat-message__text slds-chat-message__text_outbound-agent', s_class: 'slds-chat-listitem slds-chat-listitem_outbound' },
    //     {msg: 'Message 3', display: 'US', time: '1:10 PM', username: 'User',  class: 'slds-chat-message__text slds-chat-message__text_inbound', s_class: 'slds-chat-listitem slds-chat-listitem_inbound'},
    //     {msg: 'Message 4', display: 'AG', time: '2:10 PM', username: 'Agent',  class: 'slds-chat-message__text slds-chat-message__text_outbound-agent', s_class: 'slds-chat-listitem slds-chat-listitem_outbound' },
    //     {msg: 'Message 5', display: 'US', time: '1:10 PM', username: 'User',  class: 'slds-chat-message__text slds-chat-message__text_inbound', s_class: 'slds-chat-listitem slds-chat-listitem_inbound'},
    //     {msg: 'Message 6', display: 'AG', time: '2:10 PM', username: 'Agent',  class: 'slds-chat-message__text slds-chat-message__text_outbound-agent', s_class: 'slds-chat-listitem slds-chat-listitem_outbound' },
    //     {msg: 'Message 7', display: 'US', time: '1:10 PM', username: 'User',  class: 'slds-chat-message__text slds-chat-message__text_inbound', s_class: 'slds-chat-listitem slds-chat-listitem_inbound'},
    //     {msg: 'Message 8', display: 'AG', time: '2:10 PM', username: 'Agent',  class: 'slds-chat-message__text slds-chat-message__text_outbound-agent', s_class: 'slds-chat-listitem slds-chat-listitem_outbound' },
    //     {msg: 'Message 9', display: 'US', time: '1:10 PM', username: 'User',  class: 'slds-chat-message__text slds-chat-message__text_inbound', s_class: 'slds-chat-listitem slds-chat-listitem_inbound'},
    //     {msg: 'Message 10', display: 'AG', time: '2:10 PM', username: 'Agent',  class: 'slds-chat-message__text slds-chat-message__text_outbound-agent', s_class: 'slds-chat-listitem slds-chat-listitem_outbound' },
    //     {msg: 'Message 11', display: 'US', time: '1:10 PM', username: 'User',  class: 'slds-chat-message__text slds-chat-message__text_inbound', s_class: 'slds-chat-listitem slds-chat-listitem_inbound'},
    //     {msg: 'Message 12', display: 'AG', time: '2:10 PM', username: 'Agent',  class: 'slds-chat-message__text slds-chat-message__text_outbound-agent', s_class: 'slds-chat-listitem slds-chat-listitem_outbound' },
    //     {msg: 'Message 13', display: 'US', time: '1:10 PM', username: 'User',  class: 'slds-chat-message__text slds-chat-message__text_inbound', s_class: 'slds-chat-listitem slds-chat-listitem_inbound'},
    //     {msg: 'Message 14', display: 'AG', time: '2:10 PM', username: 'Agent',  class: 'slds-chat-message__text slds-chat-message__text_outbound-agent', s_class: 'slds-chat-listitem slds-chat-listitem_outbound' },
    // ];

    @track messages = [];
    @track msgInput = "";
    @track lineProfile = { userId: '', displayName: '', statusMessage: '', profileUrl: '' };

    stickers = [
        { package_id: '446', sticker_id: '1988', url: 'https://stickershop.line-scdn.net/stickershop/v1/sticker/1988/android/sticker.png' },
        { package_id: '446', sticker_id: '1989', url: 'https://stickershop.line-scdn.net/stickershop/v1/sticker/1989/android/sticker.png' },
        { package_id: '446', sticker_id: '1990', url: 'https://stickershop.line-scdn.net/stickershop/v1/sticker/1990/android/sticker.png' },
        { package_id: '446', sticker_id: '1991', url: 'https://stickershop.line-scdn.net/stickershop/v1/sticker/1991/android/sticker.png' },
        { package_id: '446', sticker_id: '1992', url: 'https://stickershop.line-scdn.net/stickershop/v1/sticker/1992/android/sticker.png' },
        { package_id: '446', sticker_id: '1993', url: 'https://stickershop.line-scdn.net/stickershop/v1/sticker/1993/android/sticker.png' },
        { package_id: '446', sticker_id: '1994', url: 'https://stickershop.line-scdn.net/stickershop/v1/sticker/1994/android/sticker.png' },
        { package_id: '446', sticker_id: '1995', url: 'https://stickershop.line-scdn.net/stickershop/v1/sticker/1995/android/sticker.png' },
        { package_id: '446', sticker_id: '1996', url: 'https://stickershop.line-scdn.net/stickershop/v1/sticker/1996/android/sticker.png' },
        { package_id: '446', sticker_id: '1997', url: 'https://stickershop.line-scdn.net/stickershop/v1/sticker/1997/android/sticker.png' },
        { package_id: '446', sticker_id: '1998', url: 'https://stickershop.line-scdn.net/stickershop/v1/sticker/1998/android/sticker.png' },
        { package_id: '446', sticker_id: '1999', url: 'https://stickershop.line-scdn.net/stickershop/v1/sticker/1999/android/sticker.png' },
        { package_id: '446', sticker_id: '2000', url: 'https://stickershop.line-scdn.net/stickershop/v1/sticker/2000/android/sticker.png' },
        { package_id: '446', sticker_id: '2001', url: 'https://stickershop.line-scdn.net/stickershop/v1/sticker/2001/android/sticker.png' },
        { package_id: '446', sticker_id: '2002', url: 'https://stickershop.line-scdn.net/stickershop/v1/sticker/2002/android/sticker.png' },
    ]

    refreshInterval = 5000;

    get chkMsg() {
        return this.messages.length > 0;
    }

    @track error;
    @track userId = Id;
    @track currentUserName;

    @track isDropdownOpen = false;
    @track isDropdownSetupOpen = false;

    @wire(getRecord, { recordId: Id, fields: [UserNameFIELD] })
    currentUserInfo({ error, data }) {
        if (data) {
            this.currentUserName = data.fields.Name.value;
            console.log('get current user info success', this.currentUserName);
        } else if (error) {
            this.error = error;
            console.log('get current user info failed: ', error);
        }
    }

    toggleDropdown() {
        this.isDropdownOpen = !this.isDropdownOpen;
    }
    toggleDropdownSetup() {
        this.isDropdownSetupOpen = !this.isDropdownSetupOpen;
    }

    handleStickerClick(event) {
        const stickerId = event.currentTarget.dataset.id;
        // Handle the sticker click event
        console.log('Sticker clicked:', stickerId);
    }

    async refreshData() {
        await this.fetchDataFromService();
    }

    scrollToBottom() {
        const chatContainer = this.template.querySelector('[data-id="chatContainer"]');
        if (chatContainer) {
            // chatContainer.scrollTop = chatContainer.scrollHeight;
            chatContainer.scrollTo({ left: 0, top: chatContainer.scrollHeight - chatContainer.clientHeight, behavior: "smooth" });
        }
    }

    fetchDataFromService() {
        getLineProfile({ id: this.recordId })
            .then(data => {
                if (data) {
                    this.lineProfile = data;
                }
            })

        getMessage({ recordId: this.recordId })
            .then(data => {
                // console.log(data);
                if (data) {
                    console.log('userId: ', this.lineProfile.userId);
                    console.log('userId=', this.userId);
                    const parsedData = JSON.parse(data);
                    this.mapJsonToMessages(parsedData)
                    this.scrollToBottom();
                }
            })
    }

    connectedCallback() {
        this.refreshData();
        this.subscribeToEvent();
        this.scrollToBottom();
        //this.scheduleAutoRefresh();
    }

    disconnectedCallback() {
        this.unsubscribeFromEvent();
        // clearTimeout(this.refreshTimeout);
    }

    renderedCallback() {
        this.scrollToBottom();
    }

    // Subscribe to the platform event
    subscribeToEvent() {
        const channel = '/event/Message__e'; // Replace with your platform event API name
        const replayId = -1; // Receive all new events

        subscribe(channel, replayId, this.handleEvent.bind(this))
            .then(response => {
                this.subscription = response;
                this.scrollToBottom();
                console.log('Subscribed to channel:', response.channel);
            })
            .catch(error => {
                console.error('Error subscribing to channel:', error);
            });
    }

    // Handle incoming platform events
    async handleEvent(event) {
        console.log('Received event:', event.data);
        await this.refreshData();
        this.scrollToBottom();
    }

    // Unsubscribe from the platform event
    unsubscribeFromEvent() {
        if (this.subscription) {
            unsubscribe(this.subscription)
                .then(() => {
                    console.log('Unsubscribed from channel:', this.subscription.channel);
                })
                .catch(error => {
                    console.error('Error unsubscribing from channel:', error);
                });
        }
    }

    async scheduleAutoRefresh() {
        if (!this.chkMsg) {
            this.refreshData();
            this.scrollToBottom();
        }

        setTimeout(() => {
            this.refreshData();
            this.scrollToBottom();
            this.scheduleAutoRefresh();
        }, this.refreshInterval);
    }

    handleKeyDown(event) {
        if (event.key === 'Enter') {
            console.log('Pressing Enter...');
            const button = this.template.querySelector('[data-recid="sendBtn"]');
            if (button) {
                button.click();
            }
        }
    }

    handlePreviousMsgClick(event) {
        console.log('previous msg clicked');
    }

    handleNextMsgClick(event) {
        console.log('next msg clicked');
    }

    handleStickerSend(event) {
        if (event.target.tagName === 'IMG') {
            const altText = event.target.alt;
            console.log('Clicked sticker alt text:', altText);
        }
    }

    convertTimestampToAmPm(timestamp) {
        const date = new Date(timestamp);
        const options = {
            hour: 'numeric',
            minute: 'numeric',
            second: 'numeric',
            hour12: true
        };
        const timeString = date.toLocaleString('en-US', options);
        return timeString;
    }

    handleMessage(event) {
        this.msgInput = event.target.value;
        console.log('msg: ', this.msgInput);
    }

    handleSendClick(event) {
        this.updateMsgSession();
        this.sendMsg();
    }

    handleClosedClick(event) {
        this.closeMsgSession();
    }

    closeMsgSession() {
        var sessionId = this.sessionId;
        var agentId = this.userId;
        const endUserId = this.lineProfile.userId;
        const message = 'การสนทนาได้จบลงแล้ว...';
        const actorName = this.currentUserName;
        sendMessageToEndUser({ agentId, endUserId, message, actorName });
        closedSession({ sessionId, agentId });
        this.messages = [];
    }

    updateMsgSession() {
        var sessionId = this.sessionId;
        var agentId = this.userId;
        console.log('updateMsgSession prcress...');
        console.log('sessionId: ', sessionId);
        console.log('agentId: ', agentId);
        const resutl = updateSession({ sessionId, agentId });
        console.log(resutl);
    }

    sendMsg() {
        var agentId = this.userId;
        var endUserId = this.lineProfile.userId;
        var message = this.msgInput;
        var actorName = this.currentUserName;

        const resutl = sendMessageToEndUser({ agentId, endUserId, message, actorName });
        console.log(resutl);

        this.template.querySelector(".slds-input").value = "";
        this.refreshData();
        this.scrollToBottom();
    }

    mapJsonToMessages(jsonData) {

        console.log('jsonData: ', jsonData);
        this.messages = jsonData.map((messageData) => {
            const seq = messageData.seq;
            const messageType = messageData.messageType;
            const messageDeliveryTime = messageData.messageDeliveryTime;
            const message = messageData.message;
            const actorType = messageData.actorType;
            const actorName = messageData.actorName;
            const sessionId = messageData.sessionId;
            this.sessionId = messageData.sessionId;

            return {
                msg: message,
                display: actorType === 'agent' ? 'AG' : 'US',
                displayActorStype: actorType === 'agent' ? 'color: #ff6347;' : 'color: #a0f2bf;',
                time: this.convertTimestampToAmPm(messageDeliveryTime),
                username: actorName,
                class: actorType === 'agent' ? 'slds-chat-message__text slds-chat-message__text_outbound-agent' : 'slds-chat-message__text slds-chat-message__text_inbound',
                s_class: actorType === 'agent' ? 'slds-chat-listitem slds-chat-listitem_outbound' : 'slds-chat-listitem slds-chat-listitem_inbound',
                seq: seq,
                sessionId: sessionId,
                messageType: messageType,
            };
        });
    }
}