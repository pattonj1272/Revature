@isTest
public class NewOrderControllerTest {
	@testSetup
    public static void makeData(){
        List<Product2> testProductList = new List<Product2>();
        testProductList.add(new Product2(Name='Oatmeal', Description='test product'));
        testProductList.add(new Product2(Name='Coffee', Description='test product')); 
        insert testProductList;
        
        List<Custom_Order__c> testOrderList = new List<Custom_Order__c>();
        testOrderList.add(new Custom_Order__c (quantity__c=10, Product2__c=testProductList[0].Id, Order_Status__c='Delivered', AddedToInventory__c=True, RemovedFromInventory__c=True));
        testOrderList.add(new Custom_Order__c (quantity__c=10, Product2__c=testProductList[1].Id, Order_Status__c='Pending', AddedToInventory__c=True, RemovedFromInventory__c=True));
        insert testOrderList;
    }
    @isTest
    public static void listTest(){
        List<Product2> testList = [SELECT id, Name, Description from Product2];
        System.assertEquals(2, testList.size());
    }
    @isTest
    public static void saveOrderTest(){
        List<Custom_order__c> orderList = [SELECT id FROM Custom_order__c];
        System.assertEquals(2, orderList.size());
    }
}