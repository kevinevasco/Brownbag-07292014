public with sharing class Case_Handling {
	
	
	Public void Create_Case(list<Case> lCase){
		insert (lCase);
	}
	
	Public void Update_Case(list<Case> lCase){
		update (lCase);
	}
	
		
    
    public Case Create_Case(ID AccountId, ID SubscriberId,ID RecipientId, 
                       ID RecipientAddressId, ID OrderNoId,
                       ID RecType, string Subject, string Status, string SubStatus, 
    				   Date SubStartDate, Date SubEndDate, Date PopEarliestStartDate,
    				   String Remarks){
    	
    	Case cas = new Case();	        
        cas.AccountId =  AccountId;
        cas.Subscriber__c =  SubscriberId;
        cas.Recipient__c =  RecipientId;
        cas.Recipient_Address__c =  RecipientAddressId;
        cas.Order_Number__c =  OrderNoId;
        cas.Subject = Subject;
        //cas.RecordTypeID =  RecType;
        cas.Status =  Status;
        cas.Case_Sub_Status__c = SubStatus;
        cas.Remarks__c = Remarks;
        
        return cas;
    }
   
}