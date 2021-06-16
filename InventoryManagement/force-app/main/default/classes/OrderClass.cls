public class OrderClass {
    
    public static void adjustInventoryBasedOnTrigger(List<Custom_Order__c> added_orders) {
		List<Id> productIds = getProductIdsFromOrders(added_orders);
        List<Custom_Inventory__c> myInventory = [SELECT ID, quantity__c, product2__c FROM Custom_Inventory__c WHERE product2__R.Id IN :productIds];
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
        List<id> added_Orders_ids = getIdsFromOrders(added_orders);
        
        List<Custom_Order__c> added_orders_full_infomation = [SELECT Id, Contact__R.Id, Contact__R.OwnerId, Estimated_Recieve_Date_Start__c, Estimated_Recieve_Date_End__c FROM Custom_Order__c WHERE id in :added_Orders_ids];
        
        for (Custom_Order__c order : added_orders_full_infomation){
            
            if (order.Estimated_Recieve_Date_Start__c != Null && order.Estimated_Recieve_Date_End__c != Null) {
                System.debug(order.Contact__R);
               System.debug(order.Contact__R.OwnerId + ' ' + Order.Estimated_Recieve_Date_Start__c + ' ' +  Order.Estimated_Recieve_Date_End__c + ' ' + 'Order' + ' ' + Order.Id);
               Event event_to_add = new Event(OwnerId=order.Contact__R.OwnerId, WhoId=order.Contact__R.Id, StartDateTime=Order.Estimated_Recieve_Date_Start__c, ActivityDateTime=Order.Estimated_Recieve_Date_Start__c, EndDateTime=order.Estimated_Recieve_Date_End__c, Subject='Order', WhatId=Order.Id);
               add_events.add(event_to_add);
            }
              
        }
        insert add_events;
    }
    
    public static void updateEventBaisedOnTrigger(List<Custom_Order__c> updated_orders){
        
        List<Id> updated_order_ids = getIdsFromOrders(updated_orders);
        
        List<Custom_Order__c> updated_orders_full_infomation = [SELECT Id, Contact__R.OwnerId, Estimated_Recieve_Date_Start__c, Estimated_Recieve_Date_End__c FROM Custom_Order__c WHERE id in :updated_order_ids];
        
        List<Event> update_events = [SELECT Id, StartDateTime, ActivityDateTime, EndDateTime, WhatId, WhoId FROM Event WHERE WhatId IN :updated_order_ids];
        for (Event update_event : update_events){
            for (Custom_Order__C order : updated_orders_full_infomation) {
                if (order.Estimated_Recieve_Date_Start__c != Null && order.Estimated_Recieve_Date_End__c != Null) {
                    if (order.id == update_event.WhatId) {
                        update_event.StartDateTime = order.Estimated_Recieve_Date_Start__c;
                        update_event.ActivityDateTime = order.Estimated_Recieve_Date_Start__c;
                        update_event.EndDateTime = order.Estimated_Recieve_Date_End__c;
                        update_event.WhoId = order.Contact__R.id;
                    }
                } 
            }
    	}
        update update_events;
 }
    
    public static void deleteEventBaisedOnTrigger(List<Custom_Order__c> deleted_orders){
        
        List<Id> deleted_order_ids = getIdsFromOrders(deleted_orders);
        
        List<Event> delete_events = [SELECT Id FROM Event WHERE WhatId IN :deleted_order_ids];
        
        delete delete_events;
    }
    
    public static List<id> getIdsFromOrders(List<Custom_Order__c> orders){
        List<id> ordersIds = new List<Id>();
        for (Custom_Order__c order : orders){
            ordersIds.add(order.Id);
        }
        return ordersIds;
    }
    
    public static List<id> getProductIdsFromOrders(List<Custom_Order__c> orders){
        List<id> ordersIds = getIdsFromOrders(orders);
        List<Custom_Order__c> updated_orders_full_infomation = [SELECT Id, Product2__R.id FROM Custom_Order__c WHERE id in :ordersIds];
        List<id> productIds = new List<Id>();
        for (Custom_Order__c order : updated_orders_full_infomation){
            productIds.add(order.Product2__R.Id);
        }
        return productIds;
    }
}