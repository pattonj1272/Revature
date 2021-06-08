trigger Product2Trigger on Product2 (before insert, before update, before delete, after insert, after update, after delete, after undelete){
    if (Trigger.isBefore){
        if (Trigger.isDelete){
            for (Product2 product : Trigger.old){
                product.addError('Cannot delete products');
            }
        }
    }
}