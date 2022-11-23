@isTest
global class mc_GetUserSubscriptionLimitTest {
	@isTest
    global static void mc_GetUserSubscriptionLimitList_test(){
        list<mc_GetUserSubscriptionLimit.Request> rqlst = new list<mc_GetUserSubscriptionLimit.Request>();
        mc_GetUserSubscriptionLimit.Request rq = new mc_GetUserSubscriptionLimit.Request();
        rqlst.add(rq);
        test.startTest();
        test.setMock(httpCalloutMock.class, new mock());
        mc_GetUserSubscriptionLimit.mc_GetUserSubscriptionLimitList(rqlst);
        test.stopTest();
    }
    global class mock implements httpCalloutMock {
        global system.HttpResponse respond(system.HttpRequest req){
            system.HttpResponse res = new system.HttpResponse();
            res.setStatusCode(200);
            res.setStatus('OK');
            res.setHeader('Content-Type', 'application/json');
            string inp = '{"active": true}';
            res.setBody(inp);
            return res;
        }
    }
}