public with sharing class Test_Update_Zuora_Subscription {
 	
    
    /*public void updateXuraoSub(){
		
		Zuora__Subscription__c c = [select Zuora__Zuora_Id__c from Zuora__Subscription__c where Zuora__Zuora_Id__c = '2c92c0f9474c5c3801475c9ee7516b9c'];
		system.debug(c);
		changeSuspendedFlagOnOldSuscription(string.valueof(c.id));
	}*/
    
    
    public static void changeSuspendedFlagOnOldSuscription(String subscriptionId){
		Zuora.zApi zApiInstance = new Zuora.zApi();

			//if(!Test.isRunningTest()){
				zApiInstance.setEndpoint('https://apisandbox.zuora.com/apps/services/a/53.0');
				zApiInstance.zlogin('karl.wilson.l.tan@sph.com.sg ','Olivia_0101');
				//}

                Zuora__Subscription__c c = [select Zuora__Zuora_Id__c from Zuora__Subscription__c where Zuora__Zuora_Id__c = '2c92c0f9474c5c3801475c9ee7516b9c'];
                system.debug('asdasd' + c);
				//Zuora.zObject tempSub = new Zuora.zObject('Subscription');
				//tempSub.setValue('Id', subscriptionId); //an existing account
				//tempSub.setValue('Id', c.id); //an existing account
				//tempSub.setValue('Version', '2');
				//List<Zuora.zObject> objs = new List<Zuora.zObject> {tempSub};
	   	
			//if(!Test.isRunningTest()){
				//List<Zuora.zApi.SaveResult> results = zApiInstance.zupdate(objs);
			//}
	}
}