import g4p_controls.*;
import java.util.*;

public class EDropDown implements InterfaceItem{
  float topLeftX;
  float topLeftY;
  float boxWidth;
  float boxHeight;
  InterfaceItem arrow,mainbox;
  ArrayList<AssistantButton> options = new ArrayList<AssistantButton>();
  boolean optionsVisible = false;
  String name;
  
  public EDropDown(PApplet theApplet, float x, float y, float w, float h,String n){
    this.topLeftX = x;
    this.topLeftY = y;
    this.boxWidth = w;
    this.boxHeight = h;
    name = n;
    arrow = new AssistantButton(theApplet, (this.topLeftX+this.boxWidth-this.boxHeight), this.topLeftY, this.boxHeight, this.boxHeight, "V");
    mainbox = new AssistantButton(theApplet, this.topLeftX, this.topLeftY, (this.boxWidth-this.boxHeight), this.boxHeight, "");
    GButton.useRoundCorners(false);
  }
  
  public void update()
  {
  }
  public boolean isHidden(){return arrow.isHidden();}
  
  public float getX()
  {
    return topLeftX+boxWidth-boxHeight;
  }
  public float getY()
  {
    return topLeftY;
  }
  public float getWidth()
  {
    return boxHeight;
  }
  public float getHeight()
  {
    return boxHeight;
  }
  
  public boolean getState()
  {
    return optionsVisible;
  }
  
  public EDropDown(PApplet theApplet, float x, float y, float w, float h,String n , String[] items){
    this.topLeftX = x;
    this.topLeftY = y;
    this.boxWidth = w;
    this.boxHeight = h;
    name = n;
    arrow = new AssistantButton(theApplet, (this.topLeftX+this.boxWidth-this.boxHeight), this.topLeftY, this.boxHeight, this.boxHeight, "V");
    mainbox = new AssistantButton(theApplet, this.topLeftX, this.topLeftY, (this.boxWidth-this.boxHeight), this.boxHeight, "");
    GButton.useRoundCorners(false);
    
    
    HashMap<String,InterfaceItem>workAround = new HashMap<String,InterfaceItem>();
    workAround.put(name, this);
    for(int i=0; i<items.length; i++){
      AssistantButton option = new AssistantButton(theApplet, this.topLeftX, this.topLeftY+(this.boxHeight*(i+1)), (this.boxWidth-this.boxHeight), this.boxHeight, items[i]);
      option.setPath(workAround);
      options.add(option);
      options.get(i).setVisible(false);
    }
    arrow.setPath(workAround);
  }
   
  public void hide()
  {
  }
  public void show()
  {
  }
  
  public HashMap<String,InterfaceItem> getPath()
  {
    return null;
  }
  
  public void setPath(HashMap<String,InterfaceItem> parentIn)
  {
  }
  
  public String getName()
  {
    return name;
  }
  public Object getRootObj()
  {
    return this;
  }
  
  public void toggleVisible()
  {
    if(!optionsVisible)
    {
      for(int i=0; i<options.size(); i++)
      {
        options.get(i).setVisible(true);
      }
      optionsVisible = true;
    } else {
      for(int i=0; i<options.size(); i++)
      {
        options.get(i).setVisible(false);
      }
      optionsVisible = false;
    }
  }
  
  public boolean contains(String src){
   for(int i=0; i<options.size(); i++){
     if(options.get(i).getName().equals(src)){
       return true;
     }
   }
   return false;
  }
  
  public void setMainText(String str){
    ((AssistantButton)mainbox).setText(str);
  }
  
  public InterfaceItem getArrow(){
    return this.arrow;
  }
  
  public void toggleDim(boolean newVal)
  {
    arrow.toggleDim(newVal);
  }
  
  public void toggleHighlight(boolean newVal)
  {
    arrow.toggleHighlight(newVal);
  }
  
  HashMap<String,AssistantButton> getInterfaceList()
  {
     HashMap<String,AssistantButton> out = new HashMap<String,AssistantButton>();
     for(AssistantButton a : options)
     {
       out.put(a.getName(),a);
     }
     return out;
  }
}