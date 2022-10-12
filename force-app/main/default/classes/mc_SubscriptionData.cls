public with sharing class mc_SubscriptionData {
    @InvocableMethod(label='Get Subscription Data' description='Get Subscription Data')
    public static List<Results> mc_GetSubscriptionDataList(List<Request> requestList) {
        System.Debug('mc_SubscriptionDataList');

        // Set list of subscriptions
        List<mc_SubscriptionListDefinition> subscriptionList = new List<mc_SubscriptionListDefinition>();

        // Set Response Wrapper
        List<Results> responseWrapper = new List<Results>();

        for( Request currRequest : requestList ) {
            System.Debug('source: ' + currRequest.source);
            System.Debug('ownerId: ' + currRequest.ownerId);
            System.Debug('recordId: ' + currRequest.recordId);
    
            // Instantiate a new http object
            Http h = new Http();
    
            // Get Domain URL
            string domainURL = URL.getSalesforceBaseUrl().toExternalForm();
            System.debug('domainURL: ' + domainURL);
            string baseURL =  '/services/data/v55.0/analytics/notifications?source=' + currRequest.source;
    
            // Set URL from domain and base url
            string url = domainURL + baseURL;
    
            // Set Session ID
            string sessionId =  Page.usf3__GenerateSessionIdForLWC.getContent().toString();
            // Fix Session Id
            sessionId = sessionId.substring(sessionId.indexOf('\n')+1);
            
            // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
            HttpRequest req = new HttpRequest();
            req.setEndpoint(url);
            req.setMethod('GET');
            req.setHeader('Accept', 'application/json');
            req.setHeader('Accept-Encoding', 'gzip, deflate, br');
            req.setHeader('Authorization', 'OAuth ' + sessionId);
    
            System.Debug('userSessionId: ' + sessionId);
        
            // Send the request, and return a response
            HttpResponse res = h.send(req);
    
            // Set Response Body
            string responseBody = res.getBody();
            System.Debug('responseBody: ' + responseBody);
            
            // replace time: with timeOfDay: in the response body
            responseBody = responseBody.replace('"time":', '"timeOfDay":');
    
            // Parse JSON Response
            List<mc_SubscriptionListDefinition> parsedResponse = (List<mc_SubscriptionListDefinition>)JSON.deserialize(responseBody, List<mc_SubscriptionListDefinition>.class);
            System.Debug('paredResponse: ' + parsedResponse);
            Results response = new Results();
            response.definition = parsedResponse;

            // Iterate through the list of subscriptions and set report name
            for( mc_SubscriptionListDefinition currSubscription : response.definition ) {
                // Set Report Name
                currSubscription.reportName = [SELECT Name FROM Report WHERE Id = :currSubscription.recordId].Name;

                // Set Action Type
                currSubscription.actionType = currSubscription.thresholds[0].type;

                // Set Exclude Snapshot
                currSubscription.excludeSnapshot = currSubscription.thresholds[0].actions[0].configuration.excludeSnapshot;

                // Set Recipent Count
                currSubscription.recipientCount = currSubscription.thresholds[0].actions[0].configuration.recipients.size();

                // Set Time of Day (if applicable) with elvis operator
                currSubscription.timeOfDay = currSubscription.schedule.details.timeOfDay != null ? currSubscription.schedule.details.timeOfDay : null;

                // Set Days of Week (if applicable) with elvis operator
                currSubscription.daysOfWeek = currSubscription.schedule.details.daysOfWeek != null ? currSubscription.schedule.details.daysOfWeek.toString() : null;

                // Set Days of Month (if applicable) with elvis operator
                currSubscription.daysOfMonth = currSubscription.schedule.details.daysOfMonth != null ? currSubscription.schedule.details.daysOfMonth.toString() : null;
                
                // Set Week In Month (if applicable) with elvis operator
                currSubscription.weekInMonth = currSubscription.schedule.details.weekInMonth != null ? currSubscription.schedule.details.weekInMonth : null;

                // Set Frequency
                currSubscription.frequency = currSubscription.schedule.frequency;
            }

            // Stringify the response for use in DataTable
            response.definition_string = JSON.serialize(response.definition);

            responseWrapper.add(response);
    
        }



        // Return the list of records
        return responseWrapper;

    }

    public class Request {
        @InvocableVariable(required=true)
        public string source;

        @InvocableVariable
        public string ownerId;

        @InvocableVariable
        public string recordId;
    }

    public class Results {
        @InvocableVariable
        public List<mc_SubscriptionListDefinition> definition;

        @InvocableVariable
        public string definition_string;
    }

    public static mc_SubscriptionListDefinition parse(String json){
        return (mc_SubscriptionListDefinition) System.JSON.deserialize(json, mc_SubscriptionListDefinition.class);
    }

        // static testMethod void testParse() {
        //     String json='[{"active":true,"createdDate":"2022-10-12T01:10:52Z","deactivateOnTrigger":false,"id":"0Au3C00000000kdSAA","lastModifiedDate":"2022-10-12T01:10:52Z","name":"Notification","owner":{"id":"0055e000001mKpC","name":"Andy Haas"},"recordId":"00O5e000008VZezEAG","runAs":null,"schedule":{"details":{"daysOfWeek":["tue"],"time":20},"frequency":"weekly"},"source":"lightningReportSubscribe","thresholds":[{"actions":[{"configuration":{"excludeSnapshot":false,"recipients":[{"id":"0055e000001mKpC","displayName":"Andy Haas","type":"user"}]},"type":"sendEmail"}],"conditions":null,"type":"always"}]}]'+
        //     '';
        //     ResultSubscriptionList obj = parse(json);
        //     System.assert(obj != null);
        // }
    

}