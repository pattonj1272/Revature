@isTest
public class TestProduct {
@TestSetup
    Public static void MakeData() {
        TestHelper.MakeData();
    }
    
    @isTest
    public static void orderTriggerTest(){
        try{
            Test.startTest();
            List<Custom_Product__c> newProducts = [SELECT id, Name, Description__c, price__c from Custom_Product__c];
            
            delete newProducts;
            
            Test.stopTest(); 
        } Catch (DMLException e) {
            
        }
     
        List<Custom_Product__c> newProductsTest = [SELECT id, Name, Description__c, price__c from Custom_Product__c];
        
        System.assertEquals(2, newProductsTest.size());
        
    }
}