trigger CustomInventoryTrigger on Custom_Inventory__c (before insert, before update, Before delete,  After insert, After update, After delete, After undelete) {

    if (Trigger.isAfter == true) {
        //After save
        if(Trigger.isInsert) {
            ProductClass.adjustProductSummariesBasedOnInventoryChange(Trigger.new, True);
        }
        else if (Trigger.isDelete) {
            ProductClass.adjustProductSummariesBasedOnInventoryChange(Trigger.old, False);
        }
        else if (Trigger.isUpdate) {
            ProductClass.adjustProductSummariesBasedOnInventoryChange(Trigger.new, True);
            ProductClass.adjustProductSummariesBasedOnInventoryChange(Trigger.old, False);
        }
        
        else if (Trigger.isUndelete){
            ProductClass.adjustProductSummariesBasedOnInventoryChange(Trigger.new, True);
        }
    }
}