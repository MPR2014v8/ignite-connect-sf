trigger MessageTrigger on Log_Msg__c (after insert, after update, after delete) {

    List<Message__e> eventsToPublish = new List<Message__e>();
    if (Trigger.isAfter) {
        if (Trigger.isInsert || Trigger.isUpdate) {

            for (Log_Msg__c logMsg : Trigger.new) {
                Message__e event = new Message__e();
                event.actorId__c = logMsg.actorId__c; 
                event.sessionId__c = logMsg.sessionId__c; 
                eventsToPublish.add(event);
            }
        }

        if (Trigger.isDelete) {
            for (Log_Msg__c logMsg : Trigger.old) {
                Message__e event = new Message__e();
                event.actorId__c = logMsg.actorId__c; 
                event.sessionId__c = logMsg.sessionId__c; 
                eventsToPublish.add(event);
            }
        }
        
        if (!eventsToPublish.isEmpty()) {
            for (Message__e event : eventsToPublish) {
                EventBus.publish(event);
            }
        }
    }
}