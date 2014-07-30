public with sharing class UpdateZuoraField{

String BillingAccount;
String accountId;

    public String getBillingAccount(String accountId){

        String billingAccount = [SELECT Zuora__Zuora_Id__c FROM Zuora__CustomerAccount__c WHERE Zuora__Account__c =: accountId].Zuora__Zuora_Id__c; 

        return billingAccount;

    }

    public void updateFieldCallOut(){
    
    Zuora.zApi zApiInstance = new Zuora.zApi();
    zApiInstance.zlogin();

        BillingAccount = getBillingAccount(accountID);

        Zuora.zObject zAccount = new Zuora.zObject('Account'); 
        zAccount.setValue('Id', BillingAccount);
        zAccount.setValue('Status', 'Draft');
        List<Zuora.zObject> objs = new List<Zuora.zObject> {zAccount};
        List<Zuora.zApi.SaveResult> results = zApiInstance.zupdate(objs);
        
    }





}