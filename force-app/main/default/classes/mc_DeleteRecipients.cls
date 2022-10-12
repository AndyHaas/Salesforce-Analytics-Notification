public with sharing class mc_DeleteRecipients {
    @InvocableMethod
    public static void mc_DeleteRecipients(List<Request> requests) {
        for (Request request : requests) {
            List<mc_SubscriptionListDefinition_Recipients> recipients = request.recipients;
            List<mc_SubscriptionListDefinition_Recipients> recipientsDifferent = new List<mc_SubscriptionListDefinition_Recipients>();
            List<mc_SubscriptionListDefinition_Recipients> recipientsSame = new List<mc_SubscriptionListDefinition_Recipients>();

            // Deserialize the request with SubscriptionListDefinition
            List<mc_SubscriptionListDefinition_Recipients> recipientsToDelete = (List<mc_SubscriptionListDefinition_Recipients>)JSON.deserialize(request.deletedRecipients, List<mc_SubscriptionListDefinition_Recipients>.class);

            // If recipients size equals recipientsToDelete size if they are the same then delete the entire notification else create a new recipient list
            if (recipients.size() == recipientsToDelete.size()) {
                // Delete the entire notification
                System.debug('Delete the entire notification' + request.notificationId);
                // Instantiate a new http object
                Http h = new Http();
                    
                // Get Domain URL
                string domainURL = URL.getSalesforceBaseUrl().toExternalForm();
                System.debug('domainURL: ' + domainURL);
                string baseURL =  '/services/data/v55.0/analytics/notifications/' + request.notificationId;

                // Set URL from domain and base url
                string url = domainURL + baseURL;

                // Set Session ID
                string sessionId =  Page.usf3__GenerateSessionIdForLWC.getContent().toString();
                // Fix Session Id
                sessionId = sessionId.substring(sessionId.indexOf('\n')+1);

                // Instantiate a new HTTP request, specify the method (DELETE) as well as the endpoint
                HttpRequest req = new HttpRequest();
                req.setEndpoint(url);
                req.setMethod('DELETE');
                req.setHeader('Authorization', 'OAuth ' + sessionId);

                // Send the request, and return a response
                HttpResponse res = h.send(req);
            } else {
                // Create a new recipient list with the recipients that are not in the recipientsToDelete list
                for (mc_SubscriptionListDefinition_Recipients recipient : recipients) {
                    if (!recipientsToDelete.contains(recipient)) {
                        recipientsDifferent.add(recipient);
                    }
                }
                // Update the recipients list with the new list
                System.debug('recipientsDifferent: ' + recipientsDifferent);
            }
        }
    }

    public class Request {
        @InvocableVariable(required=true)
        public string notificationId;
        @InvocableVariable(required=true)
        public List<mc_SubscriptionListDefinition_Recipients> recipients;
        @InvocableVariable(required=true)
        public string deletedRecipients;
    }
}
