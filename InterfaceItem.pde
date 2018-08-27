

//This interface defines the common characteristics that we can utilize from the Main executing program standpoint.

public interface InterfaceItem
{
 public HashMap<String,InterfaceItem> getPath(); //This method returns a hashmap of numbered steps required to get to a certain target point.
 public void toggleHighlight(boolean newVal);                                // This method toggles highlighting the component.
 public void toggleDim(boolean newVal);                                      // This method toggles dimming the component.       
 public void setPath(HashMap<String,InterfaceItem> parentIn);                                    // This method changes the clicks required to have the button submitted.
 public Object getRootObj();                                                 // This method is used to return the interior object we are wrapping
 public void show();
 public void hide();
 public String getName();
 public void update();
 public float getX();
 public float getY();
 public float getHeight();
 public float getWidth();
 public boolean isHidden();
}