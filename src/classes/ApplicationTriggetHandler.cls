/**
 * Created by dell on 7/15/2017.
 */

public with sharing class ApplicationTriggetHandler {

    public static List<Shop__c> prods = [SELECT Id , TotalCountProduct__c, Product__c FROM Shop__c];
    public static List<Shop__c> productUpdate = new List<Shop__c>();

    public static void beforeUpsert(List<Application__c> newApplications){
        List<Application__c> apps = newApplications;
        List<Shop__c> productUpdate = new List<Shop__c>();
        for (Application__c app : apps){
            Decimal countProductInApplication = app.CountProduct__c;
                for (Shop__c prod : prods){
                    if (prod.Product__c == app.Product__c){
                        Decimal countProductSell = prod.TotalCountProduct__c - countProductInApplication;
                        productUpdate.add(new Shop__c(id=prod.Id, TotalCountProduct__c = countProductSell));
                    }
                }
        }
        System.debug(productUpdate);
        update productUpdate;
    }

    public static void afterDelete(List<Application__c> newApplications){
        List<Application__c> apps = newApplications;
        for(Shop__c prod : prods){
            Decimal countProductDelete = prod.TotalCountProduct__c;
            for (Application__c app : apps){
                if (prod.Product__c  == app.Product__c){
                    countProductDelete += app.CountProduct__c;
                }
            }
            productUpdate.add(new Shop__c(id = prod.Id, TotalCountProduct__c = countProductDelete));
        }
        System.debug(productUpdate);
        update productUpdate;
    }

}