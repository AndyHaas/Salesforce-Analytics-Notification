@isTest
public class mc_SubscriptionData_ConversionTest {
	@isTest
    public static void mc_SubscriptionData_Conversion_test(){
        list<mc_SubscriptionData_Conversion.Request> rqLst = new list<mc_SubscriptionData_Conversion.Request>();
        mc_SubscriptionData_Conversion.Request rq = new mc_SubscriptionData_Conversion.Request();
        rq.definitionDetails = new list<mc_SubscriptionListDefinition>();
        mc_SubscriptionListDefinition sbDef = new mc_SubscriptionListDefinition();
        rq.definitionDetails.add(sbDef);
        rqLst.add(rq);
        mc_SubscriptionData_Conversion.mc_SubscriptionData_Conversion(rqLst);
    }
}