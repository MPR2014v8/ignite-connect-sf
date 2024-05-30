public with sharing class MessageApiCallout {
    // private static final String ENDPOINT = 'https://ignite-idea-lab.cloud';
    private static final String ENDPOINT = 'https://magnetic-terribly-crane.ngrok-free.app';

    public class MsgInSession {
        @AuraEnabled
        public String id;
        @AuraEnabled
        public String sessionId;
        @AuraEnabled
        public String actorId;
        @AuraEnabled
        public String actorName;
        @AuraEnabled
        public String actorType;
        @AuraEnabled
        public String message;
        @AuraEnabled
        public String messageDeliveryTime;
        @AuraEnabled
        public String messageType;
        @AuraEnabled
        public String seq;
    }

    public class MsgSession {
        @AuraEnabled
        public String id;
        @AuraEnabled
        public String name;
        @AuraEnabled
        public String startTime;
        @AuraEnabled
        public String endTime;
        @AuraEnabled
        public String status;
        @AuraEnabled
        public String cilentPlatformKey;
        @AuraEnabled
        public String platformType;
        @AuraEnabled
        public String caseId;
        @AuraEnabled
        public String agentId;
        @AuraEnabled
        public String endUserId;
    }

    public class JsonMsgSessionRequest {
        public MsgSession session;
    
    }
    public class JsonMsgSessionAllRequest {
        public List<MsgSession> session;
    }
    
    public class JsonMsgInSessionRequest {
        public List<MsgInSession> message;
    }

    @AuraEnabled
    public static void updateSession(
        String sessionId, 
        String agentId
    ){
        Map<String, Object> payloadMap = new Map<String, Object>();
        payloadMap.put('agentId', agentId);
        payloadMap.put('id', sessionId);
        payloadMap.put('status', 'Progress');

        String payloadString = JSON.serialize(payloadMap);
        HttpRequest request = new HttpRequest();

        request.setMethod('POST');
        request.setEndpoint(ENDPOINT + '/line-connect/updateSession');
        request.setHeader('Content-Type', 'application/json');
        request.setBody(payloadString);

        Http httpProtocol = new Http();
        HttpResponse response = httpProtocol.send(request);
    }

    @AuraEnabled
    public static void closedSession(
        String sessionId, 
        String agentId
    ){
        Map<String, Object> payloadMap = new Map<String, Object>();
        payloadMap.put('agentId', agentId);
        payloadMap.put('id', sessionId);
        payloadMap.put('status', 'Closed');

        String payloadString = JSON.serialize(payloadMap);
        HttpRequest request = new HttpRequest();

        request.setMethod('POST');
        request.setEndpoint(ENDPOINT + '/line-connect/updateSession');
        request.setHeader('Content-Type', 'application/json');
        request.setBody(payloadString);

        Http httpProtocol = new Http();
        HttpResponse response = httpProtocol.send(request);
    }

    @AuraEnabled
    public static void sendMessageToEndUser(
        String agentId, 
        String endUserId, 
        String message, 
        String actorName
    ){
        Map<String, Object> payloadMap = new Map<String, Object>();
        payloadMap.put('agentId', agentId);
        payloadMap.put('endUserId', endUserId);
        payloadMap.put('message', message);
        payloadMap.put('actorName', actorName);

        String payloadString = JSON.serialize(payloadMap);
        HttpRequest request = new HttpRequest();

        request.setMethod('POST');
        request.setEndpoint(ENDPOINT + '/line-connect/sendMessageToUser');
        request.setHeader('Content-Type', 'application/json');
        request.setBody(payloadString);

        Http httpProtocol = new Http();
        HttpResponse response = httpProtocol.send(request);
    }

    
    private static HttpResponse getMessagesInSession(String sessionId){
        HttpRequest request = new HttpRequest();
        String endpoint = ENDPOINT + '/line-connect/message-in-session';
        String requestBody = '{"sessionId":'+ '"'+sessionId+'"'+'}';
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json');
        request.setBody(requestBody);
        request.setEndpoint(endpoint);
        Http httpProtocol = new Http();
        HttpResponse response = httpProtocol.send(request);
        return response;
    }

    
    private static HttpResponse getSessionActiveOfUser(String lineUserId) {
        String actorId = lineUserId;
        String endpoint = ENDPOINT + '/line-connect/sessionActiveOfUser';
        String requestBody = '{"actorId":'+ '"'+actorId+'"'+'}';
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json');
        request.setBody(requestBody);
        request.setEndpoint(endpoint);

        Http httpProtocol = new Http();
        HttpResponse response = httpProtocol.send(request);
        return response;  
    }

    private static HttpResponse getSessionActiveRequest() {
        String endpoint = ENDPOINT + '/line-connect/sessionActive';
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json');
        request.setEndpoint(endpoint);

        Http httpProtocol = new Http();
        HttpResponse response = httpProtocol.send(request);
        return response;  
    }
    
    @AuraEnabled
    public static String getSessionActive() {
        try {
            HttpResponse messageSessionResponse = getSessionActiveRequest();
            if(messageSessionResponse.getStatus() != 'OK') {
                return null;
                //return 'msg s is not found.';
                // system.debug('msg s is not found');
            }
            JsonMsgSessionAllRequest requestMsgSession = (JsonMsgSessionAllRequest)JSON.deserialize(messageSessionResponse.getBody(), JsonMsgSessionAllRequest.class);
            List<Map<String, Object>> serializedMessages = new List<Map<String, Object>>();
            for (MsgSession msg : requestMsgSession.session) {
                Map<String, Object> serializedMsg = new Map<String, Object>();

                String agentName = '~';
                String userName = '';  
                String recordId = '';

                if (msg.endUserId != null) {
                    Contact contact = [SELECT Id, LastName FROM Contact WHERE LINE_User_ID__c =: msg.endUserId];
                    userName = contact.LastName;
                    recordId = contact.Id;
                }

                if (msg.agentId != null) {
                    User agent = [SELECT Id, FirstName, LastName FROM User WHERE Id =: msg.agentId];
                    agentName = agent.FirstName + ' ' + agent.LastName;
                }

                serializedMsg.put('name', msg.name);
                serializedMsg.put('startTime', msg.startTime);
                serializedMsg.put('endTime', msg.endTime);
                serializedMsg.put('status', msg.status);
                serializedMsg.put('cilentPlatformKey', msg.cilentPlatformKey);
                serializedMsg.put('platformType', msg.platformType);
                serializedMsg.put('caseId', msg.caseId);
                serializedMsg.put('agentId', msg.agentId);
                serializedMsg.put('endUserId', msg.endUserId);
                serializedMsg.put('status_sesion', msg.status);
                serializedMsg.put('id', msg.id);
                serializedMsg.put('agentName', agentName);
                serializedMsg.put('userName', userName);
                serializedMsg.put('recordId', recordId);
                serializedMessages.add(serializedMsg);
            }
            String serializedJson = JSON.serialize(serializedMessages);
            return serializedJson;
            // system.debug(serializedJson);
        } catch (Exception e) {
            // return null;
            return 'error :' + e.getMessage();
            // system.debug('error :' + e.getMessage());
        }
        
    } 

    @AuraEnabled
    public static String getMessage(String recordId) {
        try {
            Contact contact = [SELECT LINE_User_ID__c FROM Contact WHERE Id =: recordId LIMIT 1];
            if (contact.LINE_User_ID__c == null) {
                return null;
                // return 'contact is not found.';
            }
            HttpResponse messageSessionResponse = getSessionActiveOfUser(contact.LINE_User_ID__c);
            if(messageSessionResponse.getStatus() != 'OK') {
                return null;
                // return 'msg s is not found.';
            }
            JsonMsgSessionRequest request = (JsonMsgSessionRequest)JSON.deserialize(messageSessionResponse.getBody(), JsonMsgSessionRequest.class);
            HttpResponse messageInSessionResponse = getMessagesInSession(request.session.id);
            System.debug(messageInSessionResponse.getBody());
            if(messageInSessionResponse.getStatus() != 'OK') {
                return null;
                // return 'msg in s is not found.';
            }
            JsonMsgInSessionRequest requestMsgInSession = (JsonMsgInSessionRequest)JSON.deserialize(messageInSessionResponse.getBody(), JsonMsgInSessionRequest.class);
            List<Map<String, Object>> serializedMessages = new List<Map<String, Object>>();
            for (MsgInSession msg : requestMsgInSession.message) {
                Map<String, Object> serializedMsg = new Map<String, Object>();
                serializedMsg.put('id', msg.id);
                serializedMsg.put('sessionId', msg.sessionId);
                serializedMsg.put('actorId', msg.actorId);
                serializedMsg.put('actorName', msg.actorName);
                serializedMsg.put('actorType', msg.actorType);
                serializedMsg.put('message', msg.message);
                serializedMsg.put('messageDeliveryTime', msg.messageDeliveryTime);
                serializedMsg.put('messageType', msg.messageType);
                serializedMsg.put('seq', msg.seq);
                serializedMessages.add(serializedMsg);
            }
            String serializedJson = JSON.serialize(serializedMessages);
            return serializedJson;
        } catch (Exception e) {
            return null;
            // return 'error :' + e.getMessage();
        }
        
    } 
}