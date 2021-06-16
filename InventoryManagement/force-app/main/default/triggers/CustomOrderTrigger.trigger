trigger CustomOrderTrigger on Custom_Order__c (before insert, before update, Before delete,  After insert, After update, After delete, After undelete) {
    if (Trigger.isBefore == true) {
        if(Trigger.isInsert || Trigger.isUpdate) {
            OrderClass.adjustInventoryBasedOnTrigger(Trigger.new);
        }
        
    } else if (Trigger.isAfter == true) {
        //After save
        if(Trigger.isInsert) {
            OrderClass.createEventBaisedOnTrigger(Trigger.new);
            ProductClass.adjustProductSummariesBasedOnOrder(Trigger.new, True);
        }
        else if (Trigger.isDelete) {
            OrderClass.deleteEventBaisedOnTrigger(Trigger.old);
            ProductClass.adjustProductSummariesBasedOnOrder(Trigger.old, False);
        }
        else if (Trigger.isUpdate) {
            OrderClass.updateEventBaisedOnTrigger(Trigger.new);
            ProductClass.adjustProductSummariesBasedOnOrder(Trigger.new, True);
            ProductClass.adjustProductSummariesBasedOnOrder(Trigger.old, False);
        }
        
        else if (Trigger.isUndelete){
            ProductClass.adjustProductSummariesBasedOnOrder(Trigger.new, True);
        }
        
        
        
        
    }
}