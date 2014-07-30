global class TEST_PdfCreationBatch implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
    /*
     *  Created By: Accenture -  Jeffrey Teves
     *  Created Date: June 25, 2014
     *  Purpose:
     *      - POC Batch Class for creating bulk PDF documents
     *  Considerations:
     *      1. Since we are performing callouts to insert records, we will need to limit transaction to only process 10 records at a time - maximum of 10 calouts per executemethod invocation
     *		2. Current implementation: One callout per record - one attachment is created per callout.
	 *		3. We could update the WebService class to handle/create multiple records per invocation - thus limiting the number of total batch chunks and callouts
	 *		4. Possible Enhancement: Capture success/failures in Webservice class and relay back to the batch apex for processing.
     */
    
    String query, endpointUrl, userName, password, sessionId;
    public final String NS_SOAP = 'http://schemas.xmlsoap.org/soap/envelope/';
    public final String NS_SF = 'urn:partner.soap.sforce.com';
    
    global TEST_PdfCreationBatch(String userName, String password) {
       this.userName = userName;
       this.password = password;
       endpointUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/insertPdf';
    }
    
    global TEST_PdfCreationBatch(String sessionId) {
       this.sessionId = sessionId;
       endpointUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/insertPdf';
    }
    
    public String login() {
        // As per http://wiki.developerforce.com/page/Enterprise_Login
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');   
        req.setTimeout(60000);
        req.setEndpoint('https://www.salesforce.com/services/Soap/u/29.0');
        req.setHeader('Content-Type', 'text/xml;charset=UTF-8');        
        req.setHeader('SOAPAction', '""');
        req.setBody('<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/"><Header/><Body><login xmlns="urn:partner.soap.sforce.com"><username>' +userName+ '</username><password>' + password + '</password></login></Body></Envelope>');        
        HttpResponse res =  new Http().send(req);
        if(res.getStatusCode() != 200)
        {
            //failed login 
        }
        // As per http://wiki.developerforce.com/page/Enterprise_Login
        Dom.Document responseDocument = res.getBodyDocument();
        Dom.Xmlnode rootElm = responseDocument.getRootElement(); // soapenv:Envelope
        Dom.Xmlnode bodyElm = rootElm.getChildElement('Body', NS_SOAP); // soapenv:Body 
        Dom.Xmlnode loginResponseElm = bodyElm.getChildElement('loginResponse', NS_SF); // loginResponse
        Dom.Xmlnode resultElm = loginResponseElm.getChildElement('result', NS_SF); // result
        Dom.Xmlnode sessionIdElm = resultElm.getChildElement('sessionId', NS_SF); // sessionId
        return sessionIdElm.getText();
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
       
        query = 'SELECT Id, Name FROM TEST_PdfGenerationBatchObject__c';
        return Database.getQueryLocator(query);
    }
     
    global void execute(Database.BatchableContext BC, List<TEST_PdfGenerationBatchObject__c> scope){
		
        //String sessionId = login();
            
        for(TEST_PdfGenerationBatchObject__c batchObject : scope) {
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpointUrl);
            req.setMethod('POST');
            req.setHeader('Authorization', 'OAuth ' + sessionId);
            req.setHeader('Content-Type','application/json');
    
            Map<String,String> postBody = new Map<String,String>();
            postBody.put('parentId', batchObject.Id);
            postBody.put('pdfName', batchObject.Name + '.pdf');
            String reqBody = JSON.serialize(postBody);
    
            req.setBody(reqBody);
            Http http = new Http();
            HttpResponse response = http.send(req);
        }
    }
    
    global void finish(Database.BatchableContext BC){
        //List<Daily_Vendor_Publication_Data__c> consolidatedDataToInsert = new List<Daily_Vendor_Publication_Data__c>();
        
    }
    
}