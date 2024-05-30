@RestResource(urlMapping='/IGConnectAPI')
global with sharing class ContactLineApi {
    @HttpPost
        global static void updateLineInfomation(
            String email,
            String lineUserId, 
            String lineDisplayName, 
            String lineProfileUser,
            String lineStatusMessage
        ) {
            
            Boolean emailStatus = true;
            try {

                Contact existingContact = [SELECT Id FROM Contact WHERE Email = :email LIMIT 1];

                RestContext.response.statusCode = 200;
                RestContext.response.responseBody = Blob.valueOf('Email exists in Contact with Id: ' + existingContact.Id);
                
            } 
            catch(Exception e) {
                RestContext.response.statusCode = 404;
                RestContext.response.responseBody = Blob.valueOf('Email does not exist in any Contact');
                emailStatus = false;
            }
            
            try {
                if(emailStatus) {
                    // Updaete Contact
                    Contact existingContact = [
                        SELECT Id, FirstName, LastName, LINE_User_ID__c, LINE_Display_Name__c, LINE_Profile_URL__c, LINE_Status_Message__c
                        FROM Contact
                        WHERE Email = :email
                        LIMIT 1
                    ];
                    
                    existingContact.LINE_User_ID__c = lineUserId;
                    existingContact.LINE_Display_Name__c = lineDisplayName;
                    existingContact.LINE_Profile_URL__c = lineProfileUser;
                    existingContact.LINE_Status_Message__c = lineStatusMessage;
                    existingContact.Email = email;
        
                    update existingContact;
        
                    RestContext.response.statusCode = 200;
                    RestContext.response.responseBody = Blob.valueOf('Contact updated successfully');

            } 
            else {
                // New Create Contact 
                Contact newContact = new Contact();

                newContact.LastName = lineDisplayName;
                newContact.Email = email;
                newContact.LINE_User_ID__c = lineUserId;
                newContact.LINE_Display_Name__c = lineDisplayName;
                newContact.LINE_Profile_URL__c = lineProfileUser;
                newContact.LINE_Status_Message__c = lineStatusMessage;

                insert newContact;

                RestContext.response.statusCode = 200;
                RestContext.response.responseBody = Blob.valueOf('New contact created successfully');
            }
            }
            catch(Exception e) {
                RestContext.response.statusCode = 400;
                RestContext.response.responseBody = Blob.valueOf('Error occurred: ' + e.getMessage());
            }
        }
}