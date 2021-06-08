public class OrderClass {
    
    public static void adjustInventoryBasedOnTrigger(List<Custom_Order__c> added_orders) {
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
    public static void createEventBaisedOnTrigger(List<Custom_Order__c> added_orders){
        List<Event> add_events = new List<Event>();
        for (Custom_Order__c order : added_orders){
            
            if (order.Estimated_Recieve_Date_Start__c != Null && order.Estimated_Recieve_Date_End__c != Null) {
               Event event_to_add = new Event(OwnerId=order.Contact__R.Id, StartDateTime=Order.Estimated_Recieve_Date_Start__c, ActivityDateTime=Order.Estimated_Recieve_Date_End__c, Subject='Order', WhatId=Order.Id);
               add_events.add(event_to_add);
            }
              
        }
        insert add_events;
    }
    
    public static void updateEventBaisedOnTrigger(List<Custom_Order__c> updated_orders){
        List<Id> updated_order_ids = new List<Id>();
        for (Custom_Order__C order : updated_orders){
            updated_order_ids.add(order.Id);
        }
        
        List<Event> update_events = [SELECT Id, StartDateTime, ActivityDateTime, WhatId FROM Event WHERE WhatId IN :updated_order_ids];
        for (Event update_event : update_events){
            for (Custom_Order__C order : updated_orders) {
                if (order.Estimated_Recieve_Date_Start__c != Null && order.Estimated_Recieve_Date_End__c != Null) {
                    if (order.id == update_event.WhatId) {
                        update_event.StartDateTime = order.Estimated_Recieve_Date_Start__c;
                        update_event.ActivityDateTime = order.Estimated_Recieve_Date_End__c;
                    }
                } 
            }
    	}
        update update_events;
 }
    
    public static void deleteEventBaisedOnTrigger(List<Custom_Order__c> deleted_orders){
        List<Id> deleted_order_ids = new List<Id>();
        for (Custom_Order__C order : deleted_orders){
            deleted_order_ids.add(order.Id);
        }
        
        List<Event> delete_events = [SELECT Id FROM Event WHERE WhatId IN :deleted_order_ids];
        
        delete delete_events;
    }
}