({
	addToCart : function(component, event, helper) {
        
        var cmpTarget = component.find('modalLib');
        $A.util.removeClass(cmpTarget, 'slds-hide');
        
        var productId = event.getSource().get("v.value");
        
        var quantity = component.find('prodQuantity').get("v.value");
        quantity = parseInt(quantity);
        if (!isNaN(quantity) || quantity < 1) {
            var product = {
                productId : productId,
                quantity: quantity
            }
            //console.log('In Child',product);
            $A.get("e.c:ProductCatalogAddToCartEvent").
            setParams({
                product: JSON.stringify(product)
            }).fire();
        } else {
            let toast = $A.get("e.force:showToast");
            toast.setParams({
                "title": "Invalid Quantity",
                "type": "error",
                "message": "The entered order quantity '" + component.find('prodQuantity').get("v.value") + "' is invalid."
            });
            toast.fire();
        }
	},
    addToCart2 : function(component, event, helper) {
        var productId = event.getSource().get("v.value");
        
        var quantity = component.find('prodQuantity').get("v.value");
        quantity = parseInt(quantity);
        if (!isNaN(quantity) || quantity < 1) {
            var product = {
                productId : productId,
                quantity: quantity
            }
            //console.log('In Child',product);
            $A.get("e.c:ProductCatalogAddToCartEvent").
            setParams({
                product: JSON.stringify(product)
            }).fire();
        } else {
            let toast = $A.get("e.force:showToast");
            toast.setParams({
                "title": "Invalid Quantity",
                "type": "error",
                "message": "The entered order quantity '" + component.find('prodQuantity').get("v.value") + "' is invalid."
            });
            toast.fire();
        }
	},
    doInit : function(component, event, helper) {
        var product = component.get('v.product');
        var cart = component.get('v.cart');
        
        //console.log('v.v.product.Product2.Name: ', component.get('v.product').Product2.Name);
        
        var cart = cart.filter(function(cartItem){
            return cartItem.productId == product.Product2Id;
        });
        if (cart.length > 0) {
            
            var currentQty = cart[0].quantity;
        }
       	//component.set('v.currentQty',currentQty);
    },
    clearQty : function(component, event, helper) {
        component.set('v.currentQty','');
    },
    handleClick : function(component, event, helper) {
        var cmpTarget = component.find('modalLib');
        $A.util.addClass(cmpTarget, 'slds-hide');
        component.set('v.thePage', 0);
    },
    nextClick : function(component, event, helper) {
        var thePage = component.get('v.thePage');
        component.set('v.thePage', thePage+1);
    },
    fireEvent : function(component, event, helper) {
        var cmpTarget = component.find('modalLib');
        $A.util.addClass(cmpTarget, 'slds-hide');
        component.set('v.thePage', 0);
        
        $A.get("e.c:ProductCatalogShowSaveCart").
        setParams({
            showSaveCart: true
        }).fire(); 
    },
    zipChange : function(component, event, helper) {
        var theText = component.find('zipInput').get('v.value');
        if(theText.length >= 5){
            component.set('v.nextDisabled', false);
        }
        else{
            component.set('v.nextDisabled', true);
        }
    }
})