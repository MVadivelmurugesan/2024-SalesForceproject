Global class INCURCON2 implements Database.Batchable<SObject> {
    global DataBase.Querylocator start(DataBase.BatchableContext bc){
        String Q='Select Id,Name,Amount,INR_Amount__c From Opportunity';
        System.debug('Query'+Q);
        return DataBase.getQuerylocator(Q);
    } 
    global void execute(DataBase.BatchableContext bc,List<Opportunity> opplist){
		  String endpoint ='https://api.currencyapi.com/v3/currencies?apikey=cur_live_n96xOz197Vb2YSQ1xYIkjszcTzMP3SW60EAgrpYe';   
      Http H=new Http();
      HttpRequest hr=new HttpRequest();
      HttpResponse hs=new HttpResponse();
      Decimal Rate=0;
     
      try {
        hr.setEndpoint(endpoint)   ;
        hr.setMethod('GET');
        hs=H.send(hr);
        System.debug('Endpoint'+endpoint);
        System.debug('Response==>'+hs.getBody());
        String result =hs.getBody();

        Map<String,Object> jsonresponse=( Map<String,Object>)JSON.deserializeUntyped(result);
        System.debug('jsonresponse==>'+jsonresponse);
        Map<String,Object> data=(Map<String,Object>)jsonresponse.get('data');
        System.debug('data==>'+data);
        Map<String,Object> usd=(Map<String,Object>)data.get('USD');
        System.debug('usd==>'+usd);
        Map<String,Object> Inr=(Map<String,SObject>)usd.get('INR');
        System.debug('usd==>'+usd);
		if (inr!=null) {
                Rate=(Decimal)inr.get('value');
                System.debug('Rate==>'+Rate);           
            } else {
              System.debug('Error==>Not Found');
    
            }
        for (Opportunity op : opplist) {
          if(op.Amount!=null){
            op.INR_Amount__c ='RS.' + (Rate * op.Amount);
          }
        }
        Upsert opplist;

      } catch (Exception e) {
        System.debug('Execute Method: Error in execute method - ' + e.getMessage());
      }
    }
    global void finish(DataBase.BatchableContext bc){
      System.debug('Finish Method: Batch job completed successfully.');

    }
}