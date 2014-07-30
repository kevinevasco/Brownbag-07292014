global class TEST_PdfCreationBatch2 implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
    /*
     *  Created By: Accenture -  Jeffrey Teves
     *  Created Date: June 25, 2014
     *  Purpose:
     *      - POC Batch Class for creating bulk PDF documents
     */
    
    String query;

    
    global TEST_PdfCreationBatch2() {
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        query = 'Select Name from TEST_PdfGenerationBatchObject__c Order by Id ASC Limit 5000';
        return Database.getQueryLocator(query);
    }
     
    global void execute(Database.BatchableContext BC, List<TEST_PdfGenerationBatchObject__c> scope){
		String logoUrl = 'https://c.cs6.content.force.com/servlet/servlet.ImageServer?id=015N00000002ulS&oid=00DN0000000PmPG&lastMod=1403676977000';
        List<Attachment> insertList = new List<Attachment>();
        for(TEST_PdfGenerationBatchObject__c batchObject : scope) {
             Attachment att = new Attachment(
                parentId = batchObject.id,
                Name = '3rd Batch: ' + batchObject.Name + '.pdf'
            );
            String htmlString = '<html><head><meta charset=UTF-8/></head><body><br/><br/><br/><br/><br/><br/><br/><p><img src="' + logoUrl + '"><br/><br/></img></p><h1>Hello ' + batchObject.Name + '</h1></body></html>';
            att.body = Blob.toPdf(htmlString);
            insertList.add(att);
        }
        insert insertList;
    }
    
    global void finish(Database.BatchableContext BC){
        //List<Daily_Vendor_Publication_Data__c> consolidatedDataToInsert = new List<Daily_Vendor_Publication_Data__c>();
        
    }
    
}