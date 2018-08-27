import g4p_controls.*;
import java.util.*;

public class Ribbon implements InterfaceItem{
  
  float topLeftX, topLeftY, boxWidth, boxHeight;
  AssistantButton txtBtn;
  ArrayList<AssistantButton> options = new ArrayList<AssistantButton>();
  HashMap<String,InterfaceItem> interfaceComponents = new HashMap<String,InterfaceItem>();
  HashMap<String,InterfaceItem> ribbonList = new HashMap<String,InterfaceItem>();
  color fillColor;
  ArrayList <String> tags;
  String name;
   
  public Ribbon(PApplet theApplet, float x, float y, float w, float h, String n){
    this.topLeftX = x;
    this.topLeftY = y;
    this.boxWidth = w;
    this.boxHeight = h;
    fillColor = color(102,178,255);
    name = n;
    txtBtn = new AssistantButton(theApplet,x,y,w,h,name);
    fill(color(0,0,0));
    rect(this.topLeftX, this.topLeftY, this.boxWidth, this.boxHeight);
    
  }

  public float getX(){return txtBtn.getX();}
  public float getY(){return txtBtn.getY();}
  public float getHeight(){return txtBtn.getHeight();}
  public float getWidth(){return txtBtn.getWidth();}
  public boolean isHidden(){return txtBtn.isHidden();}
  public void update(){}
  
  void drawRibbon()
  {   
     fill(fillColor);
     rect(this.topLeftX, this.topLeftY, this.boxWidth, this.boxHeight); 
  } 
   
  public String getName()
  {
    return name;
  }
  
  public void setPath(HashMap<String,InterfaceItem> parentIn)
  {
    for(InterfaceItem btn : interfaceComponents.values())
    {
      btn.setPath(parentIn);
    }
  } 
  public HashMap<String,InterfaceItem> getPath(){
    return null;
  }
   
  public void fillHash(HashMap<String,InterfaceItem> inputComponents)
  {
    interfaceComponents.putAll(inputComponents);
  }
  public HashMap<String,InterfaceItem> getHash()
  {
    return interfaceComponents;
  }
  
  public void hide()
  {
     for (InterfaceItem btn : interfaceComponents.values())
     {
       btn.hide();
     }
  }
  public void show()
  {
     for (InterfaceItem btn : interfaceComponents.values())
     {
       btn.show();
     }
  }
  
  public void toggleHighlight(boolean newVal)
  {
    txtBtn.toggleHighlight(newVal);
  }
  public void toggleDim(boolean newVal)
  {
    txtBtn.toggleDim(newVal);
  }

  public Object getRootObj()
  {
    return txtBtn;
  }
  
   public void setTags(ArrayList<String> inputTags){
     this.tags = inputTags;
   }
   
   public boolean searchTags(String searchVal){
     
     for (String tag : tags){
       
       if(tag.contains(searchVal) || tag.equals(searchVal)){
         return true; 
       }
     }
     return false;
   }
}