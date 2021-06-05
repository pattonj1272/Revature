@isTest
public class TestOrder {
	@TestSetup
    Public static void MakeData() {
        TestHelper.MakeData();
    }
    
    @isTest
    public static void orderTriggerTest(){
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
}