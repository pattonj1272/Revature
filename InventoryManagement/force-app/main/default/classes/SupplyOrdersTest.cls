@isTest 
public class SupplyOrdersTest {

     @testSetup 
     public static void setup() {
         TestHelper.makeData();
        List<Product2> products = new List<Product2>();
         for(Integer index = 0; index < 10; index++){
              Product2 product = new Product2();
        	  product.Name = 'test name ' + index;
              products.add(product);
         }
         insert products;

         Product2 product = [SELECT Id, Name FROM Product2 WHERE NAME = 'test name 0' LIMIT 1];
		 Pricebook2 priceBook = new Pricebook2();
         priceBook.Name = 'priceBook 1';
         insert priceBook;
         /*
         List<PricebookEntry> entries = new List<PricebookEntry>();
            for(Integer index = 0; index < 2 ; index++) {
                 PriceBookEntry entry = new PricebookEntry();
                 entry.UnitPrice = (10 * (index + 1));
                 entry.IsActive = true;
                 entry.Pricebook2Id = priceBook.Id;
                 entry.Product2Id = product.Id;
                 entries.add(entry);
            }
        insert entries;   
		
         */
    }


    @isTest 
    public static void testGetProductsOptions(){
        Test.startTest();
       	List<Product2> products = [SELECT Name from Product2];
        SupplyOrders orderClass = new SupplyOrders();
        List<SelectOption> productOptions = OrderClass.getProductsOptions();
        Test.stopTest();
        System.assertEquals(productOptions.size(), products.size() + 1); // optional selectOption added as 'Select Product'
        System.assertEquals(orderClass.selectedProduct, null); // no option selected
        System.assertEquals(orderClass.unitPrice, null); // no option selected
    }



    @isTest
    public static void testOrderStatusOptions(){
        Test.startTest();
        SupplyOrders orderClass = new SupplyOrders();
        List<SelectOption> OrderStatusOptions = OrderClass.getOrderStatusOptions();
        Test.stopTest();
        system.assert(OrderStatusOptions.size() > 0);
         System.assertEquals(orderClass.orderStatus, null); // no order option selected
    }


    @isTest
    public static void testContactsOptions(){
        Test.startTest();
        SupplyOrders orderClass = new SupplyOrders();
        List<SelectOption> contactsOptions = OrderClass.getContactsOptions();
        Test.stopTest();
        system.assert(contactsOptions.size() > 0);
        System.assertEquals(orderClass.selectedContact, null); // no option selected
    }



    @isTest
    public static void testSave(){
        Test.startTest();
        Product2 product = [SELECT Id, Name FROM Product2 WHERE NAME = 'test name 0' LIMIT 1];
        SupplyOrders orderClass = new SupplyOrders();
        orderClass.selectedProduct = product.Id;
        orderClass.save();
        Custom_Order__c order = [SELECT Id, Product2__c From Custom_Order__c ORDER BY Id DESC LIMIT 1];
        Test.stopTest();
        system.assertEquals(product.Id, order.Product2__c);
    }

}