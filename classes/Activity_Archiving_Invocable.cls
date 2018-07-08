public class Activity_Archiving_Invocable {
    
    @InvocableMethod(label='Archive Activities' description='Archives Task and Events as Activity History Big Object')
    public static void archiveDuplicateSet(List<Id> activityIds){
        List<Id> taskIdsToArchive = new List<Id>();
        List<Id> eventIdsToArchive = new List<Id>();
        
        for(Id recordId : activityIds){
            String sObjectType = recordId.getSobjectType().getDescribe().getName();
            
            if(sObjectType == Task.sObjectType.getDescribe().getName()){
                taskIdsToArchive.add(recordId);
            }else if(sObjectType == Event.sObjectType.getDescribe().getName()){
                eventIdsToArchive.add(recordId);
            }
        }
        
        if(!taskIdsToArchive.isEmpty())
            Activity_Archiving_Service.archiveTasks(taskIdsToArchive);
        
        if(!eventIdsToArchive.isEmpty())
            Activity_Archiving_Service.archiveEvents(eventIdsToArchive);
        
    }

}