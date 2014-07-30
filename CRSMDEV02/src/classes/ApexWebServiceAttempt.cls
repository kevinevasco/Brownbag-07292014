global class ApexWebServiceAttempt{
    webService static String welcomeTheWorld() {
        String welcomeString = 'Hello World!!';

        List<DummyGift__c> DummyGiftList = new List<DummyGift__c>();
        List<Promotion_Gift__c> dgx = [SELECT gift_name__r.gift_code__c, promotion__r.promotion_code__c,Promotion_Quantity__c,Redeemed_Quantity__c  FROM Promotion_Gift__c];
        Integer i=0;
        for(Promotion_Gift__c dgx2 : dgx){
            System.debug(i++);
            DummyGift__c DummyGiftRecord = new DummyGift__c();
            DummygiftRecord.gift_code__c = dgx2.gift_name__r.gift_code__c ;
            System.debug(dgx2.gift_name__r.gift_code__c);
            DummygiftRecord.promotion_code__c = dgx2.promotion__r.promotion_code__c ;
            System.debug(dgx2.promotion__r.promotion_code__c);
            DummygiftRecord.promotion_quantity__c = dgx2.Promotion_Quantity__c;
            System.debug(dgx2.Promotion_Quantity__c);
            DummygiftRecord.redeemed_quantity__c = dgx2.Redeemed_Quantity__c ;  
            System.debug(dgx2.Redeemed_Quantity__c);    
            DummyGiftList.add(DummygiftRecord);
        }
        insert DummyGiftList;
        return welcomeString;
    }
}