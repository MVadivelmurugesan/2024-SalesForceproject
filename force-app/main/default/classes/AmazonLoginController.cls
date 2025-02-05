global class AmazonLoginController {
	@AuraEnabled
    global Static String login(String Username ,String Password){
        
        String homepageUrl='https://nocompany-5e-dev-ed.my.site.com/s/';
        ApexPages.PageReference pageref=Site.login(Username,Password,homepageUrl);
        return pageref.getUrl();
    }
}