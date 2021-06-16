public class NewOrderController {
    
    public List<SelectOption> ProductPicklist {
        get{
            List<Product2> tempProduct = new List<Product2>();
    		List<SelectOption> itemList = new List<SelectOption>();
    		tempProduct = [SELECT Name FROM Product2];
        
        	for (Product2 item: tempProduct){
            	itemList.add(new SelectOption(item.Id, item.Name));
        	}
        	return itemList;
            
        }
        set;
    }
    public String selectedProduct{get; set;}
    public Integer quantity{get;set;}
    public Date selectDate{get; set;}
    public String successStatement{get; set;}
    
    public void saveOrder(){
        Custom_Order__c newOrder = new Custom_Order__c();
        Contact getContact = [SELECT Name FROM Contact WHERE Name =: UserInfo.getName() LIMIT 1];
        newOrder.Product2__c = selectedProduct;
        newOrder.Contact__c = getContact.id;
        newOrder.Quantity__c = quantity;
        newOrder.Order_Date__c = selectDate;
        newOrder.Order_Status__c = 'pending';
        Database.SaveResult success = Database.insert(newOrder);
        if (success.isSuccess()){
            successStatement = 'Order submitted successfully!';
        }
        else{
            successStatement = 'Your order could not be sumbitted.';
        }
    }
}