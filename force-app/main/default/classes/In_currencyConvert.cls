global class In_currencyConvert implements Database.Batchable<SObject> {

    global Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT Id, Amount, INR_Amount__c FROM Opportunity';
        System.debug('Query: ' + query);
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<Opportunity> opplist) {
        String endpoint = 'https://api.currencylayer.com/live?access_key=d0a82306075fa5eb189ca66f09addf38&source=USD&currencies=INR&format=1';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response;
        Decimal conversionRate;

        try {
            request.setEndpoint(endpoint);
            request.setMethod('GET');
            response = http.send(request);
            System.debug('Response Body: ' + response.getBody());
            String result = response.getBody();

            // Parsing JSON response to extract the conversion rate
            System.JSONParser jp = JSON.createParser(result);
            while (jp.nextToken() != null) {
                if (jp.getText() == 'USDINR') {
                    jp.nextToken();
                    conversionRate = jp.getDecimalValue();
                    System.debug('Conversion Rate: ' + conversionRate);
                }
            }

            // Update opportunities with the converted amount
            for (opportunity O : opplist) {
               	O.INR_Amount__c='RS .' + (conversionRate*O.Amount);
            }
            update opplist;

        } catch (Exception e) {
            System.debug('Error in execute method: ' + e.getMessage());
        }
    }

    global void finish(Database.BatchableContext bc) {
        // Any post-batch processing logic can go here
        System.debug('Batch job completed successfully.');
    }
}