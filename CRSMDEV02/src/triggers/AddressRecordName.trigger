trigger AddressRecordName on MicObj__c (before insert) {
    for( MicObj__c m : Trigger.new )
    {
        m.Name = m.Unit_Number__c + '|' + m.Postal_Code__c  ;
    }
}