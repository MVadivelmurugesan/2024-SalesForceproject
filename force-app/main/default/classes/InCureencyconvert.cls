Global class InCurrencyconvert implements Database.Batchable<SObject> {
   Global Database.QueryLocator Start (Database.BatchableContext bc){
        String query ='Select Id,Amount,INR_Amount__c From Opportunity ';
        System.debug('query'+query);
        return Database.getQueryLocator(query);
   }
   Global Void Excute(Database.BatchableContext bc ,List<Opportunity> op){
        String endpoint='https://api.currencylayer.com/live?access_key=d0a82306075fa5eb189ca66f09addf38&source=USD&currencies=INR&format=1';
        Http H=new Http();
        HttpRequest hr=new HttpRequest();
        HttpResponse hs=new HttpResponse();
        hr.setEndpoint(endpoint);
        hr.setMethod('GET');
        hs=H.send(hr);
        System.debug('endpoint'+endpoint);
        System.debug('Body'+hs.getBody());
        String result=hs.getBody();

        Decimal Amt;
        System.JSONParser jp=JSON.createParser(result);
        while (jp.nextToken()!=null) {
            if (jp.getText()=='USDINR') {
                Amt=(Decimal)jp.getDecimalValue();
                System.debug('Amt'+Amt);
            }
        }
        for (opportunity O : op) {
            O.INR_Amount__c='RS.' + (Amt*O.Amount);
        }
        update op;
   }
   Global void finish(Database.BatchableContext bc){

   }
}