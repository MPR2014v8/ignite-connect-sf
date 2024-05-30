@RestResource(urlMapping='/CreateContact')
global class IGConnectAPI {
    
	@HttpGet
    global static String getHello() {
        return 'Hello World';
    }
     
    @HttpPost
    global static void updateLineInfomation(
        String email, 
        String lineUserId, 
        String lineDisplayName, 
        String lineProfileUser,
        String lineStatusMessage
    ) {
        try {
            // New Create Contact 
            Contact newContact = new Contact();
            newContact.LastName = lineDisplayName;
            newContact.Email = email;
            newContact.LINE_USER_ID__c = lineUserId;
            newContact.LINE_DISPLAY_NAME__c = lineDisplayName;
            newContact.LINE_Profile_URL__c = lineProfileUser;
            newContact.LINE_STATUS_MESSAGE__c = lineStatusMessage;

            insert newContact;

            RestContext.response.statusCode = 200;
            RestContext.response.responseBody = Blob.valueOf('New contact created successfully');
        }
        catch(Exception e) {
            RestContext.response.statusCode = 400;
        	RestContext.response.responseBody = Blob.valueOf('Error occurred: ' + e.getMessage());
        }
    }

}