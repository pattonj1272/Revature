public class OrderClass {
    
    public static void AdjustInventoryBasedOnTrigger(List<Custom_Order__c> added_orders) {
		List<String> products = new List<String>();
         for (Custom_Order__c CustomOrder : added_orders) {
            products.add(CustomOrder.product2__c);
         }
        List<Custom_Inventory__c> myInventory = [SELECT ID, quantity__c, product2__c FROM Custom_Inventory__c WHERE product2__c IN :products];
         for (Custom_Order__c CustomOrder : added_orders) {
             
             if (CustomOrder.Order_Status__c == 'Delivered' && CustomOrder.AddedToInventory__c == False) {
                 CustomOrder.AddedToInventory__c = True;
                 myInventory = InventoryClass.addToInventoryList(CustomOrder.Product2__c, CustomOrder.quantity__c, myInventory);
             }
             else if (CustomOrder.Order_Status__c == 'Picked' && CustomOrder.RemovedFromInventory__c == False) {
                 try{
                     CustomOrder.RemovedFromInventory__c = True;
                     myInventory = InventoryClass.removeFromInventoryList(CustomOrder.Product2__c, CustomOrder.quantity__c, myInventory);
                 }
                 catch (IllegalArgumentException e){
                     CustomOrder.addError('Cannot pick an item when there isn\'t enough inventory to cover it');
                 }
         	}
         }
          upsert myInventory;
	}
}