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
        
        System.assertEquals(6, newProductsTest.size());
        
    }    
   
	@isTest
    public static void productControllerTest(){
        List<Product2> newProducts = [SELECT id, Name, Description from Product2];
        Product2 firstProduct= newProducts.get(0);
                 
		Test.startTest();
        PageReference pageRef = Page.Product;
        Test.setCurrentPage(pageRef);
        Apexpages.StandardSetController stdsc = new Apexpages.StandardSetController(newProducts);
        List<Product2> tp= stdsc.getRecords();
        Product2 fp= tp.get(0);
        fp.Description='Test Description';
       
        stdsc.save();
       
        System.assertEquals('Test Description', fp.Description);
       
        Test.stopTest();
    }
   

}