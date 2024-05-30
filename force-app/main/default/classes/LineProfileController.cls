public with sharing class LineProfileController {
    private class LineProfileResponse {
        @AuraEnabled
        public String userId { get; set; }
        
        @AuraEnabled
        public String displayName { get; set; }

        @AuraEnabled
        public String statusMessage { get; set; }

        @AuraEnabled
        public String profileUrl { get; set; }
    }

    @AuraEnabled
    public static LineProfileResponse getLineProfile(String id) {
        LineProfileResponse response = new LineProfileResponse();
        Contact contact = [SELECT Id, Line_Display_Name__c, LINE_Profile_URL__c, LINE_Status_Message__c, LINE_User_ID__c FROM Contact WHERE Id = :id];
        response.userId = contact.LINE_User_ID__c == null ? '' : contact.LINE_User_ID__c;
        response.displayName = contact.Line_Display_Name__c == null ? '' : contact.Line_Display_Name__c;
        response.statusMessage = contact.LINE_Status_Message__c == null ? '' : contact.LINE_Status_Message__c;
        response.profileUrl = contact.LINE_Profile_URL__c == null ? '' : contact.LINE_Profile_URL__c;

        return response;
    }
}