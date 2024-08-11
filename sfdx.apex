public class ApiInvoker {

    @InvocableMethod(label='Flow Scale Test API' description='Calls the Flow Scale Test API endpoint with a batch of records and returns outcomes')
    public static List<ApiResponse> callFlowScaleTestApi(List<ApiRequest> requests) {
        // Define the API endpoint
        String apiEndpoint = 'https://warm-wave-54046-ca3520f5f083.herokuapp.com/api/log';
        
        // Convert the list of requests to JSON
        String jsonBody = JSON.serialize(requests);
        
        // Create the HTTP request
        HttpRequest req = new HttpRequest();
        req.setEndpoint(apiEndpoint);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(jsonBody);
        
        // Create the HTTP object and send the request
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        System.debug('***Got response:' + res.getBody());
        
        // Prepare the list to hold responses
        List<ApiResponse> apiResponses = new List<ApiResponse>();
        
        if (res.getStatusCode() == 200) {
            // Parse the JSON response
            // Parse the JSON string into a list of JSON objects
            List<Object> jsonObjList = (List<Object>) JSON.deserializeUntyped(res.getBody());
            
            // Loop through the list of objects
            for (Object jsonObj : jsonObjList) {
                // Cast the object to a Map to access properties
                Map<String, Object> objMap = (Map<String, Object>) jsonObj;
                String outcome = (String) objMap.get('Outcome');
                System.debug('Outcome: ' + outcome); // Will print "Outcome: include" twice
                
                ApiResponse apiResponse = new ApiResponse();
                apiResponse.Outcome = outcome;
                apiResponses.add(apiResponse);
                
            }            
                        
        } else {
            System.debug('Failed with status: ' + res.getStatusCode() + ' and response: ' + res.getBody());
            // Handle error responses or add default values
            for (Integer i = 0; i < requests.size(); i++) {
                ApiResponse apiResponse = new ApiResponse();
                apiResponse.Outcome = 'error';
                apiResponses.add(apiResponse);
            }
        }
        
        
        return apiResponses;
    }
    
    public class ApiRequest {
        @InvocableVariable(label='CampaignId' description='The Campaign ID')
        public String CampaignId;
        
        @InvocableVariable(label='ContactId' description='The Contact ID')
        public String ContactId;
    }
    
    public class ApiResponse {
        @InvocableVariable(label='Outcome' description='The Outcome returned by the API')
        public String Outcome;
    }
}
