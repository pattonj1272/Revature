@isTest
public class TestOrder {
	@TestSetup
    Public static void MakeData() {
        TestHelper.MakeData();
        
        List<Product2> newProducts = [SELECT id, Name from Product2];
        id inbound_order_id = Schema.sObjectType.Custom_Order__c.getRecordTypeInfosByName().get('Inbound Order').getRecordTypeId();
        id picking_id = Schema.sObjectType.Custom_Order__c.getRecordTypeInfosByName().get('Picking').getRecordTypeId();
        
        List<Contact> contacts = [SELECT id from Contact];        
        
        List<Custom_Order__c > new_Custom_Orders = new List<Custom_Order__c >();
        
        new_Custom_Orders.add(new Custom_Order__c (Contact__c=contacts[0].id, quantity__c=10, Product2__c=newProducts[2].Id, Estimated_Recieve_Date_Start__c=System.now().addDays(1), Estimated_Recieve_Date_End__c=System.now().addDays(2), Order_Status__c='Delivered', RecordTypeId=inbound_order_id));
        new_Custom_Orders.add(new Custom_Order__c (Contact__c=contacts[1].id, quantity__c=10, Product2__c=newProducts[2].Id, Estimated_Recieve_Date_Start__c=System.now().addDays(1), Estimated_Recieve_Date_End__c=System.now().addDays(2), Order_Status__c='picked', RecordTypeId=picking_id));
        new_Custom_Orders.add(new Custom_Order__c (Contact__c=contacts[2].id, quantity__c=10, Product2__c=newProducts[2].Id, Estimated_Recieve_Date_Start__c=System.now().addDays(1), Estimated_Recieve_Date_End__c=System.now().addDays(2), Order_Status__c='pending', RecordTypeId=picking_id));
        
        insert new_Custom_Orders;
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
        
        try {
            // only 20 left so should fail and leave quantity at 20
            insert new  Custom_Order__c (quantity__c=30, Product2__c=newProducts[3].Id, Order_Status__c='picked', RecordTypeId=picking_id);
        }
        catch (Exception ex) {
            
        }
        
        try {
            // Not in the inventory so should just fail
            insert new Custom_Order__c (quantity__c=10, Product2__c=newProducts[4].Id, Order_Status__c='picked', RecordTypeId=picking_id);
        }
        catch (Exception ex) {
            
        }
        new_Custom_Orders.add(new Custom_Order__c (quantity__c=10, Product2__c=newProducts[5].Id, Order_Status__c='Delivered', RecordTypeId=inbound_order_id));
        
        insert new_Custom_Orders;
        
        Test.stopTest(); 
        
        List<Custom_Inventory__c> invitory1 = [SELECT quantity__c FROM Custom_Inventory__c WHERE Product2__c=:newProducts[0].Id LIMIT 1];
        List<Custom_Inventory__c> invitory2 = [SELECT quantity__c FROM Custom_Inventory__c WHERE Product2__c=:newProducts[1].Id LIMIT 1];
        List<Custom_Inventory__c> invitory3 = [SELECT quantity__c FROM Custom_Inventory__c WHERE Product2__c=:newProducts[2].Id LIMIT 1];
        List<Custom_Inventory__c> invitory4 = [SELECT quantity__c FROM Custom_Inventory__c WHERE Product2__c=:newProducts[3].Id LIMIT 1];
        try {
        	List<Custom_Inventory__c> invitory5 = [SELECT quantity__c FROM Custom_Inventory__c WHERE Product2__c=:newProducts[4].Id LIMIT 1];
        }
        catch (Exception ex){
            //No inventory to remove from so throws IllegalArgumentException
            System.assertEquals('IllegalArgumentException',ex.getTypeName());
        }        
        List<Custom_Inventory__c> invitory6 = [SELECT quantity__c FROM Custom_Inventory__c WHERE Product2__c=:newProducts[5].Id LIMIT 1];
        
        
        System.assertEquals(30, invitory1[0].quantity__c);  //added 10 to delevered
        System.assertEquals(10, invitory2[0].quantity__c);  // created order to picked for 10 
        System.assertEquals(20, invitory3[0].quantity__c);  //  no change (left at 20)
        System.assertEquals(20, invitory4[0].quantity__c);  // failed to change so should be left at 20
        System.assertEquals(10, invitory6[0].quantity__c);  // added 10 to new inventory item
        
    }
    
    @isTest
    public static void orderEventAddTriggerTest(){
        Test.startTest();
        List<Product2> newProducts = [SELECT id, Name from Product2];
        List<Contact> contacts = [SELECT id from Contact];  
        id inbound_order_id = Schema.sObjectType.Custom_Order__c.getRecordTypeInfosByName().get('Inbound Order').getRecordTypeId();
        id picking_id = Schema.sObjectType.Custom_Order__c.getRecordTypeInfosByName().get('Picking').getRecordTypeId();
        Custom_Order__c new_Custom_Order = new Custom_Order__c(Contact__c=contacts[0].id, quantity__c=10, Product2__c=newProducts[0].Id, Estimated_Recieve_Date_Start__c=System.now().addDays(3), Estimated_Recieve_Date_End__c=System.now().addDays(5), Order_Status__c='Delivered', RecordTypeId=inbound_order_id);
        insert new_Custom_Order;
        Test.stopTest(); 
        
        // Event has had 3 events created in make data (only orders with estimated delivery start/end date and time are made into events) + 1 in this method = 4
        List<Event> events = [SELECT ID, StartDateTime , ActivityDateTime FROM Event];
		
        System.assertEquals(4, events.size());
    }
    
    @isTest
    public static void orderEventChangeTriggerTest(){
        DateTime dtToChangeTo = System.now().addDays(3);
        
        Test.startTest();
        
        List<Custom_Order__c> orders_to_update = [SELECT id, Estimated_Recieve_Date_Start__c, Estimated_Recieve_Date_End__c FROM Custom_Order__c  WHERE Estimated_Recieve_Date_Start__c != NULL and Estimated_Recieve_Date_End__c != NULL LIMIT 2];
        
        orders_to_update[0].Estimated_Recieve_Date_Start__c = dtToChangeTo;
        orders_to_update[0].Estimated_Recieve_Date_End__c = dtToChangeTo.addDays(10);
        
        orders_to_update[1].Estimated_Recieve_Date_Start__c = dtToChangeTo;
        orders_to_update[1].Estimated_Recieve_Date_End__c = dtToChangeTo.addDays(10);
        update orders_to_update;
        
        Test.stopTest(); 
        
        
        // Event has had its start time sucessfully updated
       List<Event> updated_events = [SELECT ID, StartDateTime , ActivityDateTime FROM Event];
        System.debug(updated_events);
       List<Event> updated_event = [SELECT ID, StartDateTime , ActivityDateTime FROM Event WHERE StartDateTime=:dtToChangeTo];
        System.debug(updated_event);
       System.assertEquals(2, updated_event.size());
        
    }
    
    @isTest
    public static void orderEventDeleteTriggerTest(){
        Test.startTest();
        List<Event> all_events = [SELECT ID, StartDateTime , ActivityDateTime FROM Event];
        System.assertEquals(3, all_events.size());
		List<Custom_Order__c> orders_to_delete = [SELECT id, Estimated_Recieve_Date_Start__c, Estimated_Recieve_Date_End__c FROM Custom_Order__c WHERE Estimated_Recieve_Date_Start__c != NULL and Estimated_Recieve_Date_End__c != NULL LIMIT 2];
        
        delete orders_to_delete;  
        
        Test.stopTest(); 
        
        // Event 3 events created in make date 2 deleted here so should have 1 left
        List<Event> deleted_events = [SELECT ID, StartDateTime , ActivityDateTime FROM Event];
        System.assertEquals(1, deleted_events.size());
    }
    
 
}