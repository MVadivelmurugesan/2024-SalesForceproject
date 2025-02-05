public class CurrencyConverter {

    public static void fetchCurrencyData(String currencyCode) {
        try {
            String apiKey = 'cur_live_n96xOz197Vb2YSQ1xYIkjszcTzMP3SW60EAgrpYe';
            String endpoint = 'https://api.currencyapi.com/v3/currencies?apikey=' + apiKey;

            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpoint);
            request.setMethod('GET');

            HttpResponse response = http.send(request);

            if (response.getStatusCode() == 200) {
                Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                Map<String, Object> data = (Map<String, Object>) result.get('data');
                Map<String, Object> currencyData = (Map<String, Object>) data.get(currencyCode);
               
                if (currencyData != null) {
                    String currencyName = (String) currencyData.get('name');
                    String symbol = (String) currencyData.get('symbol');
                    String nativeSymbol = (String) currencyData.get('symbol_native');
                    Integer decimalDigits = (Integer) currencyData.get('decimal_digits');
                    List<Object> countryList = (List<Object>) currencyData.get('countries');

                  
 					System.debug('countryList Name: ' + countryList);
                    System.debug('Currency Name: ' + currencyName);
                    System.debug('Symbol: ' + symbol);
                    System.debug('Native Symbol: ' + nativeSymbol);
                    System.debug('Decimal Digits: ' + decimalDigits);
                    System.debug('Currency Name===>: ' + currencyData.get('name'));


                } else {
                    System.debug('Currency code not found.');
                }
            } else {
                System.debug('Failed to retrieve currency data. Status code: ' + response.getStatusCode());
            }
        } catch (Exception e) {
            System.debug('Error: ' + e.getMessage());
        }
    }
}