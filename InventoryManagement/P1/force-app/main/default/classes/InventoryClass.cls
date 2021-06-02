public class InventoryClass {
	public static List<Custom_Inventory__c> addToInventoryList(id product_id, Decimal quantity, List<Custom_Inventory__c> myInventory){
        Boolean found = false;
            for (Custom_Inventory__c inventory : myInventory) {
               if (inventory.product__c == product_id) {
                  inventory.quantity__c +=  quantity;
                  found = true;
                  break;  // ensure that inventory is not added to multiple
               }
            }
            if (found == false) {             
                
                Custom_Inventory__c tmp = new Custom_Inventory__c(Product__c=product_id, quantity__c=quantity);
                myInventory.add(tmp); 
                 
            }
        return myInventory;
    }

	public static List<Custom_Inventory__c> removeFromInventoryList(id product_id, Decimal quantity, List<Custom_Inventory__c> myInventory){
        Boolean found = false;
        for (Custom_Inventory__c inventory : myInventory) {
            if (inventory.product__c == product_id) {
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

}