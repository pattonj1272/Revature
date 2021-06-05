@isTest
public class TestProduct2 {
@TestSetup
    Public static void MakeData() {
        TestHelper.MakeData();
    }
    
    @isTest
    public static void orderTriggerTest(){
        try{
            Test.startTest();
            List<Product2> newProducts = [SELECT id, Name, Description from Product2];
            
            delete newProducts;
            
            Test.stopTest(); 
        } Catch (DMLException e) {
            
        }
     
        List<Product2> newProductsTest = [SELECT id, Name, Description from Product2];
        
        System.assertEquals(2, newProductsTest.size());
        
    }
}