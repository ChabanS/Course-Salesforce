/**
 * Created by dell on 7/15/2017.
 */

trigger ApplicationTrigget on Application__c (before insert,before update, after delete ) {

    if (Trigger.isBefore ){
        if (Trigger.isInsert || Trigger.isUpdate){
            ApplicationTriggetHandler.beforeUpsert(Trigger.new);
        }
    }

    if (Trigger.isAfter){
        if (Trigger.isDelete){
            ApplicationTriggetHandler.afterDelete(Trigger.old);
        }
    }

}