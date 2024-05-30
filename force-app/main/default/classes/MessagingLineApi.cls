@RestResource(urlMapping='/Messaginig')
global with sharing class MessagingLineApi {
    global static String lineDisplayName = 'UNKNOW';

    public static String chkLUsrLineInfo(String lineId) {
        // check user have line infomation 
        String contactId = '';
        try {
            Contact existingContact = [SELECT Id, LINE_Display_Name__c FROM Contact WHERE LINE_User_ID__c = :lineId LIMIT 1];  
            contactId = existingContact.Id;        
            lineDisplayName = existingContact.LINE_Display_Name__c;
        } 
        catch(Exception e) {
            contactId = 'NOT_FOUND';
        }
        return contactId;
    }

    @HttpPost
        global static void sendMessage(
            String message,
            String messagingChannelId,
            String messagingConsentStatus,
            String messagingType,
            String messagingPlatformKey,
            String lineId
        ) {
            

            String contactId = chkLUsrLineInfo(lineId);
            if(contactId == 'NOT_FOUND') {
                RestContext.response.statusCode = 404;
                RestContext.response.responseBody = Blob.valueOf('This user exists line infomation in Contact');
            } 
            else {

                // Create ConversationEntry
                try {
                    Integer countSeqMsgUsr = [SELECT COUNT() FROM ConversationEntry__c WHERE Contact__c = :contactId];

                    ConversationEntry__c objCnEty = new ConversationEntry__c();
                    objCnEty.Contact__c = contactId;
                    objCnEty.Actor_Name__c = lineDisplayName;
                    objCnEty.Actor_Type__c = 'End User';
                    objCnEty.Message__c = message;
                    objCnEty.MessageSendTime__c = Datetime.now();
                    objCnEty.Seq__c = countSeqMsgUsr + 1;
                    insert objCnEty;

                    RestContext.response.statusCode = 200;
                    RestContext.response.responseBody = Blob.valueOf('Successful Send Message...');
                    
                } 
                catch(Exception e) {
                    RestContext.response.statusCode = 400;
                    RestContext.response.responseBody = Blob.valueOf('Failed Send Message... : ' + e);
                }

                /*
                // Check User have MessagingEndUser Infomation
                Boolean chkUsrHaveMsgEndUsrInfo = true;
                String msgEndUsrId = '';
                try {
                    MessagingEndUser existingMessagingEndUser = [SELECT Id, Name FROM MessagingEndUser WHERE ContactId = :contactId LIMIT 1];  
                    contactId = existingMessagingEndUser.ContactId;        
                    msgEndUsrId = existingMessagingEndUser.Id;
                } 
                catch(Exception e) {
                    RestContext.response.statusCode = 404;
                    RestContext.response.responseBody = Blob.valueOf('This user exists infomation in MessaginEndUser');
                    chkUsrHaveMsgEndUsrInfo = false;
                }

                if(chkUsrHaveMsgEndUsrInfo == false) {
                    // Create MessagingEndUser
                    MessagingEndUser objMsgUsr = new MessagingEndUser();
                    objMsgUsr.ContactId = contactId;
                    objMsgUsr.MessagingChannelId = messagingChannelId;
                    objMsgUsr.MessagingConsentStatus = messagingConsentStatus;
                    objMsgUsr.MessageType = messagingType;
                    objMsgUsr.MessagingPlatformKey = messagingPlatformKey;
                    objMsgUsr.Name = lineDisplayName;
                    insert objMsgUsr; 
                }

                try {
                    MessagingEndUser existingMessagingEndUser = [SELECT Id, Name FROM MessagingEndUser WHERE ContactId = :contactId LIMIT 1];  
                    msgEndUsrId = existingMessagingEndUser.Id;

                    ConversationEntry__c objCnEty = new ConversationEntry__c();
                    objCnEty.Actor_Name__c = lineDisplayName;
                    objCnEty.Actor_Type__c = 'End User';
                    objCnEty.Message__c = message;
                    objCnEty.MessageSendTime__c = Datetime.now();
                    objCnEty.Messaging_User__c = msgEndUsrId;
                    objCnEty.Seq__c = 1;
                    insert objCnEty;

                    RestContext.response.statusCode = 200;
                    RestContext.response.responseBody = Blob.valueOf('Insert Messaging Successful...');
                    
                } 
                catch(Exception e) {
                    RestContext.response.statusCode = 400;
                    RestContext.response.responseBody = Blob.valueOf('Failed Send Message...: ' + contactId);
                }
                */
                
            }
        }
}