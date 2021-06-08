@isTest
public class TestOrder {
	@TestSetup
    Public static void MakeData() {
        TestHelper.MakeData();
    }
    
    @isTest
    public static void orderChangeInventoryTriggerTest(){
        Test.startTest();
        List<Product2> newProducts = [SELECT id, Name from Product2];
        
        id inbound_order_id = Schema.sObjectType.Custom_Order__c.getRecordTypeInfosByName().get('Inbound Order').getRecordTypeId();
        id picking_id = Schema.sObjectType.Custom_Order__c.getRecordTypeInfosByName().get('Picking').getRecordTypeId();
        
        List<Custom_Order__c > new_Custom_Orders = new List<Custom_Order__c >();
        new_Custom_Orders.add(new Custom_Order__c (quantity__c=10, Product2__c=newProducts[0].Id, Order_Status__c='Delivered', RecordTypeId=inbound_order_id));
        new_Custom_Orders.add(new Custom_Order__c (quantity__c=10, Product2__c=newProducts[1].Id, Order_Status__c='picked', RecordTypeId=picking_id));
        new_Custom_Orders.add(new Custom_Order__c (quantity__c=10, Product2__c=newProducts[1].Id, Order_Status__c='pending', RecordTypeId=picking_id));
        
        insert new_Custom_Orders;
        
        Test.stopTest(); 
        
        List<Custom_Inventory__c> invitory1 = [SELECT quantity__c FROM Custom_Inventory__c WHERE Product2__c=:newProducts[0].Id LIMIT 1];
        List<Custom_Inventory__c> invitory2 = [SELECT quantity__c FROM Custom_Inventory__c WHERE Product2__c=:newProducts[1].Id LIMIT 1];
        
        System.assertEquals(30, invitory1[0].quantity__c);
        System.assertEquals(10, invitory2[0].quantity__c);
        
    }
    
    @isTest
    public static void orderEventTriggerTest(){
        integer num = 1;
        System.debug('Test' + num++);
        Test.startTest();
        List<Product2> newProducts = [SELECT id, Name from Product2];
        System.debug('Test' + num++);
        id inbound_order_id = Schema.sObjectType.Custom_Order__c.getRecordTypeInfosByName().get('Inbound Order').getRecordTypeId();
        id picking_id = Schema.sObjectType.Custom_Order__c.getRecordTypeInfosByName().get('Picking').getRecordTypeId();
        System.debug('Test' + num++);
        List<Custom_Order__c > new_Custom_Orders = new List<Custom_Order__c >();
        DateTime dtToChange = System.now().addDays(3);
        DateTime dtToDeleteOrder = System.now().addDays(10);
        System.debug('Test' + num++);
        new_Custom_Orders.add(new Custom_Order__c (quantity__c=10, Product2__c=newProducts[0].Id, Estimated_Recieve_Date_Start__c=dtToChange, Estimated_Recieve_Date_End__c=System.now().addDays(2), Order_Status__c='Delivered', RecordTypeId=inbound_order_id));
        new_Custom_Orders.add(new Custom_Order__c (quantity__c=10, Product2__c=newProducts[1].Id, Estimated_Recieve_Date_Start__c=System.now(), Estimated_Recieve_Date_End__c=System.now().addDays(4), Order_Status__c='picked', RecordTypeId=picking_id));
        new_Custom_Orders.add(new Custom_Order__c (quantity__c=10, Product2__c=newProducts[1].Id, Estimated_Recieve_Date_Start__c=dtToDeleteOrder, Estimated_Recieve_Date_End__c=System.now().addDays(4), Order_Status__c='pending', RecordTypeId=picking_id));
        System.debug('Test' + num++);
        
        List<Custom_Order__c> order_to_update = [SELECT id, Estimated_Recieve_Date_Start__c, Estimated_Recieve_Date_End__c FROM Custom_Order__c];// WHERE Estimated_Recieve_Date_Start__c =:dtToChange LIMIT 1];
        System.debug('Test' + num++);
        
        order_to_update[0].Estimated_Recieve_Date_Start__c = dtToChange.addDays(1);
        order_to_update[0].Estimated_Recieve_Date_End__c = dtToChange.addDays(10);
        update order_to_update;
        System.debug('Test' + num++);
        
        Custom_Order__c order_to_delete = [SELECT id, Estimated_Recieve_Date_Start__c, Estimated_Recieve_Date_End__c FROM Custom_Order__c LIMIT 1];// WHERE Estimated_Recieve_Date_Start__c=:dtToDeleteOrder LIMIT 1];
        
        delete order_to_delete;
        System.debug('Test' + num++);
        
        Test.stopTest(); 
        System.debug('Test' + num++);
        // Event has had 3 events created then one deleted
        List<Event> events = [SELECT ID, StartDateTime , ActivityDateTime FROM Event];
		
        System.debug('Test' + num++);
        System.assertEquals(2, events.size());
        
        // Event has had its start time sucessfully updated
        List<Event> updated_event = [SELECT ID, StartDateTime , ActivityDateTime FROM Event WHERE StartDateTime=:dtToChange.addDays(1)];
        System.assertEquals(1, events.size());
        
        System.debug('Test' + num++);
        // Event sucessfully deleted
        
        //List<Event> deleted_event = [SELECT ID, StartDateTime , ActivityDateTime FROM Event WHERE StartDateTime=:dtToDeleteOrder];
        //System.assertEquals(0, events.size());
        
    }
}