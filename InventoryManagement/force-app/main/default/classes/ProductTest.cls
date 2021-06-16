@isTest
public class ProductTest {
    @TestSetup
    Public static void MakeData() {
        TestHelper.MakeData();
    }
    
	@isTest
    public static void MyTest(){
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