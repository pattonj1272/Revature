public class EventCalanderController {

    public EventCalanderController() {
        DateTime tmp = System.now();
        yearToView = tmp.year();
        monthToView = tmp.month();
    }
    public void updateCalander(){
        //causes page refresh
        
    }
    public Integer yearToView{
        get {
            if (yearToView == null){
                DateTime tmp = System.now();
                yearToView = tmp.year();
            }
            return yearToView;
        } set;
    }
    public Integer monthToView{
        get {
            if (monthToView == null){
                DateTime tmp = System.now();
                monthToView = tmp.month();
            }
            return monthToView;
        } set;
    }
    public CalanderClass eventList{ 
        get {
            CalanderClass Calander = new CalanderClass(yearToView, monthToView);
            return Calander;
        } set;
    }

    
    }