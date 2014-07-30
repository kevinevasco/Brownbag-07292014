trigger OverwriteRecordName on Address__c (before insert) {
    for( Address__c a : Trigger.new )
    {
        a.Name = a.Unit_Number__c + '|' + a.Postal_Code__c  ;
    }
}