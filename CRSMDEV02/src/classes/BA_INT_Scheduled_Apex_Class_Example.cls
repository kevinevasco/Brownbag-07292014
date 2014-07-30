global class BA_INT_Scheduled_Apex_Class_Example Implements Schedulable
{
   global void execute(SchedulableContext sc)
    {
        String query = 'SELECT Promotion_Quantity__c,Redeemed_Quantity__c, promotion__r.promotion_code__c, gift_name__r.gift_code__c FROM Promotion_Gift__c';
        id batchinstanceid = database.executeBatch(new BA_INT_Batch_Apex_Example(query));   
    }
           
}