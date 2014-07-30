public with sharing class xTestEBM_sendToZBilling
{
    private ApexPages.StandardController standardController;
 
    public xTestEBM_sendToZBilling(ApexPages.StandardController standardController)
    {
        this.standardController = standardController;
    }
 
    public PageReference sendToZBilling()
    {
        // Apex code for handling record from a Detail page goes here
        Id recordId = standardController.getId();
        Map<String, String> x = new Map<String, String>();
        x = sendToZBillingMethog(string.valueof(recordId));
        return null;
    }
    
    public Map<String, String> sendToZBillingMethog(string quotId){
        String xx= '';  
        try{
            System.debug('IIIIIIInside Sent to ZBilling in New page');
            ID quoteId = quotId;
            final Map<String, String> finalRes;

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
                
                 xx  = resultString;
            }            
           
            //System.assertequals(xx,'Exception in Z-Billing');
            return finalRes;
        } 
        catch(Exception e){
            System.debug('Exception in Z-Billing '+ e);
            return null;
        }

    }

}


/*
Global class xTestEBM_sendToZBilling{
    public Map<String, String> sendToZBilling(string quotId){

        try{
            System.debug('IIIIIIInside Sent to ZBilling in New page');
            ID quoteId = quotId;
            final Map<String, String> finalRes;

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
            return null;
        }

    }

}
*/