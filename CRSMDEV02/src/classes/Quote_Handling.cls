public with sharing class Quote_Handling {


	Public void SubscriptionCreation(list<zqu__Quote__c> lQuote){
		
		
		if(lQuote.size()==1) {
		
			// This code send 1 quote to zBilling
			map<string,string> mSendResult = new map<string,string>();		
			For(zqu__Quote__c q: lQuote){
				mSendResult = sendToZBilling(string.valueof(q.id));
			}
		
		}else{
			// This code send multiple quote to zBilling	
			SendToZBilling_Bulk(lQuote);
			
		}
		
		
		
		
		
		
	}
	
	Public Void SendToZBilling_Bulk(list<zqu__Quote__c> lQuote){
		
		List<zqu.zQuoteUtil.ZBillingQuoteCollection> quotes = new List<zqu.zQuoteUtil.ZBillingQuoteCollection>();
		zqu.zQuoteUtil.ZBillingQuoteCollection quote = new zqu.zQuoteUtil.ZBillingQuoteCollection();
		
		
		For(zqu__Quote__c q: lQuote){
			quote.sfdcAccountId  = q.zqu__ZuoraAccountID__c;
			quote.zAccountId = q.zqu__Zuora_Account_Number__c;
			
			quote.quoteRequests = new List<zqu.zQuoteUtil.ZBillingQuoteRequest>();
			zqu.zQuoteUtil.ZBillingQuoteRequest req = new zqu.zQuoteUtil.ZBillingQuoteRequest();
			
			req.sfdcQuoteId = q.id;//'a0PM0000002hEMRMA2'; // SFDC Quote ID
			quote.quoteRequests.add(req);
			
			quotes.add(quote);
		}
				 
		
		List<zqu.zQuoteUtil.zBillingResult> results = zqu.zQuoteUtil.sendToZBilling(quotes);
		for ( zqu.zQuoteUtil.zBillingResult result : results ) {
  				System.debug( 'Result: QuoteId = ' + result.sfdcQuoteId + ', Success = ' + result.success + ', message = ' + result.message );
		}
	}
	
	
	
	
		// This method send one Quote to zBilling
    public Map<String, String> sendToZBilling(string quotId){
        final Map<String, String> finalRes;        
        try{
        	
            ID quoteId = quotId;
            
            if(quoteId<>null || quoteId==''){
                if (!System.Test.isRunningTest()) {                 
                    finalRes = zqu.zQuoteUtil.sendToZBilling(quoteId ,'New', true, null, null);  
                    System.debug('AAAAAAA'+finalRes);                             
                } else {  
                    finalRes = new map<string,string>();
                    finalRes.put('Success',Null);
                }
                
                String resultString = '';
                
                if(!finalRes.IsEmpty()){
                    for (String result : finalRes.values()){
                        resultString += result;
                    }            
                }
            }
            return finalRes;
        }        
        catch(Exception e){
            System.debug('Exception in Z-Billing '+ e);
            finalRes.put('Error', Null);
            return finalRes;
        }

    }


}