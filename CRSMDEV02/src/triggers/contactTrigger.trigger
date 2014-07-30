trigger contactTrigger on Contact(before insert, before update) {
    
    SPH_ContactBL contactBL = new SPH_ContactBL();
    contactBL .updateAddressField(trigger.new);
}