public class SPH_AddressBL{


    public void updateAddressFields(Map<Id,Address__c> addressMap, Boolean isInsert){
      
     Set<Id> addressesId = addressMap.keySet();
     Map<Id,Id> SingpostIdToAddressId = new Map<Id,Id>();
     Set<Id> postalCode = new Set<Id>();
     
     List<SingPost_Address__c> singpostAdd = new List<SingPost_Address__c>();
     
         for (Id addressId : addressesId ){
          postalCode.add(addressMap.get(addressId).Postal_Code__c);
          SingpostIdToAddressId.put(addressMap.get(addressId).Postal_Code__c,addressId); // map of postal code and address Id
         }
         system.debug('---Test1---' + postalCode);
         system.debug('---Test2---' + SingpostIdToAddressId);
         
         singpostAdd = [SELECT Id,Address_Type__c,Building_Name__c,Building_Number__c,/*Country_name__c,*/Number_of_units__c,/*Postage_zone__c,*/
                                             Postal_Code_Country_Code__c,Service_Number__c,Singpost_Building_Code__c,Singpost_Street_code__c,Street_Name__c,
                                             Walkup_Indicator__c/*,Zone_code__c*/ from SingPost_Address__c WHERE Id IN: postalCode];                                                        
         system.debug('---Test3---' + singpostAdd );
         
        for (SingPost_Address__c singpost : singpostAdd ){
         Id addressId = SingpostIdToAddressId.get(singpost.id);
         system.debug('---Test4---' + addressId );
         addressMap.get(addressId).Building_Name__c = singpost.Building_Name__c;         
         addressMap.get(addressId).Address_Type__c = singpost.Address_Type__c;
         addressMap.get(addressId).Building_Number__c = singpost.Building_Number__c;
         //addressMap.get(addressId).Country_Code__c = singpost.Country_name__c;
         addressMap.get(addressId).Number_of_Units__c = singpost.Number_of_units__c;
         //addressMap.get(addressId). = singpost.Postage_zone__c;
         addressMap.get(addressId).Service_Number__c = singpost.Service_Number__c;
         addressMap.get(addressId).Street_Name__c = singpost.Singpost_Street_code__c;
         addressMap.get(addressId).Street_Name__c = singpost.Street_Name__c;
         addressMap.get(addressId).Walkup_Indicator__c = singpost.Walkup_Indicator__c;
         addressMap.get(addressId).Block_House_Number__c = singpost.Building_Number__c;
                 
        }    
    
    }    
}