trigger CustomOrderTrigger on Custom_Order__c (before insert, before update, Before delete,  After insert, After update, After delete, After undelete) {
    if (Trigger.isBefore == true) {
      if(Trigger.isInsert || Trigger.isUpdate) {
          List<Custom_Order__c> myOrders = Trigger.new;
         OrderClass.AdjustInventoryBasedOnTrigger(myOrders);

      }
   }
}