public class ProductClass {
	
    // if add is false then subtracts
    public static void adjustProductSummariesBasedOnOrder(List<Custom_Order__c> orders, Boolean add) {
        List<Id> orderIds = OrderClass.getIdsFromOrders(orders);
        List<Id> orderProductIds = OrderClass.getProductIdsFromOrders(orders);
        
        Map<String, Schema.RecordTypeInfo> orderInfomation = Schema.sObjectType.Custom_Order__c.getRecordTypeInfosByName();
        
        List<Product2> products_tmp = [SELECT Id, Total_In_Stock__c, Total_Incoming__c FROM Product2];
        List<Custom_Order__c> ordersFullInfomation = [SELECT Id, Product2__R.Id, RecordTypeId, Order_Status__c, Quantity__c FROM Custom_Order__c WHERE id in :orderIds];
        List<Product2> products = [SELECT Id, Total_In_Stock__c, Total_Incoming__c, Total_Outstanding__c FROM Product2 WHERE Id in :orderProductIds];
        
        System.debug(products + 'Bob');
        System.debug(products[0].Total_In_Stock__c + 'Bob1');
        System.debug(products[0].Total_Incoming__c + 'Bob2');
        System.debug(products[0].Total_Outstanding__c + 'Bob3');
        
        for (Product2 product : products){
            System.debug(product.id + 'Test123 ');
            for (Custom_Order__c order : ordersFullInfomation) {
                if (product.Id == order.Product2__R.Id) {
                    if (order.RecordTypeId == orderInfomation.get('Inbound Order').getRecordTypeId() && order.Order_Status__c != 'Delivered'){
                        product.Total_Incoming__c = adjustValue(product.Total_Incoming__c, order.quantity__c, add);
                        System.debug(products[0].Total_Incoming__c + 'Bob4');
                    } else if (order.RecordTypeId == orderInfomation.get('Picking').getRecordTypeId() && order.Order_Status__c == 'Pending'){
                        product.Total_Outstanding__c = adjustValue(product.Total_Outstanding__c, order.quantity__c, add);
                    } 
                }
            }
        }
        
        System.debug(products + 'Bob5');
        update products;
        
    }  
    
    
    public static void adjustProductSummariesBasedOnInventoryChange(List<Custom_Inventory__c> newInventories, Boolean add) {
        System.debug('Changing invy');
        List<Id> newInvintoryIds = InventoryClass.getIdsFromInventories(newInventories);
        List<Id> newProductInvintoryIds = InventoryClass.getProductIdsFromInventories(newInventories);
		
        System.debug('Changing invy2' + newInvintoryIds + newProductInvintoryIds);
        List<Custom_Inventory__c> NewInvintoriesFullInfomation = [SELECT Id, Product2__R.Id, Quantity__c FROM Custom_Inventory__c WHERE id in :newInvintoryIds];
        List<Product2> products = [SELECT Id, Total_In_Stock__c, Total_Incoming__c, Total_Outstanding__c FROM Product2 WHERE Id in :newProductInvintoryIds];
        for (Product2 product : products){
            if (newInventories != null){
                for (Custom_Inventory__c newInventory : NewInvintoriesFullInfomation) {
                    System.debug('Changing invy3' + product  + newInventory);
                    if (product.Id == newInventory.Product2__R.Id) {
                        System.debug('Changing invy3.5' + product.Id + newInventory.Product2__R.Id + product  + newInventory);
                        product.Total_In_Stock__c = adjustValue(product.Total_In_Stock__c, newInventory.quantity__c, add);
                    }
                }
            }
        }
        System.debug('Updating invy4');
        update products;
    }
        
    
    public static void PreventDeleteIfUsed(List<Product2> products){ 
        List<id> product_ids = getProductIds(products);
        List<Custom_Order__c> orders = [SELECT id, Product2__R.id FROM Custom_Order__c WHERE Product2__R.id in :product_ids];
        List<Custom_Inventory__c> inventories = [SELECT id, Product2__R.id FROM Custom_Inventory__c WHERE Product2__R.id in :product_ids];
        
        for (Product2 product : products) {
            for (Custom_Order__c order : orders) {
                for (Custom_Inventory__c inventory : inventories) {
                    if (product.id == order.Product2__R.id || product.id == inventory.Product2__R.id ){
                        product.addError('Cannot remove products that are in orders or inventory');
                    }
                }
            }                
        }
    	
    }
    public static List<id> getProductIds(List<Product2> products){
        List<id> product_ids = new List<id>();
        for (Product2 product : products) {
                product_ids.add(product.id);
        }
        return product_ids;
    }
    
    public static Decimal adjustValue(Decimal value, Decimal quantity, Boolean add){
        if (add){
            if (value == null){
                value = quantity;
            }else {
                value += quantity;
            }
        } else {  // subtract
            if (value == null){
                value = quantity * -1;
            }else {
                value -= quantity;
            }
        }
        return value;
    }
    
}