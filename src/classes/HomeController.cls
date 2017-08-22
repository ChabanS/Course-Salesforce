/**
 * Created by dell on 7/14/2017.
 */

public with sharing class HomeController{
    //public List<Product__c> products{get; set;}
    public String category{ get; set;}
    //public Id categoryId{get; set;}
    public String productId{get; set;}
    //public Id contactId{get; set;}
    //public String idString{get; set;}
    List<Shop__c> getShops{get; set;}



    public List<Category__c> getCategories(){
        List<Category__c> cat = [select Name from Category__c];
        return cat;
    }

    public PageReference assingToCategory(){
        if(category == 'Null'){
            this.category = null;
        } else {
            this.category = category;
        }
        return null;
    }

    public PageReference addProductToApplications(){
        String userString = getCookiesUserIdString();
        if(userString != null){
            Application__c application = new Application__c(Product__c = productId,
                    CountProduct__c = 1, Contact__c = userString);
            If(application != null){
                insert application;
            }
            return null;
        }else {
            PageReference page = System.Page.LoginPage;
            page.setRedirect(true);
            return page;
        }
        return null;
    }

//    public List<Shop__c> getShops(){
//        List<Shop__c> shops = new List<Shop__c>();
//        shops = [SELECT Id, Name, TotalCountProduct__c FROM Shop__c];
//        System.debug(shops);
//        return shops;
//    }

    public List<Shop__c> getShops(){
        return ControllerHandler.getProd(category);
    }

    public Integer getNumberInCart(){
        return ControllerHandler.getNumberOfProductInCart();
    }

    public String getUserName(){
        return ControllerHandler.getUserNameHandler();
    }

//    public List<Shop__c> getProd(){
//        List<Shop__c> prod = new List<Shop__c>();
//        if (category == null){
//            prod = [SELECT id, Product__r.Name, Product__r.Price__c, Product__r.Resolution__c,
//                    Product__r.Size__c, TotalCountProduct__c, Product__r.ImageFileName__c from Shop__c ];
//        }else {
//            prod = [SELECT id, Product__r.Name, Product__r.Price__c, Product__r.Resolution__c,
//                    Product__r.Size__c, TotalCountProduct__c, Product__r.ImageFileName__c  from Shop__c
//            where Product__r.Category__c in :[select Id from Category__c where Name = :category]];
//        }
//        return prod;
//    }

//    public List<Application__c> getApplications(){
//        List<Application__c> appList = new List<Application__c>();
//        appList = [SELECT Id, Name, Contact__r.Name, Product__r.Name, CountProduct__c,
//                Product__r.Price__c from Application__c WHERE Contact__c = :getCookiesUserIdString()];
//            return appList;
//    }

//    public Integer getNumberOfProductInCart(){
//        List<AggregateResult> listApplications = [
//            SELECT sum(CountProduct__c) countP
//            from Application__c
//            where Contact__c = :getCookiesUserIdString()];
//        Integer numberOfInteger = Integer.valueOf(listApplications[0].get('countP'));
//        return numberOfInteger;
//    }
//
//    public String getUserName (){
//        return [SELECT name from Contact where id = :getCookiesUserIdString()]
//                .get(0).Name;
//    }

    public static String getCookiesUserIdString(){
        String UserIdString = null;
        Cookie idUserCookie = ApexPages.currentPage().getCookies().get('idUser');
        if(idUserCookie != null) {
            UserIdString = idUserCookie.getValue();
        }
        return UserIdString;
    }
}