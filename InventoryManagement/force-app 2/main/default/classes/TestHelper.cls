@isTest
public class TestHelper {
	@testSetup
    Public static void MakeData() {
        List<Custom_Product__c> newProducts = new List<Custom_Product__c>();
        newProducts.add(new Custom_Product__c(Name='Oatmeal', Description__c='test product', price__c=20.20));
        newProducts.add(new Custom_Product__c(Name='Coffee', Description__c='test product', price__c=20.10)); 
        
        insert newProducts;
        
        newProducts = [SELECT id, Name, Description__c, price__c from Custom_Product__c];
        
        List<Custom_Inventory__c> new_Custom_Inventory = new List<Custom_Inventory__c>();
        new_Custom_Inventory.add(new Custom_Inventory__c(quantity__c=20, Product__c=newProducts[0].Id));
        new_Custom_Inventory.add(new Custom_Inventory__c(quantity__c=20, Product__c=newProducts[1].Id));
        
        insert new_Custom_Inventory;
        
        List<Custom_Order__c> new_Custom_Orders = new List<Custom_Order__c>();
        id inbound_order_id = Schema.sObjectType.Custom_Order__c.getRecordTypeInfosByName().get('Inbound Order').getRecordTypeId();
        id picking_id = Schema.sObjectType.Custom_Order__c.getRecordTypeInfosByName().get('Picking').getRecordTypeId();
        new_Custom_Orders.add(new Custom_Order__c (quantity__c=10, Product__c=newProducts[0].Id, Order_Status__c='Delivered', RecordTypeId=inbound_order_id, AddedToInventory__c=True, RemovedFromInventory__c=True));
        new_Custom_Orders.add(new Custom_Order__c (quantity__c=10, Product__c=newProducts[1].Id, Order_Status__c='Pending', RecordTypeId=picking_id, AddedToInventory__c=True, RemovedFromInventory__c=True));
        
        insert new_Custom_Orders;
        
        
        
            
    }
}