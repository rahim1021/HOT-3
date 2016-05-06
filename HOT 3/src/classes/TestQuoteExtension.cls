/****************************************************************************** 
 * This class is the Test class for QuotePDF VisualForce Page.
 *
 * Functionality: this class acts as Test Class
 *   Different Test Cases Are designed And asserted
 *
 * Revision History: 
 *
 * Version     Author               Date         Description 
 * 1.0         Abdulrahim Mulla     4/25/2016   All Functionality Acheived 
 *
 *******************************************************************************/
@istest public class TestQuoteExtension {
    private static final String PAGE_REFERENCE = 'Page.myPage';
    static testmethod void testQuotePdf (){

        // Data Creation
        ApexPages.StandardController stdController ;
        List<QuoteLineItem> listRecordsQuoteLineItem = TestDataFactory.createQuoteLineItemTestRecord(1,'test');
        insert listRecordsQuoteLineItem;

        QuoteExtension objQuoteExtension = new QuoteExtension(stdController);
        Test.setCurrentPageReference(new PageReference(PAGE_REFERENCE));

        // Actual Testing
        Test.startTest();
            objQuoteExtension.getOrganizationEmail();
            objQuoteExtension.getListQuoteLineItem();
            objQuoteExtension.getOrganizationName();
        Test.stopTest();

        // Result Asserts
        List<QuoteLineItem> listQuoteLineItem = [select id from QuoteLineItem];
        system.assertEquals(listQuoteLineItem.size(), 1);
        
    }
}