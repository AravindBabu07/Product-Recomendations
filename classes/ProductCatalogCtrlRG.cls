public without sharing class ProductCatalogCtrlRG {
    //Getters
    @AuraEnabled
    public static List<PricebookEntry> getProducts(){
        return [SELECT Id,Product2.Id,Product2.Name,Product2.Description,UnitPrice 
                FROM PricebookEntry WHERE PriceBook2.IsStandard = true ORDER BY Product2.Name
               LIMIT 5];
    }
        @AuraEnabled
    public static List<PricebookEntry> searchProductDetail(String keyWord){
        string searchText = '%'+ keyWord +'%';
        system.debug('Hello');
        return[SELECT Id,Product2.Id,Product2.Name,Product2.Description,UnitPrice 
                FROM PricebookEntry WHERE Product2.Name LIKE :searchText LIMIT 5];
    }
    
    
    @AuraEnabled
    public static RG_Cart__c getCart() {
        RG_Cart__c currentCart = new RG_Cart__c();
        List<RG_Cart__c> carts = [SELECT Id,Name,OwnerId,Active__c,CartItem_Count__c FROM RG_Cart__c 
                                  WHERE OwnerId = :UserInfo.getUserId() ];
        if ( carts.isEmpty() ) {
            insert currentCart;
        } else {
            currentCart = carts[0];
        }
        return currentCart;
    }
    @AuraEnabled
    public static User getUserInfo() {
        return [SELECT Id,FirstName,LastName,City,CompanyName,Country,Phone,PostalCode,State,Street FROM User WHERE Id = :UserInfo.getUserId()];
    }
    @AuraEnabled
    public static List<RG_Cart_Item__c> getCartItems(Id cartId) {
        List<RG_Cart_Item__c> cartItems = [SELECT Id,Name,RG_Cart__c,Product__c,Product__r.Id,Quantity__c,Total_Price__c,Unit_Price__c FROM RG_Cart_Item__c WHERE RG_Cart__c = :cartId];
        return cartItems;
    }
    // Setters
    @AuraEnabled
    public static RG_Cart_Item__c updateCartItems(String cartItemId, Decimal quantity) {
        RG_Cart_Item__c cartItem = [SELECT Id,Quantity__c FROM RG_Cart_Item__c WHERE Id = :cartItemId];
        cartItem.Quantity__c = quantity;
        update cartItem;
        return cartItem;
    }
    @AuraEnabled
    public static void updateUserInfo(String firstName, String lastName, String company, String street, String city, String state, String zip) {
        User u = [SELECT Id,FirstName,LastName,City,CompanyName,Country,Phone,PostalCode,State,Street FROM User WHERE Id = :UserInfo.getUserId()];
        u.FirstName = firstName;
        u.LastName = lastName;
        u.CompanyName = company;
        u.Street = street;
        u.City = city;
        u.State = state;
        u.PostalCode = zip;
        update u;
    }
    @AuraEnabled
    public static void deleteCartItems(String cartId) {
        List<RG_Cart_Item__c> cartItems = [SELECT Id,Quantity__c FROM RG_Cart_Item__c WHERE RG_Cart__c = :cartId];
        delete cartItems;
    }
    @AuraEnabled
    public static RG_Cart_Item__c updateCart(Id cartId, String itemName, String productId, Decimal price, Decimal quantity) {
        RG_Cart_Item__c cartItem = new RG_Cart_Item__c(
            RG_Cart__c = cartId,
            Name = itemName,
            Product__c = productId,
            Quantity__c = quantity,
            Unit_Price__c = price
        );
        try {

            insert cartItem;
            return cartItem;
        } catch(Exception e) {
            System.debug('Error: '+e.getMessage());
            return null;
        }

    }
    @AuraEnabled
    public static RG_Cart__c closeOrder(Id cartId, String cardNumber, String expiration, String securityCode, Decimal tax, Decimal shipping){
        RG_Cart__c cart = [SELECT Id,Name,OwnerId,Active__c,CartItem_Count__c,Credit_Card__c,Expiration__c,Security_Code__c FROM RG_Cart__c WHERE Id = :cartId];
        cart.Credit_Card__c = cardNumber;
        cart.Expiration__c = expiration;
        cart.Security_Code__c = securityCode;
        cart.Tax__c = tax;
        cart.Shipping__c = shipping;
        cart.Active__c = false;
        update cart;
        return cart;
    }


    @AuraEnabled
    public static List<RG_Cart_Item__c> getUserCartItems() {
        RG_Cart__c currentCart = new RG_Cart__c();
        List<RG_Cart__c> carts = [SELECT Id,Name,OwnerId,Active__c,CartItem_Count__c FROM RG_Cart__c WHERE OwnerId = :UserInfo.getUserId() AND Active__c = true];
        if ( carts.isEmpty() ) {
            // No cart, return empty list of carts...
            return new List<RG_Cart_Item__c>();
        } else {
            // cart found
            currentCart = carts[0];
            List<RG_Cart_Item__c> cartItems = [SELECT Id,Name,RG_Cart__c,Product__c,Product__r.Id,Quantity__c,Total_Price__c,Unit_Price__c FROM RG_Cart_Item__c WHERE RG_Cart__c = :currentCart.Id];
            return cartItems;
        }
    }
    /*
    @AuraEnabled
    public static RG_Cart__c saveMyCart(){
        RG_Cart__c currentCart = new RG_Cart__c();
        
        currentCart.OwnerId = UserInfo.getUserId();
        currentCart.Active__c = true;
        
        
        return currentCart;
    }
*/
        @AuraEnabled 
    public static List<Contact> getAddressDetails(String contactId)
    {
        return [SELECT Id,AccountId,Name,Account.BillingStreet, Account.BillingCity, Account.BillingState,Account.BillingPostalCode, Account.BillingCountry, Account.BillingLatitude, Account.BillingLongitude, Account.BillingGeocodeAccuracy, Account.BillingAddress, Account.ShippingStreet, Account.ShippingCity, Account.ShippingState, Account.ShippingPostalCode, Account.ShippingCountry, Account.ShippingLatitude, Account.ShippingLongitude, Account.ShippingGeocodeAccuracy, Account.ShippingAddress
                 FROM Contact 
                WHERE Id=:contactId];
    }
}