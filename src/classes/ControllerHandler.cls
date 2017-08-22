/**
 * Created by dmitriygeforce on 18.07.17.
 */

public with sharing class ControllerHandler {


//Chaban
    public static Integer getNumberOfProductInCart(){
        List<AggregateResult> listApplications = [
                SELECT sum(CountProduct__c) countP
                from Application__c
                where Contact__c = :HomeController.getCookiesUserIdString()];
        Integer numberOfInteger = Integer.valueOf(listApplications[0].get('countP'));
        return numberOfInteger;
    }

    public static String getUserNameHandler (){
        return [SELECT name from Contact where id = :HomeController.getCookiesUserIdString()]
                .get(0).Name;
    }

    public static List<Application__c> getApplications(){
        List<Application__c> appList = new List<Application__c>();
        appList = [SELECT Id, Name, Contact__r.Name, Product__r.Name, CountProduct__c,
                Product__r.Price__c from Application__c WHERE Contact__c = :HomeController.getCookiesUserIdString()];
        return appList;
    }

    public static List<Shop__c> getProd(String category){
        List<Shop__c> prod = new List<Shop__c>();
        if (category == null){
            prod = [SELECT id, Product__r.Name, Product__r.Price__c, Product__r.Resolution__c,
                    Product__r.Size__c, TotalCountProduct__c, Product__r.ImageFileName__c from Shop__c ];
        }else {
            prod = [SELECT id, Product__r.Name, Product__r.Price__c, Product__r.Resolution__c,
                    Product__r.Size__c, TotalCountProduct__c, Product__r.ImageFileName__c  from Shop__c
            where Product__r.Category__c in :[select Id from Category__c where Name = :category]];
        }
        return prod;
    }
}