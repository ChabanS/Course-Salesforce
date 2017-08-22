/**
 * Created by dmitriygeforce on 14.07.17.
 */

public with sharing class ShoppingCartController {
    public List<Application__c> products { get; set; }
    public String applicationId { get; set; }


    public List<Application__c> getUserProductApplications() {
        products = [
                SELECT Id, Name, Product__r.Name, Product__r.ImageFileName__c,
                        Product__r.Price__c, Product__r.Product_Description__c, CountProduct__c
                FROM Application__c
                WHERE Contact__r.Id = :HomeController.getCookiesUserIdString()
        ];
        return products;
    }

    public void deleteApplication() {
        Database.deleteResult result = Database.delete(applicationID);
        if (!result.isSuccess()) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,
                    'Oops, seems that we have technical problem with deleteApplicationQueryFailed, don\'t worry, we will handle in a short time');
            ApexPages.addMessage(msg);
        }
    }

    public void cancelBuyingProducts() {
        if (products.isEmpty()) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO,
                    'No products to cancel');
            ApexPages.addMessage(msg);
        } else {
            Database.deleteResult[] delResults = Database.delete(products);
            for (Database.deleteResult result : delResults) {
                if (!result.isSuccess()) {
                    for (Database.Error err : result.getErrors()) {
                        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,
                                'Oops, seems that we have technical problem with deleteApplicationQueryFailed on fields '
                                        + err.getFields() + '; ' + err.getStatusCode() + ': ' + err.getMessage() + ', don\'t worry, we will handle in a short time');
                        ApexPages.addMessage(msg);
                    }
                }
            }
        }
    }

    public void buyProducts() {
        if (products.isEmpty()) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO,
                    'No products to buy');
            ApexPages.addMessage(msg);
        } else {
            Boolean successSoldInsertion = true;
            List<Sold__c> sold = new List<Sold__c>();
            for (Application__c application :products) {
                sold.add(new Sold__c(CountProduct__c = application.CountProduct__c));
            }
            Database.saveResult[] saveResults = Database.insert(sold);
            for (Database.saveResult result : saveResults) {
                if (!result.isSuccess()) {
                    successSoldInsertion = false;
                    for (Database.Error err : result.getErrors()) {
                        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,
                                'Oops, seems that we have technical problem with saveSoldQueryFailed on fields ' + err.getFields() + '; '
                                        + err.getStatusCode() + ': ' + err.getMessage() + ', don\'t worry, we will handle in a short time');
                        ApexPages.addMessage(msg);
                    }
                }
            }

            if (successSoldInsertion) {
                // not to return products in shop becouse they was bought
                for (Application__c application : products) {
                    application.CountProduct__c = 0;
                }
                Database.deleteResult[] delResults = Database.delete(products);
                for (Database.deleteResult result : delResults) {
                    if (!result.isSuccess()) {
                        for (Database.Error err : result.getErrors()) {
                            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,
                                    'Oops, seems that we have technical problem with deleteApplicationQueryFailed on fields ' + err.getFields() + '; '
                                            + err.getStatusCode() + ': ' + err.getMessage() + ', don\'t worry, we will handle in a short time');
                            ApexPages.addMessage(msg);
                        }
                    }
                }
            }
        }
    }

    public String getTotalAmount() {
        String totalAmount = String.valueOf([
                SELECT sum(Product__r.Price__c) totalAmount
                FROM Application__c
                WHERE Contact__r.Id = :HomeController.getCookiesUserIdString()][0].get('totalAmount'));
        if (totalAmount != null) {
            return '€' + totalAmount;
        } else {
            return '€ 0';
        }

    }

    public void changeQuantityOfProduct() {
        System.debug('test'); 

        Application__c applicationToChange = [
                SELECT CountProduct__c
                FROM Application__c
                WHERE Id = :applicationId
        ][0];
        System.debug(applicationToChange.CountProduct__c);
        update products;
    }
}