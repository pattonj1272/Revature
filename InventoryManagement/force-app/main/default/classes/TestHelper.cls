@isTest
public class TestHelper {
	@testSetup
    Public static void MakeData() {
        List<Product2> newProducts = new List<Product2>();
        newProducts.add(new Product2(Name='Oatmeal', Description='test product'));
        newProducts.add(new Product2(Name='Coffee', Description='test product')); 
        
        insert newProducts;
        
        newProducts = [SELECT id, Name, Description from Product2];
        
        List<Custom_Inventory__c> new_Custom_Inventory = new List<Custom_Inventory__c>();
        new_Custom_Inventory.add(new Custom_Inventory__c(quantity__c=20, Product2__c=newProducts[0].Id));
        new_Custom_Inventory.add(new Custom_Inventory__c(quantity__c=20, Product2__c=newProducts[1].Id));
        
        insert new_Custom_Inventory;
        
        List<Custom_Order__c> new_Custom_Orders = new List<Custom_Order__c>();
        id inbound_order_id = Schema.sObjectType.Custom_Order__c.getRecordTypeInfosByName().get('Inbound Order').getRecordTypeId();
        id picking_id = Schema.sObjectType.Custom_Order__c.getRecordTypeInfosByName().get('Picking').getRecordTypeId();
        new_Custom_Orders.add(new Custom_Order__c (quantity__c=10, Product2__c=newProducts[0].Id, Order_Status__c='Delivered', RecordTypeId=inbound_order_id, AddedToInventory__c=True, RemovedFromInventory__c=True));
        new_Custom_Orders.add(new Custom_Order__c (quantity__c=10, Product2__c=newProducts[1].Id, Order_Status__c='Pending', RecordTypeId=picking_id, AddedToInventory__c=True, RemovedFromInventory__c=True));
        
        insert new_Custom_Orders;
        
        
        
            
    }
}