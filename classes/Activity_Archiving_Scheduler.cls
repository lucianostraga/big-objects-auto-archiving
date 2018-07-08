global class Activity_Archiving_Scheduler implements Schedulable {
    
    global void execute(SchedulableContext ctx) {
            execute();    
    }
    
    public static void execute(){
        List<Id> taskIdsToArchive = new List<Id>();
        List<Id> eventIdsToArchive = new List<Id>();
        
        for(Task t : [SELECT Id FROM Task WHERE To_Archive__c =: TRUE LIMIT 25000]){
            taskIdsToArchive.add(t.Id);
        }
        
        for(Event e : [SELECT Id FROM Event WHERE To_Archive__c =: TRUE LIMIT 25000]){
            eventIdsToArchive.add(e.Id);
        }
        
        Activity_Archiving_Service.archiveTasks(taskIdsToArchive);
        Activity_Archiving_Service.archiveEvents(eventIdsToArchive);
    }
}