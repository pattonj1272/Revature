public with sharing class CalanderClass {
    public List<String> Sunday{get;set;}
	public List<String> Monday{get;set;}
    public List<String> Tuesday{get;set;}
    public List<String> Wednesday{get;set;}
    public List<String> Thursday{get;set;}
    public List<String> Friday{get;set;}
    public List<String> Saturday{get;set;}
    
    public CalanderClass(Integer yearToView, Integer monthToView){
        Sunday = new List<String>();
        Monday = new List<String>();
        Tuesday = new List<String>();
        Wednesday = new List<String>();
        Thursday = new List<String>();
        Friday = new List<String>();
        Saturday = new List<String>();
        getWeekValues(yearToView, monthToView);
    }
    
	public void getWeekValues(Integer yearToView, Integer monthToView){
        List<Event> events = [SELECT WhatId, StartDateTime, ActivityDateTime, EndDateTime, OwnerId FROM Event];
        
        Date dateToView = getStartDateToView(yearToView, monthToView);
        Date endDateToView = getEndDateToView(yearToView, monthToView);
        String weekDay = ((DateTime)dateToView).format('EEEE');
        while (dateToView <= endDateToView){
            weekDay = ((DateTime)dateToView).format('EEEE');
            switch on weekDay {
                    when 'Sunday' {
                        Sunday.add(getEventsForDay(dateToView, events));
                    } 
                    when 'Monday' {
                        Monday.add(getEventsForDay(dateToView, events));
                    } 
                    when 'Tuesday' {
                        Tuesday.add(getEventsForDay(dateToView, events));
                    } 
                    when 'Wednesday' {
                        Wednesday.add(getEventsForDay(dateToView, events));
                    } 
                    when 'Thursday' {
                        Thursday.add(getEventsForDay(dateToView, events));
                    } 
                    when 'Friday' {
                        Friday.add(getEventsForDay(dateToView, events));
                    } 
                    when 'Saturday' {
                        Saturday.add(getEventsForDay(dateToView, events));
                    } 
            	}
            dateToView = dateToView.addDays(1);
            }
        }  
        public Date getStartDateToView(Integer  yearToView, Integer monthToView){
            Date startDateToView = Date.newInstance(yearToView, monthToView, 1);
            while (((DateTime)startDateToView).format('EEEE') != 'Sunday'){
                System.debug('getStartDateToView');
                startDateToView = startDateToView.addDays(-1);  // go back in calander till get a sunday
            } 
            return startDateToView;  //start date to view is last Sunday of previous month
            
        }
    public Date getEndDateToView(Integer  yearToView, Integer monthToView){
           Integer numberOfDays = Date.daysInMonth(yearToView, monthToView);
            Date endDateToView = Date.newInstance(yearToView, monthToView, numberOfDays);
            while (((DateTime)endDateToView).format('EEEE') != 'Saturday'){
                System.debug('getEndDateToView');
                endDateToView = endDateToView.addDays(+1);  // go foward in calander till get a saturday
            } 
            return endDateToView;  //end date to view is first Saturday of next month
            
        }
        public String getEventsForDay(Date dateToView, List<Event> events){
            String stringToAdd = ((DateTime)dateToView).format('d') + ' ';
            for (Event eventToAdd : events){
                
                if (date.newinstance(eventToAdd.StartDateTime.year(), eventToAdd.StartDateTime.month(), eventToAdd.StartDateTime.day()) == dateToView) {
                    stringToAdd += 'Order: ' + eventToAdd.WhatId + ' Estimated start: ' + eventToAdd.ActivityDateTime.format('H:m');
                }
            }
            // did is seperate loop to order starting first ending last
            for (Event eventToAdd : events){
                if (date.newinstance(eventToAdd.EndDateTime.year(), eventToAdd.EndDateTime.month(), eventToAdd.EndDateTime.day()) == dateToView) {
                    stringToAdd += 'Order: ' + eventToAdd.WhatId + ' Estimated End: ' + eventToAdd.ActivityDateTime.format('H:m');
                }
            }
            System.debug(stringToAdd + 'bob');
            return stringToAdd;
        }
}