/**
 * Created by dmitriygeforce on 16.07.17.
 */

public with sharing class LoginPageController {
    public String username { get; set; }
    public String password { get; set; }

    public PageReference checkLogin() {
        if (String.isNotEmpty(username.trim()) && String.isNotEmpty(password.trim())) {
            List<Contact> contact = [SELECT pass__c, Id FROM Contact WHERE LastName = :username];
            if (contact.isEmpty()) {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,
                        'Incorrect username or password');
                ApexPages.addMessage(msg);
                return null;
            } else {
                if (contact[0].pass__c == password) {
                    Cookie idUserCookie = ApexPages.currentPage().getCookies().get('idUser');
                    idUserCookie = new Cookie('idUser', contact[0].Id, null, -1, false);
                    idUserCookie = new Cookie('idUser', contact[0].Id, null, -1, false);
                    ApexPages.currentPage().setCookies(new Cookie[]{
                            idUserCookie
                    });
                    PageReference page = System.Page.home;
                    page.setRedirect(true);
                    return page;
                } else {
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,
                            'Incorrect username or password');
                    ApexPages.addMessage(msg);
                    return null;
                }
            }
        } else {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,
                    'Please fill in the fields');
            ApexPages.addMessage(msg);
            return null;
        }
    }
}