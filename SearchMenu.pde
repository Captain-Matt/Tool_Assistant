import g4p_controls.*;
import java.util.*;

public class SearchMenu implements InterfaceItem{
  GTextField srch;
  HashMap<String,InterfaceItem> interfaceComponents = new HashMap<String,InterfaceItem>();
  HashMap<String,InterfaceItem> ribbons = new HashMap<String,InterfaceItem>();
  HashMap<String,InterfaceItem> outputComponents;
  
  public SearchMenu(PApplet theApplet, float p0, float p1, float p2, float p3){
    srch = new GTextField(theApplet, p0, p1, p2, p3);
  }
  
  public void dimSearch(){
    outputComponents = new HashMap<String,InterfaceItem>();
    InterfaceItem found = null;
    outputComponents.putAll(interfaceComponents);
    found = interfaceComponents.get(this.srch.getText().substring(0,this.srch.getText().length()).toLowerCase());
    
    if(found == null){
      println("no button found");
    } else {
      outputComponents.remove(this.srch.getText().substring(0,this.srch.getText().length()).toLowerCase());
      
      for (InterfaceItem btn : outputComponents.values()) 
      {
        btn.toggleDim(true);
        btn.toggleHighlight(false);
        for (InterfaceItem parent : btn.getPath().values())
        {
          parent.toggleDim(true);
          parent.toggleHighlight(false);
        }
      }
      
      found.toggleDim(false);
      found.toggleHighlight(false);
    }
    removeSelf();
  }
  
  public void highlightSearch()
  {
    outputComponents = new HashMap<String,InterfaceItem>();
    outputComponents.putAll(interfaceComponents);
    InterfaceItem found = interfaceComponents.get(this.srch.getText().substring(0,this.srch.getText().length()).toLowerCase());
    
    if(found == null){
      println("no button found");
    } else {
      outputComponents.remove(this.srch.getText().substring(0,this.srch.getText().length()).toLowerCase());
      found.toggleHighlight(true);
      for (InterfaceItem btn : outputComponents.values()) {
        btn.toggleDim(false);
        btn.toggleHighlight(false);
        for (InterfaceItem parent : btn.getPath().values())
        {
          parent.toggleHighlight(false);
          parent.toggleDim(false);
        }
      }
      found.toggleHighlight(true);
      found.toggleDim(false);
      for (InterfaceItem parent : found.getPath().values())
      {
        parent.toggleHighlight(true);
        parent.toggleDim(false);
      }
    }
    removeSelf();
  }
  
  public void removeSelf()
  {
    this.srch.setText("");
    this.srch.setAlpha(0);
  }
  
  public void updateMap(HashMap<String,InterfaceItem> inputComponents){
    
    for(HashMap.Entry<String,InterfaceItem> btn : inputComponents.entrySet()){
      println(btn.getKey());
      interfaceComponents.put(btn.getKey().toLowerCase(),btn.getValue());
    }
  }
    
    public void updateMap2(HashMap<String,InterfaceItem> inputComponents){
    
      for(HashMap.Entry<String,InterfaceItem> btn : inputComponents.entrySet()){
        ribbons.put(btn.getKey().toLowerCase(),btn.getValue());
      }
    }
  
  public Object getRootObj(){return this.srch;}  
  public HashMap<String,InterfaceItem> getPath(){return null;}
  public String getName(){return "Search menu";}
  public boolean isHidden(){return true;}
  public float getX(){return 0;}
  public float getY(){return 0;}
  public float getHeight(){return 0;}
  public float getWidth(){return 0;}
  public void update(){}
  public void setPath(HashMap<String,InterfaceItem> parentIn){}
  public void toggleHighlight(boolean newVal){}
  public void toggleDim(boolean newVal){}  
  public void hide(){}
  public void show(){} 
}