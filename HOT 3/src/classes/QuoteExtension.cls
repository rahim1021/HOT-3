/********************************************************************************
 * This class is the extension class for QuotePDF VisualForce Page.
 *
 * Functionality: this class acts as Extension
 *   Different Functions required for Generating PDF are Defined
 *
 * Revision History: 
 *
 * Version     Author               Date         Description 
 * 1.0         Abdulrahim Mulla     04/22/2016   All Functionality Acheived 
 *
 *********************************************************************************/
public class QuoteExtension {

    // General Declaration
    public String currentId {get;set;}
    ApexPages.StandardController sc1;

    // Constructor
    public QuoteExtension(ApexPages.StandardController controller)
    {
        currentId=ApexPages.currentPage().getParameters().get('id');
    }

    // Method : Retreive List of QuoteLineItems
    public List<QuoteLineItem> getListQuoteLineItem()
    {
        list<QuoteLineItem> listQuoteLineItem = [SELECT LineNumber, Quantity,
                                                        UnitPrice, TotalPrice,
                                                        Product2Id, ListPrice,
                                                        Discount
                                                 FROM QuoteLineItem 
                                                 WHERE QuoteId =: currentId
                                                ];
        return listQuoteLineItem ;
    }

    // Method : Retreive Organizations Email Id
    public String getOrganizationEmail() {
        return userInfo.getUserEmail();
    }

    // Method : Retreive Organizations Primary Contact Name
    public String getOrganizationName() {
        Organization objOrganization = new Organization();
        objOrganization = [Select primaryContact from Organization];
        return objOrganization.PrimaryContact;
    }

}