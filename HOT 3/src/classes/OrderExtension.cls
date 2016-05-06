/********************************************************************************
 * This class is the extension class for OrderManagement VisualForce Page.
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
public class OrderExtension{

    // General Declaration
    public String currentId {get;set;}
    public List<Order> listOrdersOriginal {get;set;}
    public List<OrderWrapper> listOrdersWrappers {get;set;}
    private ApexPages.StandardController setController;
    private static final String STR_ACTIVATED = 'Activated';
    private static final String STR_DRAFT = 'Draft';

    // Constructor Declaration
    public OrderExtension() {
        currentId = ApexPages.currentPage().getParameters().get('id');
        listOrdersOriginal = new List<Order>();
        listOrdersWrappers = new List<OrderWrapper>();
        this.setController = setController;
    }

    // Method : get List of Orders
    public List<OrderWrapper> getOrderList() {
        if (listOrdersOriginal.isEmpty()) {
            listOrdersOriginal = getRecords(); 
            listOrdersWrappers = new List<OrderWrapper>();
            for (Order objOrder : listOrdersOriginal) {
                listOrdersWrappers.add(new OrderWrapper(objOrder, false));
            }
        }
        return listOrdersWrappers ;
    }

    // Wrapper Class
    public class OrderWrapper {

        public Order recordOrder {get; private set;}
        public Boolean isDelete {get; set;}

        public OrderWrapper(Order objOrder, Boolean boolDelete) {
           isDelete = boolDelete;
           recordOrder = objOrder;
        }
    }

    // Method : Save as well as Delete Orders
    public void SaveAcc() {

        Database.UpsertResult[] listUpsertResult;
        Database.DeleteResult[] listDeleteResult;
        Integer intInserted = 0;
        Integer intUpdated = 0;
        Integer intDeleted = 0;
        List<Order> OrdersToDelete = new List<Order>();
        List<Order> OrdersToUpsert = new List<Order>();

        for (OrderWrapper objOrderWrapper : listOrdersWrappers) {

            if (objOrderWrapper.isDelete) {
                if (objOrderWrapper.recordOrder.id != null) {
                    if(!objOrderWrapper.recordOrder.Status.equalsIgnoreCase(STR_ACTIVATED)) {
                        OrdersToDelete.add(objOrderWrapper.recordOrder);
                    }
                }

            }

            else {
                objOrderWrapper.recordOrder.opportunityId = currentId;
                OrdersToUpsert.add(objOrderWrapper.recordOrder);
            }

        }

        // Error Handling For Deleting Records
        try {
            listDeleteResult = Database.delete(OrdersToDelete);
        }
        catch(exception objException) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,objException.getMessage()));
        }

        // Error Handling For Upserting Records
        try {
            listUpsertResult = Database.upsert(OrdersToUpsert);
        }
        catch(exception objException) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,objException.getMessage()));
        }

        listOrdersOriginal = [SELECT Name, 
                                     ID, 
                                     AccountId , 
                                     Status,
                                     EffectiveDate 
                                FROM Order
                                WHERE OpportunityId =: currentId] ;

        listOrdersWrappers = new List<OrderWrapper>();
        for (Order objOrder : listOrdersOriginal) {
            listOrdersWrappers.add(new OrderWrapper(objOrder, false));
        }

        if(listUpsertResult != null) {
            for (Database.UpsertResult objUpsert : listUpsertResult) {
                if(objUpsert.isCreated()) {
                    intInserted++;
                }
                else {
                    intUpdated++;
                }
            }
        }

        if(listDeleteResult != null) {
            for (Database.DeleteResult objUpsert : listDeleteResult) {
                if(objUpsert.isSuccess()) {
                    intDeleted++;
                }
            }
        }
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'No. of Records Inserted : '+intInserted));
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'No. of Records Updated : '+intUpdated));
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'No. of Records Deleted : '+intDeleted));
    }

    // Method : Add Row On the VFPAGE
    public void AddRow() {
        Order objNewOrder = new Order();
        objNewOrder.Status = STR_DRAFT;
        objNewOrder.EffectiveDate = system.today();
        listOrdersWrappers.add(new OrderWrapper(objNewOrder, false));
    }

    // Method : Get Opportunity Name
    public String getOpportunityName() {
        Opportunity objOpportunity = [Select Name 
                                      FROM Opportunity 
                                      WHERE Id =: currentId];
        return objOpportunity.Name;
    }

    // Method : Get Order Record Of Respective Opportunity
    private List<Order> getRecords(){
        List<Order> listOrder = new List<Order>();
        listOrder = [SELECT Name, 
                            ID, 
                            AccountId , 
                            Status,
                            EffectiveDate 
                       FROM Order
                      WHERE OpportunityId =: currentId] ;
        return listOrder;
    }
}