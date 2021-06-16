public class SupplyOrders {
	public Custom_Order__c order{get;set;}

    public String orderStatus{get;set;}
    public String unitPrice{get;set;}
    public String successOrError{get;set;}
    public string selectedProduct{get;set;}
    public string selectedContact{get;set;}

    public SupplyOrders(){
        order = new Custom_Order__c();

    }


    public void change(){
        try{
            PricebookEntry priceBookEnttry = [SELECT UnitPrice FROM PricebookEntry WHERE Product2Id =:selectedProduct LIMIT 1];
            this.unitPrice = String.valueOf(priceBookEnttry.UnitPrice);
        }
        catch (Exception ex) {
            this.unitPrice = String.valueOf(0.00);
        }
    }

     public List<SelectOption> getOrderStatusOptions() {
        List<SelectOption> options = new List<SelectOption>();
         options.add(new SelectOption('None', 'Select Order'));
        Schema.DescribeFieldResult field =  Custom_Order__c.Order_Status__c.getDescribe();
        List<Schema.PicklistEntry> picklist = field.getPicklistValues();
        for( Schema.PicklistEntry f : picklist){      
        	options.add(new SelectOption(f.getLabel(), f.getValue()));
        }    
    	return options;
    }


     public List<SelectOption> getProductsOptions() {
        List<SelectOption> options = new List<SelectOption>();
         options.add(new SelectOption('None', 'Select product'));
        List<Product2> products = [SELECT Id, Name from Product2 ];
         for(Product2 product : products){
             options.add(new SelectOption(product.Id,product.Name));
         }

    	return options;
    }

     public List<SelectOption> getContactsOptions() {
        List<SelectOption> options = new List<SelectOption>();
         options.add(new SelectOption('None', 'Select Contact'));
         List<Contact> contacts = [SELECT Id, Name from Contact ];
         for(Contact contact : contacts){
             options.add(new SelectOption(contact.Id,contact.Name));
         }

    	return options;
    }

    public void  save(){
        successOrError = 'Not succeeded';
        Id RecordTypeId = Schema.SObjectType.Custom_Order__c.getRecordTypeInfosByName().get('Inbound Order').getRecordTypeId();
        order.RecordTypeId = RecordTypeId;
        order.Product2__c = selectedProduct;
        order.Contact__c = selectedContact;
        try{
        	order.Order_Price__c = [SELECT Pricebook2Id FROM PricebookEntry WHERE Product2Id =:selectedProduct LIMIT 1].Pricebook2Id;
        }
        catch (Exception ex) {
            
        }
        order.Tracking_Reference__c = EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(DateTime.now().getTime().format())));
        
        Database.SaveResult success = Database.insert(order);
        if (success.isSuccess()){
            successOrError = 'Order submitted successfully!';
        }
        else{
            successOrError = 'Your order could not be sumbitted.';
        }
    }
}