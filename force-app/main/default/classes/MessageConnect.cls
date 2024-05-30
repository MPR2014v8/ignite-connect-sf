public class MessageConnect {
    static void test() {
        MessagingEndUser objMsgUser = new MessagingEndUser();
        objMsgUser.ContactId = '003IU00002Upf2TYAR';
        objMsgUser.MessagingChannelId = '0MjIU0000004C9X0AU';
        objMsgUser.MessagingConsentStatus = 'TEST';
        objMsgUser.MessageType = 'ResidentEvil';//For SMS Channel
        /*The phone number or Facebook page ID associated with this Messaging end user.*/
        objMsgUser.MessagingPlatformKey = 'fa41fac4-511a-436c-ab0c-b8dc745b5918';
        objMsgUser.Name = 'Blacksnow';
        insert objMsgUser; 
    }
}