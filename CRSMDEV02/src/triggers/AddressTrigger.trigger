trigger AddressTrigger on Address__c(before insert, before update) {
    
    map<Id, Address__c> mapAddressNew;
    
    if(trigger.isBefore)
    {
       mapAddressNew= new map<Id, Address__c>();            
            for(Address__c address : trigger.new){
                mapAddressNew.put(address.Id, address);
            }
       //system.debug('--TriggerTest--' + mapAddressNew);         
       SPH_AddressBL addressBL = new SPH_AddressBL ();
       addressBL.updateAddressFields(mapAddressNew,trigger.isInsert);           
    }

}