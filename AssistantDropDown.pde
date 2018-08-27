import g4p_controls.*;
import java.util.*;
import java.awt.*;

public class AssistantDropDown implements InterfaceItem 
{
   public EDropDown list;
   color original;
   boolean isHighlighted;
   boolean isDimmed;
   int numClicks;
   String name;
   
   public AssistantDropDown(PApplet theApplet, float p0, float p1, float p2, float p3,String n, String[] items){
     isHighlighted = false;
     isDimmed = false;
     numClicks = 1;
     name = n;
     list = new EDropDown(theApplet, p0, p1, p2, p3,name, items);  //Reference to the G4P object.\
   }
  
   public HashMap<String,InterfaceItem> getPath() //This method returns a hashmap of all contained values.
   {
     return null; //Buttons will not contain anything: only menu types (dropdown / Ribbon) will contain stuff.
   }
   public boolean isHidden(){return list.isHidden();}
   public void update()
   {
   }
   
   public String getName()
   {
     return name;
   }
   
   public void hide()
   {
   }
   public void show()
   {
   }
   
  public float getX(){return list.getX();}
  public float getY(){return list.getY();}
  public float getWidth(){return list.getWidth();}
  public float getHeight(){return list.getHeight();}
   
   public void setPath(HashMap<String,InterfaceItem> parentIn)
   {
   }
   
   public void toggleHighlight(boolean newVal)     // This method toggles highlighting the component.
   {
     
     this.list.arrow.toggleHighlight(newVal);//idle
     this.isHighlighted = newVal;
     //System.out.println("Dim setting for "+this.list.getText()+" is set to "+newVal+".");
   }
   
   public void toggleDim(boolean newVal)           // This method toggles dimming the component.       
   {   
     this.list.arrow.toggleDim(newVal);
     
     this.isDimmed = newVal;
     //System.out.println("Dim setting for "+this.list.getText()+" is set to "+newVal+".");
   }
   
   public void setReqClicks(int newClicks)          //This method changes the clicks required to have the button submitted.  
   {
     /*this.numClicks = newClicks;
     System.out.println("Required clicks for "+this.list.getText()+" is set to "+numClicks+".");*/
   }
   
   public EDropDown getRootObj()
   {
     return this.list;
   }
}