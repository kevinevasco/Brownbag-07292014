global class TEST_PopConsolidationBatch implements Database.Batchable<sObject>, Database.Stateful {
    /*
     *  Created By: Accenture -  Jeffrey Teves
     *  Created Date: May 26, 2014
     *  Purpose:
     *      - POC Batch Class for POP Consolidation/Vendor daily credit computation 
     *      - Aggregate total number of Total Direct Subscription Copies and Sponsored Copies per Publication + Vendor
     *  Output Objects:
     *      - Daily Vendor/Publication Data -- individual fields, contain total credit for vendors as well as total publication copies
     *      - POP-Vendor DrCr Normalized Data -- normalized data to be fetched by interface, values derived from Daily Vendor/Publication Data
     *  Assumptions:
     *      - Sponsored - checkbox field on subscription to determine if sponsored
     */
    
    /*-- map of publication name and Publication Daily Data - for charges computation --*/
    global Map<String, Daily_Publication_Data__c> publicationDataMap;
    global String query = '';
    /*-- list of publication codes - fetched form Custom Settings -*/
    private Set<String> publicationNames;
    /*-- Map<VendorId, Map<Publication-Special?, Total>> -- Count of publications per vendors, grouped by special delivery flag --*/
    Map<String, Map<String, Integer>> vendorPublicationAggregateMap;
    /*- Map<Vendorid, Map<Pulication Code, Count>> -- Count of Sponsored publications per vendor --*/
    Map<String, Map<String, Integer>> vendorSponsoredPublicationsMap;
    
    global TEST_PopConsolidationBatch() {
        publicationNames = new Set<String>();
        /*
         * fetch list of publication codes from Custom Settings
         */
        List<Publication_Data__c> publications = Publication_Data__c.getall().values();
        for(Publication_Data__c publication : publications) {
            publicationNames.add(publication.Publication_Name__c);
        }
        /*
         * retrieve mapping of publication to daily publication data
         */
        //need to change key to Publication Code
        publicationDataMap = new Map<String, Daily_Publication_Data__c>();
        for(Daily_Publication_Data__c pData : [SELECT Id, Name, Cover_Price__c, Commission_Rate__c, Commission_Rate_Special__c, Daily_Insert_Value__c, Daily_Page_Value__c, Publication_Date__c, Publication__c, Publication__r.Publication_Code__c, Publication__r.Name FROM Daily_Publication_Data__c WHERE Publication_Date__c = TODAY]) {
            publicationDataMap.put(pdata.Publication__r.Publication_Code__c, pData);
        }
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        /*
         *  Query will fetch all Subscription Products and Charges under "Active" Subscriptions, order by Vendor, then by Publication Code
         */
        query = 'SELECT Id, Publication_Code__c, Zuora__Quantity__c, Zuora__Subscription__r.Sponsored__c, Zuora__Subscription__r.Special_Delivery__c, Zuora__ProductName__c, Zuora__Subscription__r.Vendor__c FROM Zuora__SubscriptionProductCharge__c WHERE Publication_Code__c IN :publicationNames AND Zuora__Subscription__r.Zuora__Status__c = \'Active\' Order By Zuora__Subscription__r.Vendor__c, Publication_Code__c';
        return Database.getQueryLocator(query);
    }
     
    global void execute(Database.BatchableContext BC, List<Zuora__SubscriptionProductCharge__c> scope){
        //Map<String, Integer> aggregations = new Map<String, Integer>();
        Set<String> externalIds = new Set<String>(); 
        vendorPublicationAggregateMap = new Map<String, Map<String, Integer>>();
        vendorSponsoredPublicationsMap = new Map<String, Map<String, Integer>>();
        /*-- map to hold new records as well as records created on the previous batch chunks --*/
        /*-- common identifier is the external Id, these records will be upserted at the end of every batch execution --*/
        Map<String, Daily_Vendor_Publication_Data__c> dailyDataToUpsertMap = new Map<String, Daily_Vendor_Publication_Data__c>();
        String pubName = '', vendorId = '', externalId = '';
        Boolean isSpecialDelivery;
        
        for(Zuora__SubscriptionProductCharge__c subsProductCharge : scope) {
            externalIds.add(String.valueOf(Date.today()) + '-' + subsProductCharge.Zuora__Subscription__r.Vendor__c + '-' + subsProductCharge.Publication_Code__c);
            pubName = subsProductCharge.Publication_Code__c + '-' + String.valueOf(subsProductCharge.Zuora__Subscription__r.Special_Delivery__c);
            vendorId = subsProductCharge.Zuora__Subscription__r.Vendor__c;
            
            /*
             *  Aggregate total number of publications (special delivery/non special delivery) per vendor
             */
            if(vendorPublicationAggregateMap.containsKey(vendorId)) {
                if(vendorPublicationAggregateMap.get(vendorId).containsKey(pubName)) {
                    vendorPublicationAggregateMap.get(vendorId).put(pubName, vendorPublicationAggregateMap.get(vendorId).get(pubName) + 1);
                }
                else {
                    vendorPublicationAggregateMap.get(vendorId).put(pubName, 1);
                }
            }
            else {
                vendorPublicationAggregateMap.put(vendorId, new Map<String, Integer>{pubName => 1});
            }
            
            /*
             *  Aggregate number of sponsored subscriptions per vendor
             *  Assumption: There is a flag (Sponsored?) on Subscription object to identify sponsored subscriptions
             */
            pubName = subsProductCharge.Publication_Code__c;
            if(subsProductCharge.Zuora__Subscription__r.Sponsored__c) {
                if(vendorSponsoredPublicationsMap.containsKey(vendorId)) {
                    if(vendorSponsoredPublicationsMap.get(vendorId).containsKey(pubName)) {
                        vendorSponsoredPublicationsMap.get(vendorId).put(pubName, vendorSponsoredPublicationsMap.get(vendorId).get(pubName) + 1);
                    }
                    else {
                        vendorSponsoredPublicationsMap.get(vendorId).put(pubName, 1);
                    }
                }
                else {
                    vendorSponsoredPublicationsMap.put(vendorId, new Map<String, Integer>{pubName => 1});
                }
            }
            
        }
        
        for(Daily_Vendor_Publication_Data__c dvpd : [SELECT Id, External_Id__c, Copies_Special_Delivery__c, Copies_Non_Special_Delivery__c, Total_Direct_Subscription_Copies__c, Total_Credit__c, Publication_Code__c FROM Daily_Vendor_Publication_Data__c WHERE External_Id__c IN :externalIds]) {
            dailyDataToUpsertMap.put(dvpd.External_Id__c, dvpd);
        }
        
        /*
         *  Iterate through aggregated publication count and create daily data
         */
        for(String vendor : vendorPublicationAggregateMap.keySet()) {
            for(String key : vendorPublicationAggregateMap.get(vendor).keySet()) {
                //logic for commission computation - different handling for special delivery
                //key value is a concatenation of publication code and special delivery (true or false)
                Daily_Vendor_Publication_Data__c dvpd;
                pubName = key.substring(0, key.indexOf('-'));
                isSpecialDelivery = key.substring(key.indexOf('-') + 1, key.length()).equalsIgnoreCase('true');
                externalId = String.valueof(Date.today()) + '-' + vendor + '-' + pubName;
                
                if(dailyDataToUpsertMap.containsKey(externalId)) {
                    dvpd = dailyDataToUpsertMap.get(externalId);
                }
                else {
                    dvpd = new Daily_Vendor_Publication_Data__c(
                        External_Id__c = externalId,
                        Vendor__c = vendor,
                        Type__c = 'POP/Vendor Daily Data',
                        Date__c = Date.today(),
                        Publication_Code__c = pubName,
						Copies_Special_Delivery__c  = 0,
						Copies_Non_Special_Delivery__c = 0,
						Sponsored_Copies__c = 0
                        //Total_Credit__c = 0
                    );
                }
                
                if(publicationDataMap.containsKey(pubName)) {
                    dvpd.Publication__c = publicationDataMap.get(pubName).Publication__c;
                }
                
                /*
                 *  fetch number of special delivery/non-special delivery copies
                 */
                if(isSpecialDelivery) {
                    dvpd.Copies_Special_Delivery__c = dvpd.Copies_Special_Delivery__c + vendorPublicationAggregateMap.get(vendor).get(key);
                }
                else {
                    dvpd.Copies_Non_Special_Delivery__c = dvpd.Copies_Non_Special_Delivery__c + vendorPublicationAggregateMap.get(vendor).get(key);
                }
				
				/*
                 *  fetch number of sponsored copies
                 */
				if(vendorSponsoredPublicationsMap.containsKey(dvpd.Vendor__c)) {
					if(vendorSponsoredPublicationsMap.get(dvpd.Vendor__c).containsKey(dvpd.Publication_Code__c)) {
						dvpd.Sponsored_Copies__c = dvpd.Sponsored_Copies__c + vendorSponsoredPublicationsMap.get(dvpd.Vendor__c).get(dvpd.Publication_Code__c);
					}
				}
				
                dailyDataToUpsertMap.put(dvpd.External_Id__c, dvpd);
            }
        }
        
        /*
         * Iterate through Upsert list then calculate individual commission/credits.
		 * Create corresponding normalized data
         */
        Daily_Publication_Data__c dailyPubData;
		System.debug('UpsertList: ' + dailyDataToUpsertMap);
        for(Daily_Vendor_Publication_Data__c dvpd : dailyDataToUpsertMap.values()) {
			Decimal copies;
            if(publicationDataMap.containsKey(dvpd.Publication_Code__c)) {
                dailyPubData = publicationDataMap.get(dvpd.Publication_Code__c);
                copies = dvpd.Copies_Non_Special_Delivery__c + dvpd.Copies_Special_Delivery__c;
                dvpd.Insertion__c = dailyPubData.Daily_Insert_Value__c * copies;
                dvpd.Pagination__c = dailyPubData.Daily_Page_Value__c * copies;
                dvpd.Commission_Special_Delivery__c = dailyPubData.Commission_Rate_Special__c * dvpd.Copies_Special_Delivery__c;
                dvpd.Commission_Non_Special_Delivery__c = dailyPubData.Commission_Rate__c * dvpd.Copies_Non_Special_Delivery__c;
            }
            else {
                //logic for publication without daily transactional data, where to get rates from?
            }
        }
        
        upsert dailyDataToUpsertMap.values() External_Id__c;
        
    }
    
    global void finish(Database.BatchableContext BC){
        //List<Daily_Vendor_Publication_Data__c> consolidatedDataToInsert = new List<Daily_Vendor_Publication_Data__c>();
        
    }
    
}