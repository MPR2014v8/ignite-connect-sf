import { LightningElement, api, track } from 'lwc';
import LINE_Brand_icon from '@salesforce/resourceUrl/LINE_Brand_icon';
import getLineProfile from '@salesforce/apex/LineProfileController.getLineProfile';

export default class LineProfile extends LightningElement {
    @api recordId;
    lineIcon = LINE_Brand_icon;
    @track lineProfile = { userId: '', displayName: '', statusMessage: '', profileUrl: '' };

    connectedCallback() {
        getLineProfile({ id: this.recordId })
        .then(data => {
            if(data) {
                this.lineProfile = data;
            }
        })
    }

    get isLineConnected() {
        return this.lineProfile.userId;
    }
}