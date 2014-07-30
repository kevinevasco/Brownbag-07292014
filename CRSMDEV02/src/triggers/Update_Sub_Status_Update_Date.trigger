trigger Update_Sub_Status_Update_Date on Case (before insert, before update) {


    if (trigger.isInsert){
        for (Case c: Trigger.new) {            
            c.Case_Sub_Status_Last_Modified_Date__c = System.Today();                                        
        }            
    }else{
        for (Case c: Trigger.new) {            
            Case oldCase = Trigger.oldMap.get(c.ID);
            if (c.Case_Sub_Status__c != oldCase.Case_Sub_Status__c) {
                c.Case_Sub_Status_Last_Modified_Date__c = System.Today();
            }                        
        } 
    }       
}