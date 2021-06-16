public class ProductExtension {

    public ProductExtension(ApexPages.StandardSetController sc){   
    }

    public PageReference goToOrderPage(){
        PageReference newOrder = new PageReference(Site.getBaseSecureUrl() + '/orderitems');
        newOrder.setRedirect(true);
        return newOrder;
    }
}