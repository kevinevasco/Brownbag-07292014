@RestResource(urlMapping='/insertPdf/*')
Global class TEST_InsertPdfAttachment{
    /*
     *  Created By: Accenture -  Jeffrey Teves
     *  Created Date: June 25, 2014
     *  Purpose:
     *      - Apex Class exposed as Rest Resource. This will allow getting the content of a PDF page through Batch Apex.
     *  Accepts: Id of the record to fetch the PDF from
     *  Output: Inserts PDF as attachment under the passed record Id.
     */
    @HttpPost
    global static void insertAttachment(String parentId, String pdfName) {

        PageReference ref = Page.POC_BatchPdfPage;
        ref.getParameters().put('id', parentId);
        Blob b = ref.getContent();

        Attachment att = new Attachment(
            parentId = parentId,
            Name = pdfName
        );
        att.body = b;
        
        insert att;

    }
}