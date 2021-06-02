trigger ProductTrigger on Custom_Product__c (before insert, before update, before delete, after insert, after update, after delete, after undelete){
    if (Trigger.isBefore){
        if (Trigger.isDelete){
            for (Custom_Product__c product : Trigger.old){
                product.addError('Cannot delete products');
            }
        }
    }
}