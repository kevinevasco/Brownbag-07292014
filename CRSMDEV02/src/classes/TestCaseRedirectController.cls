public class TestCaseRedirectController {

    String rectype;
    
    public TestCaseRedirectController(ApexPages.StandardController controller) {
        rectype = ApexPages.currentPage().getParameters().get('RecordType');
    }
    
    
    public pageReference redirect() {
        PageReference pRef = new PageReference('/500/e?RecordType=' + rectype);
        pRef.getParameters().put('nooverride','1');
        return pRef;
    }
        
}