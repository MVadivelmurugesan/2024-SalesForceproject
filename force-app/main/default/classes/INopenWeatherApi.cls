public class INopenWeatherApi {
    Public Static void openweather(String City){
        try{
            	String C=City;
                String Api='79a66061785d4f0e55596c0c26a945b8';
                String endpoint='https://api.openweathermap.org/data/2.5/weather?q='+ C + Api;

                Http H=new Http();
                HttpRequest hr=new HttpRequest();
                HttpResponse hs=new HttpResponse();
                
                hr.setEndpoint(endpoint);
                hr.setMethod('GET');
                hs=H.send(hr);
                String body=hs.getBody();
                System.debug('body'+body);
                System.debug('body'+hs.getStatusCode());
            
        }catch(Exception e){
            System.debug('error==>'+e.getMessage());
        }
       
    }
}