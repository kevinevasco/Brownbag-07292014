global class BA_INT_Batch_Apex_Example implements Database.Batchable<sObject>{

   global final String Query;
   global final String Entity;
   global final String Field;
   global final String Value;

   global BA_INT_Batch_Apex_Example(String q){
System.debug('XXXXXXXXXXXXXXXXXXXXXXXXXXXX');
      Query=q; 
   }

   global Database.QueryLocator start(Database.BatchableContext BC){
   System.debug(Logginglevel.ERROR,'qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq');
      return Database.getQueryLocator(Query);
   }

   global void execute(Database.BatchableContext BC, List<Promotion_Gift__c> scope){
   System.debug('Logginglevel.ERROR,jkehdkjhwhchdhklc');
   String tempo ='';
   List<BA_INT_DATA_POOL__c> tempx = new List<BA_INT_DATA_POOL__C>();
   
     for(Promotion_Gift__c s : scope){
     
     tempo ='';
     System.debug(Logginglevel.ERROR,'Promotion_Quantity__c'+' : '+ s.Promotion_Quantity__c);
     tempo = tempo + s.Promotion_Quantity__c+'","';
     System.debug(Logginglevel.ERROR,'Redeemed_Quantity__c'+' : '+ s.Redeemed_Quantity__c);
     tempo = tempo + s.Redeemed_Quantity__c+'","';
     System.debug(Logginglevel.ERROR,' promotion__r.promotion_code__c'+' : '+ s.promotion__r.promotion_code__c);
     tempo = tempo + s.promotion__r.promotion_code__c+'","';
     System.debug(Logginglevel.ERROR,'gift_name__r.gift_code__c'+' : '+ s.gift_name__r.gift_code__c);
     tempo = tempo + s.gift_name__r.gift_code__c;
     System.debug(tempo);
     
     BA_INT_DATA_POOL__c y = new BA_INT_DATA_POOL__c();
     y.put('export_data__c',tempo);
     y.put('group_id__c',s.gift_name__r.gift_code__c);
     y.put('insert_time__c',Date.today());
     y.put('job_id__c','JOBXXX');
     y.put('record_type__c','Detail');
     y.put('run_for_date__c',Date.today());

     
     tempx.add(y);
     }
     insert tempx;
    }

   global void finish(Database.BatchableContext BC){
   System.debug('ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ');
   }
}