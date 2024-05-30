@RestResource(urlMapping='/messageapi')
global with sharing class MessagingApi {

    @HttpPost
    global static void createMsgSession(
            String sessionId,
            String name,
            String cilentPlatformKey,
            String platformType,
            String status
    ) {
        try {

            if(platformType == 'LINE') {

                Line_OA_Messaging_Session__c objLOAMS = new Line_OA_Messaging_Session__c();
                objLOAMS.Session_ID__c = sessionId;
                objLOAMS.name__c = name;
                objLOAMS.startTime__c = Datetime.now();
                objLOAMS.cilentPlatformKey__c = cilentPlatformKey;
                objLOAMS.platformType__c = platformType;
                objLOAMS.status__c = status;
                insert objLOAMS;

                RestContext.response.responseBody = Blob.valueOf('Successful Create Messaging Session...');
            }
            
            RestContext.response.statusCode = 200;            
        } 
        catch(Exception e) {
            RestContext.response.statusCode = 400;
            RestContext.response.responseBody = Blob.valueOf('Failed Send Messaging Session... : ' + e);
        }
    }
}