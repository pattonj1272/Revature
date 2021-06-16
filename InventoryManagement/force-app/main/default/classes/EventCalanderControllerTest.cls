@isTest
public class EventCalanderControllerTest {
    @testSetup
    public static void makeData(){
        TestHelper.MakeData();
        
        Custom_Order__c customOrder = new Custom_Order__c();
        customOrder.Contact__c = [SELECT id FROM Contact LIMIT 1].id;
		customOrder.Product2__c = [SELECT id FROM Product2 LIMIT 1].id;
        customOrder.Quantity__c = 2;
        customOrder.Estimated_Recieve_Date_Start__c= DateTime.newInstance(2025, 2, 2, 1, 1, 1);
        customOrder.Estimated_Recieve_Date_End__c= DateTime.newInstance(2025, 2, 4, 1, 1, 1);
        insert customOrder;
    }
	@isTest
    public static void EventCalanderControllerTest(){
		Test.startTest();
        PageReference pageRef = Page.CalanderPage;
        Test.setCurrentPage(pageRef);
        EventCalanderController controller = new EventCalanderController();
		
        controller.yearToView = null;
        controller.monthToView = null;
		
        System.assertEquals(System.now().year(), controller.yearToView);
        System.assertEquals(System.now().month(), controller.monthToView);
        
        
        controller.yearToView = 2025;
        controller.monthToView = 2;
        controller.updateCalander();
        Integer year = controller.yearToView;
        Integer month = controller.monthToView;
        System.assertEquals(2025, year);
        System.assertEquals(2, month);
        System.assertEquals(new List<string>{'26 ' , '2 ' , '9 ' , '16 ' , '23 '}, controller.eventList.Sunday);
        
        Test.stopTest();
    }
}