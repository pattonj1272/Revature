@isTest
public class TestHelper {
	@testSetup
    Public static void MakeData() {
        List<Product2> newProducts = new List<Product2>();
        newProducts.add(new Product2(Name='Oatmeal', Description='test product'));
        newProducts.add(new Product2(Name='Coffee', Description='test product')); 
        newProducts.add(new Product2(Name='Sanitazer', Description='test product'));
        newProducts.add(new Product2(Name='Wipes', Description='test product 0 left'));
        newProducts.add(new Product2(Name='Shoes', Description='test product Not in inventory'));
        newProducts.add(new Product2(Name='Socks', Description='test product Not in inventory'));
        
        insert newProducts;
        
        newProducts = [SELECT id, Name, Description from Product2];
        
        List<Custom_Inventory__c> new_Custom_Inventory = new List<Custom_Inventory__c>();
        new_Custom_Inventory.add(new Custom_Inventory__c(quantity__c=20, Product2__c=newProducts[0].Id));
        new_Custom_Inventory.add(new Custom_Inventory__c(quantity__c=20, Product2__c=newProducts[1].Id));
        new_Custom_Inventory.add(new Custom_Inventory__c(quantity__c=20, Product2__c=newProducts[2].Id));
        new_Custom_Inventory.add(new Custom_Inventory__c(quantity__c=20, Product2__c=newProducts[3].Id));
        
        insert new_Custom_Inventory;
        
        List<Contact> new_contacts = new List<Contact>();
        new_contacts.add(new Contact(FirstName='Bob', LastName='Ried'));
        new_contacts.add(new Contact(FirstName='Sue', LastName='Patton'));
        new_contacts.add(new Contact(FirstName='Sam', LastName='Hunt'));
        
        insert new_contacts;
        
        List<Custom_Order__c> new_Custom_Orders = new List<Custom_Order__c>();
        id inbound_order_id = Schema.sObjectType.Custom_Order__c.getRecordTypeInfosByName().get('Inbound Order').getRecordTypeId();
        id picking_id = Schema.sObjectType.Custom_Order__c.getRecordTypeInfosByName().get('Picking').getRecordTypeId();
        new_Custom_Orders.add(new Custom_Order__c (quantity__c=10, Product2__c=newProducts[0].Id, Order_Status__c='Delivered', RecordTypeId=inbound_order_id, AddedToInventory__c=True, RemovedFromInventory__c=True));
        new_Custom_Orders.add(new Custom_Order__c (quantity__c=10, Product2__c=newProducts[1].Id, Order_Status__c='Pending', RecordTypeId=picking_id, AddedToInventory__c=True, RemovedFromInventory__c=True));
        
        insert new_Custom_Orders;
        
        
        
        
        
            
    }
}