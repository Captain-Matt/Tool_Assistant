import g4p_controls.*;
import java.util.*;

public class AssistantButton extends GButton implements InterfaceItem
{
   GButton btn;
   GImageButton imBtn;
   color original;
   boolean isHighlighted,isDimmed, isHidden, isClicked;
   int numClicks;
   float x1,y1,x2,y2;
   String btnName;
   ArrayList <String> tags; //For search capabilities. Initially empty.
   HashMap<String,InterfaceItem> parents = new HashMap<String,InterfaceItem>();
   
   public AssistantButton(PApplet theApplet, float p0, float p1, float p2, float p3, String name){
     super(theApplet, p0, p1, p2, p3, name);
     x1 = p0;
     y1 = p1;
     x2 = x1 + p2;
     y2 = y1 + p3;
     isHighlighted = false;
     isDimmed = false;
     isClicked = false;
     numClicks = 1;
     btnName = name;
     setLocalColor(4,color(204,229,255)); //idle
     setLocalColor(6,color(204,229,255)); //hover
     tags = new ArrayList<String>();
   }
   
   public void update()
   {
   }
   
   public void hide(){
     this.setAlpha(0);
     isHidden = true;
   }
   
   public void show(){
     this.setAlpha(255);
     isHidden = false;
   }
   
  public float getX(){return x1;}
  public float getY(){return y1;}
  public float getWidth(){return x2;}
  public float getHeight(){return y2;}
  public boolean isHidden(){return isHidden;}
   
   public HashMap<String,InterfaceItem> getPath() //This method returns a hashmap of all contained values.
   {
     return parents; //Buttons will not contain anything: only menu types (dropdown / Ribbon) will contain stuff.
   }
   public void setPath(HashMap<String,InterfaceItem> parentIn)
   {
     parents.putAll(parentIn);
     if(parents.values() instanceof EDropDown)
     {
       btnName = ((EDropDown)parents.values()).getName();
     }
   }
   
   public void toggleHighlight(boolean newVal)     // This method toggles highlighting the component.
   {
     if(newVal)
     {
       this.setLocalColor(4,color(0,255,0)); //idle
       this.setLocalColor(6,color(0,255,0)); //hover
     }
     else
     {
     setLocalColor(4,color(204,229,255)); //idle
     setLocalColor(6,color(204,229,255)); //hover
     }
     this.isHighlighted = newVal;
     //System.out.println("Highlight setting for "+this.getName()+" is set to "+newVal+".");
   }
   
   public void toggleDim(boolean newVal)           // This method toggles dimming the component.       
   { 
     if(!isHidden)
     {
       if(newVal)
       {
         this.setAlpha(129);
       }
       else
       {
         this.setAlpha(255);
       }
       this.isDimmed = newVal;
     }
   }
   
   public void setReqClicks(int newClicks)          //This method changes the clicks required to have the button submitted.  
   {
     this.numClicks = newClicks;
     System.out.println("Required clicks for "+this.getName()+" is set to "+numClicks+".");
   }
   
   public String getName()
   {
     return this.btnName; 
   }
   
   public boolean getHighlight()
   {
     return isHighlighted;
   }
   
   public Object getRootObj()
   {
       return this;
   }
   
   //Tag functionality - search button, set button----------
   
   public void setTags(ArrayList<String> inputTags)
   {
     this.tags = inputTags;
   }
   
   public boolean searchTags(String searchVal)
   {
     for (String tag : tags)
     {
       if(tag.contains(searchVal) || tag.equals(searchVal))
       {
         return true; 
       }
     }
     return false;
   }
}