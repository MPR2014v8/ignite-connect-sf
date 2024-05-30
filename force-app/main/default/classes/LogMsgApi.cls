@RestResource(urlMapping='/logmsgapi')
global with sharing class LogMsgApi {

     @HttpPost
     global static void createLogMsgApi(
            String name,
            String actorId,
            String sessionId
     ) {
         try {
 
             Log_Msg__c objLogMsg = new Log_Msg__c();
             objLogMsg.Name = name;
             objLogMsg.actorId__c = actorId;
             objLogMsg.sessionId__c = sessionId;
             insert objLogMsg;
 
             RestContext.response.responseBody = Blob.valueOf('Successful Create Log Message...');
             RestContext.response.statusCode = 200;            
         } 
         catch(Exception e) {
             RestContext.response.statusCode = 400;
             RestContext.response.responseBody = Blob.valueOf('Failed Send Log Message... : ' + e);
         }
     }
  
}