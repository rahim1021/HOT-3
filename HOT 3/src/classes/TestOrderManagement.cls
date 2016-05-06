/****************************************************************************** 
 * This class is the Test class for OrderExtension Apex Class.
 *
 * Functionality: this class acts as Test Class
 *   Different Test Cases Are designed And asserted
 *
 * Revision History: 
 *
 * Version     Author               Date         Description 
 * 1.0         Abdulrahim Mulla     4/25/2016    All Functionality Acheived 
 *
 *******************************************************************************/
@istest public class TestOrderManagement {

    private static final String STRTEST = 'test';
    private static final String OPEN = 'Open';
    static testmethod void testOrderManagementSingleDeleteOrder() {

        // Data Creation for testing
        Integer intNumbers = 0;

        Opportunity objOpportunity = new Opportunity (Name = STRTEST,
                                                      CloseDate = System.Today(),
                                                      StageName = OPEN);
        insert objOpportunity;

        List<Order> listOrders = TestDataFactory.createOrderTestRecord (3, STRTEST);
        for(Order objOrder : listOrders) {
            objOrder.OpportunityId = objOpportunity.Id;
        }
        insert listOrders;

        System.currentPageReference().getParameters().put('id', objOpportunity.Id);
        OrderExtension objOrderExtension = new OrderExtension();
        objOrderExtension.currentId = objOpportunity.Id;                   
        ApexPages.StandardController stdController;
        list<OrderExtension.OrderWrapper> listWrapper  = objOrderExtension.getOrderList();
        for(OrderExtension.OrderWrapper objWrapper : listWrapper) {
            if(intNumbers == listWrapper.size()-1) {
                objWrapper.isDelete = true;
            }
            intNumbers++;
        }

        // Actual Testing
        Test.startTest();
            objOrderExtension.SaveAcc();
            objOrderExtension.AddRow();
        Test.stopTest();

        // Result Asserts
        List<Order> listDeleted = [SELECT Id From Order];
        system.assertequals(listWrapper.size()-1,listDeleted.size());
    }

    static testmethod void testOrderManagementAllDeleteOrder() {

        Opportunity objOpportunity = new Opportunity (Name = STRTEST,
                                                      CloseDate = System.Today(),
                                                      StageName = OPEN);
        insert objOpportunity;

        List<Order> listOrders = TestDataFactory.createOrderTestRecord (3, STRTEST);
        for(Order objOrder : listOrders) {
            objOrder.OpportunityId = objOpportunity.Id;
        }
        insert listOrders;

        System.currentPageReference().getParameters().put('id', objOpportunity.Id);
        OrderExtension objOrderExtension = new OrderExtension();
        objOrderExtension.currentId = objOpportunity.Id;
        ApexPages.StandardController stdController;
        list<OrderExtension.OrderWrapper> listWrapper  = objOrderExtension.getOrderList();
        for(OrderExtension.OrderWrapper objWrapper : listWrapper) {

                objWrapper.isDelete = true;
        }

        // Actual Testing
        Test.startTest();
            objOrderExtension.SaveAcc();
            objOrderExtension.AddRow();
        	objOrderExtension.SaveAcc();
        Test.stopTest();

        // Result Asserts
        List<Order> listDeleted = [SELECT Id From Order];
        system.assertequals(0,listDeleted.size());
    }

    static testmethod void testOrderManagementSingleUpdateOrder() {
        Integer intNumbers = 0;

        Opportunity objOpportunity = new Opportunity (Name = STRTEST,
                                                      CloseDate = System.Today(),
                                                      StageName = OPEN);
        insert objOpportunity;

        List<Order> listOrders = TestDataFactory.createOrderTestRecord (3, STRTEST);
        for(Order objOrder : listOrders) {
            objOrder.OpportunityId = objOpportunity.Id;
        }
        insert listOrders;

        System.currentPageReference().getParameters().put('id', objOpportunity.Id);
        OrderExtension objOrderExtension = new OrderExtension();
        objOrderExtension.currentId = objOpportunity.Id;
        ApexPages.StandardController stdController;
        list<OrderExtension.OrderWrapper> listWrapper  = objOrderExtension.getOrderList();
        for(OrderExtension.OrderWrapper objWrapper : listWrapper) {
            if(intNumbers == listWrapper.size()-1) {
                objWrapper.recordOrder.name = 'rahim';
            }
            intNumbers++;
        }

        // Actual Testing
        Test.startTest();
            objOrderExtension.SaveAcc();
            objOrderExtension.AddRow();
        Test.stopTest();

        // Result Asserts
        List<Order> listEdited = [SELECT Id From Order WHERE Name = 'rahim'];
        system.assertequals(1,listEdited.size());
    }

    static testmethod void testOrderManagementAllUpdateOrder() {

        Opportunity objOpportunity = new Opportunity (Name = STRTEST,
                                                      CloseDate = System.Today(),
                                                      StageName = OPEN);
        insert objOpportunity;

        List<Order> listOrders = TestDataFactory.createOrderTestRecord (3, STRTEST);
        for(Order objOrder : listOrders) {
            objOrder.OpportunityId = objOpportunity.Id;
        }
        insert listOrders;

        System.currentPageReference().getParameters().put('id', objOpportunity.Id);
        OrderExtension objOrderExtension = new OrderExtension();
        objOrderExtension.currentId = objOpportunity.Id;
        list<OrderExtension.OrderWrapper> listWrapper  = objOrderExtension.getOrderList();
        for(OrderExtension.OrderWrapper objWrapper : listWrapper) {
            objWrapper.recordOrder.name = 'rahim';
        }

        // Actual Testing
        Test.startTest();
            objOrderExtension.SaveAcc();
            objOrderExtension.AddRow();
        	objOrderExtension.getOpportunityName();
        Test.stopTest();

        // Result Asserts
        List<Order> listEdited = [SELECT Id From Order WHERE Name = 'rahim'];
        system.assertequals(listWrapper.size(),listEdited.size());
    }
}