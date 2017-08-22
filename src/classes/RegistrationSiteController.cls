/**
 * Created by dell on 7/16/2017.
 */

public with sharing class RegistrationSiteController {
    public String username { get; set {username = value == null ? value : value.trim();} }
    public String email { get; set {email = value == null ? value : value.trim();} }
    public String phone { get; set {phone = value == null ? value : value.trim();} }
    public String password { get; set {password = value == null ? value : value.trim();} }
    public String confirmPassword { get; set {confirmPassword = value == null ? value : value.trim();} }


    public PageReference registerUser() {
        if (!isValidPassword()) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,
                    'Password dont match! Try again.');
            ApexPages.addMessage(msg);
            return null;
        }
        If (!validEmailString()) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,
                    'Email dont valid! Try again.');
            ApexPages.addMessage(msg);
            return null;
        }
        If (!validPhoneString()) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,
                    'Phone numbers should be in this format: (999) 999-9999');
            ApexPages.addMessage(msg);
            return null;
        }
        If (!validUsernameString()) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,
                    'Username should be include 3 to 15 characters');
            ApexPages.addMessage(msg);
            return null;
        }
        If (!validPasswodString()) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,
                    'Passwod should be have 6 to 20 characters');
            ApexPages.addMessage(msg);
            return null;
        }

        Contact user = new Contact(LastName = this.username, Email = this.email,
                Phone = this.phone, Pass__c = this.password);
        insert user;
        if (user != null) {
            PageReference page = System.Page.LoginPage;
            page.setRedirect(true);
            return page;
        }

        return null;
    }

    private boolean isValidPassword() {
        return password == confirmPassword;
    }

    public boolean validEmailString() {
        Pattern p = Pattern.compile('([a-zA-Z0-9_\\-\\.]+)@(((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|'
                + '(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3}))');
        Matcher m = p.matcher(email);
        boolean result = m.matches() == true ? true : false;
        return result;
    }

    public boolean validPhoneString() {
        Pattern p = Pattern.compile('[(][0-9]{3}[)] [0-9]{3}-[0-9]{4}');
        Matcher m = p.matcher(phone);
        boolean result = m.matches() == true ? true : false;
        return result;
    }

    public boolean validUsernameString() {
        Pattern p = Pattern.compile('^[a-zA-Z0-9_-]{3,15}$');
        Matcher m = p.matcher(username);
        boolean result = m.matches() == true ? true : false;
        return result;
    }

    public boolean validPasswodString() {
        Pattern p = Pattern.compile('[A-Za-z\\d$@$!%*#?&]{6,}$');
        Matcher m = p.matcher(password);
        boolean result = m.matches() == true ? true : false;
        return result;
    }
}