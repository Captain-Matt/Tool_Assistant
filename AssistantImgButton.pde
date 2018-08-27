public class AssistantImgButton extends GImageButton implements InterfaceItem
{
   GButton btn;
   GImageButton imBtn;
   GPanel toolTip;
   color original;
   boolean isHighlighted,isDimmed,isClicked,isHidden = false;
   int numClicks, millisHeld, lastMillis;
   float x1,y1,x2,y2;
   String btnName;
   ArrayList <String> tags; //For search capabilities. Initially empty.
   PImage originalPic;
   HashMap<String,InterfaceItem> parents = new HashMap<String,InterfaceItem>();
   
   public AssistantImgButton(PApplet theApplet, float p0, float p1, float p2, float p3, String name, String[] fname){
     super(theApplet, p0, p1, p2, p3, fname);
     toolTip = new GPanel(theApplet, p0, p1,10 + (10*name.length()), 15, "   " + name);
     x1 = p0;
     y1 = p1;
     x2 = x1 + p2;
     y2 = y1 + p3;
     isHighlighted = false;
     isDimmed = false;
     isClicked = false;
     millisHeld = 0;
     numClicks = 1;
     btnName = name;
     setLocalColor(4,color(88,89,91)); //idle
     setLocalColor(6,color(88,89,91)); //hover
     tags = new ArrayList<String>();
   }
   
   public boolean isHidden(){return isHidden;}
   
   public HashMap<String,InterfaceItem> getPath() //This method returns a hashmap of all contained values.
   {
     return parents; //Buttons will not contain anything: only menu types (dropdown / Ribbon) will contain stuff.
   }
   public void setPath(HashMap<String,InterfaceItem> parentIn)
   {
     parents.putAll(parentIn);
   }
   
   public void update()
   {
     int time = millis();
     int delta = time - lastMillis;
     if((mouseX >= x1) && (mouseX < x2) && (mouseY >= y1) && (mouseY < y2) && !isHidden)
     {
       millisHeld += delta;
     } else {
       millisHeld = 0;
     }
     
     if(millisHeld >= 500)
     {
       toolTip.moveTo(mouseX+5,mouseY+5);
       toolTip.setAlpha(255);
     } else {
       toolTip.setAlpha(0);
     }
     lastMillis = time;
   }
   
  public float getX(){return x1;}
  public float getY(){return y1;}
  public float getWidth(){return x2;}
  public float getHeight(){return y2;}
   
   public void toggleHighlight(boolean newVal)     // This method toggles highlighting the component.
   {
       if(newVal)
       {
          PImage p = this.bimage[0];
          int dimension = p.width * p.height;
          p.loadPixels();
          for (int i = 0; i < dimension; i++) { 
            //println("The pixel Colour is: "+p.pixels[i]);
            if(p.pixels[i] == 0 || p.pixels[i] == -16777216)
              p.pixels[i] = color(0, 255, 0); 
          } 
          p.updatePixels();
       }
       else
       {
          PImage p = this.bimage[0];
          int dimension = p.width * p.height;
          p.loadPixels();
          for (int i = 0; i < dimension; i++) { 
            //println("The pixel Colour is: "+p.pixels[i]);
            if(p.pixels[i] == -16711936)
            { 
              //println("set pixel back to black.");
              p.pixels[i] = color(0,0,0); 
            }
          } 
          p.updatePixels();
       }
       this.isHighlighted = newVal;
       System.out.println("Highlight setting for "+this.getName()+" is set to "+newVal+".");
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
       System.out.println("Dim setting for "+this.getName()+" is set to "+newVal+".");
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
   
   public Object getRootObj()
   {
       return this;
   }
   
   public boolean getHighlight()
   {
     return isHighlighted;
   }
   
   //Tag functionality - search button, set button----------
   
   public void setTags(ArrayList<String> inputTags)
   {
     this.tags = inputTags;
   }
   
   public void hide(){
     this.setAlpha(0);
     isHidden = true;
   }
   
   public void show(){
     this.setAlpha(255); 
     isHidden = false;
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