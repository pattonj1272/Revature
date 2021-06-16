public class InventoryClass {
	public static List<Custom_Inventory__c> addToInventoryList(id product_id, Decimal quantity, List<Custom_Inventory__c> myInventory){
        Boolean found = false;
            for (Custom_Inventory__c inventory : myInventory) {
               if (inventory.product2__c == product_id) {
                  inventory.quantity__c +=  quantity;
                  found = true;
                  break;  // ensure that inventory is not added to multiple
               }
            }
            if (found == false) {             
                
                Custom_Inventory__c tmp = new Custom_Inventory__c(Product2__c=product_id, quantity__c=quantity);
                myInventory.add(tmp); 
                 
            }
        return myInventory;
    }

	public static List<Custom_Inventory__c> removeFromInventoryList(id product_id, Decimal quantity, List<Custom_Inventory__c> myInventory){
        Boolean found = false;
        for (Custom_Inventory__c inventory : myInventory) {
            if (inventory.product2__c == product_id) {
                inventory.quantity__c -=  quantity;
                found = true;
                break;  // ensure that inventory is not added to multiple
            }
        }
        if (found == false) {             
            throw new IllegalArgumentException('There was no inventory to remove the quantity from');
        }
        return myInventory;
        }
    
    public static List<Id> getIdsFromInventories(List<Custom_Inventory__c> invintories){
        if (invintories == null){
            return null;
        }
        List<id> invintory_ids = new List<Id>();
        for (Custom_Inventory__c inventory : invintories){
            invintory_ids.add(inventory.Id);
        }
        return invintory_ids;
    }
    
    public static List<Id> getProductIdsFromInventories(List<Custom_Inventory__c> invintories){
        if (invintories == null){
            return null;
        }
        System.debug('In get products ids from invy' + invintories);
        List<Custom_Inventory__c> updated_invintories_full_infomation = [SELECT Id, Product2__R.id FROM Custom_Inventory__c WHERE id in :getIdsFromInventories(invintories)];
        System.debug('In get products ids from invy' + updated_invintories_full_infomation);
        List<id> product_ids = new List<Id>();
        for (Custom_Inventory__c inventory : updated_invintories_full_infomation){
            product_ids.add(inventory.Product2__R.Id);
        }
        return product_ids;
    }

}