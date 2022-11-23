public with sharing class mc_SubscriptionData_Conversion {
    @InvocableMethod(label='Convert Subscription Data' description='Convert Subscription Data' category='Analytic Subscription')
    public static List<Results> mc_SubscriptionData_Conversion(List<Request> requestList) {
        Results response = new Results();
        // Set Response Wrapper
        List<Results> responseWrapper = new List<Results>();
        for( Request currRequest : requestList ) {
            response.definitionDetails_string = JSON.serialize(currRequest.definitionDetails);

            responseWrapper.add(response);
        }

        return responseWrapper;
    }


    public class Request {
        @InvocableVariable(required=true)
        public List<mc_SubscriptionListDefinition> definitionDetails;
    }

    public class Results {
        @InvocableVariable
        public string definitionDetails_string;
    }
}