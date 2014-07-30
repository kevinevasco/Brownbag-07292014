public class POC_BatchPdfPageController {
    
    public TEST_PdfGenerationBatchObject__c holder {get; set;}
    
    public POC_BatchPdfPageController() {
        String passedId = ApexPages.currentPage().getParameters().get('id');
        try {
            this.holder= [SELECT Name FROM TEST_PdfGenerationBatchObject__c WHERE Id = :passedId];
        }
        catch(QueryException e) {
            holder = new TEST_PdfGenerationBatchObject__c(Name = '');
        }
    }

}