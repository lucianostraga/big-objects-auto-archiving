public class Activity_Archiving_Service {
    
    @future
    public static void archiveEvents(List<Id> eventsIdsToArchive){
        
        List<Event> eventsToArchive = [SELECT Id, WhoId, Who.Name, WhatId, What.Name,Subject, ActivityDate, StartDateTime, EndDateTime, Description 
                                       FROM Event
                                       WHERE Id IN: eventsIdsToArchive];
        
        List<Activity_History__b> historyActs = new List<Activity_History__b>();
        
        for(Event e : eventsToArchive){
            Activity_History__b ah = new Activity_History__b();
            ah.Subject__c = e.Subject;
            ah.What_Id__c = e.WhatId;
            ah.What_Id_Name__c = e.What.Name;
            ah.Original_Activity_Id__c = e.Id;
	        ah.Type__c = 'Event';
            ah.Start_Date__c = e.StartDateTime;
            ah.End_Date__c = e.EndDateTime;
            ah.Description__c = e.Description;
            ah.Due_Date__c = e.ActivityDate; 
            historyActs.add(ah);
        }
        
        Database.insertImmediate(historyActs);
        Database.delete(eventsIdsToArchive);
    }
    
    @future
    public static void archiveTasks(List<Id> taskIdsToArchive){
        
        List<Task> tasksToArchive = [SELECT Id, WhoId, Who.Name, WhatId, What.Name, ActivityDate, Subject, Status, Description
                                     FROM Task
                                     WHERE Id IN: taskIdsToArchive];
        
        List<Activity_History__b> historyActs = new List<Activity_History__b>();
        
        for(Task t : tasksToArchive){
            Activity_History__b ah = new Activity_History__b();
            ah.Subject__c = t.Subject;
            ah.What_Id__c = t.WhatId;
            ah.What_Id_Name__c = t.What.Name;
            ah.Original_Activity_Id__c = t.Id;
	        ah.Type__c = 'Task';
            ah.Status__c = t.Status;
            ah.Description__c = t.Description;
            ah.Due_Date__c = t.ActivityDate; 
            historyActs.add(ah);
        }
        
        Database.insertImmediate(historyActs);
        Database.delete(taskIdsToArchive);
    }
    
    public static void archiveEventsAsyncSOQL(String asyncEventQuery){
        HttpRequest httpRequest = buildHttpRequest();
        
        String jsonBody = '{'+
                            
            				'"query": "'+asyncEventQuery+'",'+
                            
            				'"operation": "insert",'+
                            
            				'"targetObject": "Activity_History__b",'+
                            
            				'"targetFieldMap": {"Subject":"Subject__c",'+
                            					'"WhatId":"What_Id__c"'+
            									'"What.Name":"What_Id_Name__c"'+
            									'"WhoId":"Who_Id__c"'+
            									'"who.Name":"Who_Id_Name__c"'+
            									'"ActivityDate":"Due_Date__c"'+
            									'"Id":"Original_Activity_Id__c"'+
            									'"Status":"Status__c"'+
            									'"Event":"Type__c"'+
            									'"ActivityDate":"Due_Date__c"'+
            									'"StartDateTime":"Start_Date__c"'+
            									'"EndDateTime":"End_Date__c "'+
            									'"Description":"Description__c"'+
                            					'}'+
                            '}';
        
        Http http = new Http();   
        HttpResponse httpResponse = http.send(httpRequest);  
    }
    
    public static void archiveTasksAsyncSOQL(String asyncTaskQuery){
        HttpRequest httpRequest = buildHttpRequest();
        
        String jsonBody = '{'+
                            
            				'"query": "'+asyncTaskQuery+'",'+
                            
            				'"operation": "insert",'+
                            
            				'"targetObject": "Activity_History__b",'+
                            
            				'"targetFieldMap": {"Subject":"Subject__c ",'+
                            					'"WhatId":"What_Id__c"'+
            									'"What.Name":"What_Id_Name__c"'+
            									'"WhoId":"Who_Id__c"'+
            									'"who.Name":"Who_Id_Name__c"'+
            									'"ActivityDate":"Due_Date__c"'+
            									'"Id":"Original_Activity_Id__c"'+
            									'"Status":"Status__c"'+
            									'"Task":"Type__c"'+
            									'"ActivityDate":"Due_Date__c"'+
            									'"Description":"Description__c"'+
                            					'}'+
                            '}';
        
        Http http = new Http();   
        HttpResponse httpResponse = http.send(httpRequest);  
    }
    
    private static HttpRequest buildHttpRequest(){
        String sfdcURL = URL.getSalesforceBaseUrl().toExternalForm(); 
        String restAPIURL = sfdcURL + '/services/data/v43.0/async-queries/';  
        
        HttpRequest httpRequest = new HttpRequest();  
        httpRequest.setMethod('GET');   
        httpRequest.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());        
        httpRequest.setEndpoint(restAPIURL);  
        return httpRequest;
    }

}