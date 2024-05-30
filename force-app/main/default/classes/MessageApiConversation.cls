@RestResource(urlMapping='/messageapi/conversation')
global with sharing class MessageApiConversation {

    @HttpPost
    global static void createMsgConversation(
            String actorName,
            String actorType,
            String message,
            String messageType,
            String seq,
            String actorID,
            String sessionId
    ) {
        try {

            Line_OA_Messaging_Conversation__c objLOAMC = new Line_OA_Messaging_Conversation__c();
            objLOAMC.Actor_Name__c = actorName;
            objLOAMC.Actor_Type__c = actorType;
            objLOAMC.Message__c = message;
            objLOAMC.Message_Delivery_Time__c = Datetime.now();
            objLOAMC.Message_Type__c = messageType;
            objLOAMC.Seq__c = Integer.valueOf(seq);
            objLOAMC.Actor_ID__c = actorID;
            objLOAMC.Session_ID__c = sessionId;
            insert objLOAMC;

            RestContext.response.responseBody = Blob.valueOf('Successful Create Messaging Conversation...');
            RestContext.response.statusCode = 200;            
        } 
        catch(Exception e) {
            RestContext.response.statusCode = 400;
            RestContext.response.responseBody = Blob.valueOf('Failed Send Messaging Conversation... : ' + e);
        }
    }
}