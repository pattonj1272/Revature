trigger CustomOrderTrigger on Custom_Order__c (before insert, before update, Before delete,  After insert, After update, After delete, After undelete) {
    if (Trigger.isBefore == true) {
        if(Trigger.isInsert || Trigger.isUpdate) {
            OrderClass.adjustInventoryBasedOnTrigger(Trigger.new);
        }
        
    } else {
        //After save
        if(Trigger.isInsert) {
            OrderClass.createEventBaisedOnTrigger(Trigger.new);
        }
        if (Trigger.isUpdate) {
            OrderClass.updateEventBaisedOnTrigger(Trigger.new);
        }
        else if (Trigger.isDelete) {
            OrderClass.deleteEventBaisedOnTrigger(Trigger.new);
        }
    }
}