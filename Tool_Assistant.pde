import java.awt.event.InputEvent;
import java.awt.Robot;
Robot robot;

color background;
HashMap<String, InterfaceItem> interfaceComponents, ribBtns, ribBtns2, dropBtns, ribList, dropList, openBtns, workAround;
HashMap<String, AssistantButton> startMap;
ArrayList<InterfaceItem> testCaseA, testCaseB, testCaseC, runningTest; 
ArrayList<ArrayList<InterfaceItem>> testCases;
InterfaceItem b1, b2, d1, d1arrow, d2arrow, d2, srch, ribbon1, ribbon2;
int bclick, dclick, totalClicks;
boolean srchExists = false;
boolean robotClick = false;
EDropDown ed1, ed2;
String input ="[TYPE INTEGER ID HERE]";
String taskChosen ="No task was chosen Yet";
String testType;
int scrSizeX = 1024;
int scrSizeY = 768;
float start;
float timer;
InterfaceItem tester;

//Flow Controls
boolean atStartScreen = true;
boolean atTestingScreen = false;
boolean noTextYet = true;
boolean inBlock = false;
boolean testCompleted = false;
boolean isPractice = false;
boolean isPaused = false;
boolean shouldBuildTest = false;
boolean newTest, initTest, testing;
GButton test1, test2, test3, manual;

//For statistics output
int[] cases = new int[3];
int caseRunning = 0;
int userNumber;
int blockCounter = 1;
int trialCounter = 0;
int button = 1;
float targetDistance;
float elapsedTime;
int erroneousClicks;
Table stats = new Table();

void setup() {
  size(1050, 700);
  background = color(0, 0, 0);
  background(background);
  bclick = 0;
  atStartScreen = true;
  startMap = new HashMap<String, AssistantButton>();
  startMap.put("Test1", new AssistantButton(this, 0.2*scrSizeX, 0.6*scrSizeY, 120, 30, "Test1"));
  startMap.put("Test2", new AssistantButton(this, 0.35*scrSizeX, 0.6*scrSizeY, 120, 30, "Test2"));
  startMap.put("Test3", new AssistantButton(this, 0.5*scrSizeX, 0.6*scrSizeY, 120, 30, "Test3"));
  startMap.put("Practice", new AssistantButton(this, 0.65*scrSizeX, 0.6*scrSizeY, 120, 30, "Practice"));
}

void draw() {

  if (atStartScreen)
  {
    background(background);
    textSize(32);
    fill(255);
    textAlign(CENTER, CENTER);
    text("Welcome to the Tool - Assisted Spatial Location Application", scrSizeX/2, (scrSizeY/2)-200);
    text("Please enter an ID, select a test method, and hit enter to begin", scrSizeX/2, (scrSizeY/2)-100);
    textSize(20);
    text(input, 0, 0, width, height);
    text(taskChosen, 0, -20, width, height);
  } else if (atTestingScreen && !isPaused)
  {
    background(background);
    if (shouldBuildTest)
    {
      if (isPractice)
        buildTestEnvironment(); //This is a lot of processing / memory. Builds our whole UI
      else
      {
        buildTestEnvironment();
        buildStatsTable();
        testCases = new ArrayList<ArrayList<InterfaceItem>>();
        if (testType.equals("Test1"))        //We do 1(baseline), 2(tool), 3(tool + effort)
        {
          testCaseA = buildTestCases("Test1");
          testCaseB = buildTestCases("Test2");
          testCaseC = buildTestCases("Test3");
          cases[0] = 1;
          cases[1] = 2;
          cases[2] = 3;
        } else if (testType.equals("Test2"))    //We do 2(tool), 3(tool + effort), 1(baseline) 
        {
          testCaseA = buildTestCases("Test2");
          testCaseB = buildTestCases("Test3");
          testCaseC = buildTestCases("Test1");
          cases[0] = 2;
          cases[1] = 3;
          cases[2] = 1;
        } else if (testType.equals("Test3"))    //We do 3(tool + effort), 1(baseline), 2(tool) 
        {
          testCaseA = buildTestCases("Test3");
          testCaseB = buildTestCases("Test1");
          testCaseC = buildTestCases("Test2");
          cases[0] = 3;
          cases[1] = 1;
          cases[2] = 2;
        } else
          println("The taskChosen value was not any of the three we have defined.");

        runningTest = testCaseA;
        caseRunning = 0;
        tester = runningTest.remove(0); // set the first one

        InterfaceItem targetBtn = ((InterfaceItem)tester);
        InterfaceItem targetParent = null;
        for (InterfaceItem parent : targetBtn.getPath().values())
        {
          targetParent = parent;
        }
        if (targetParent != null)
        {
          targetDistance += Math.sqrt(Math.pow((mouseX-((targetParent.getX() + targetParent.getWidth())/2)), 2)+Math.pow((mouseY-((targetParent.getY() + targetParent.getHeight())/2)), 2));
          targetDistance += Math.sqrt(Math.pow(((targetParent.getX() + targetParent.getWidth())/2) - ((targetBtn.getX() + targetBtn.getWidth())/2), 2)+Math.pow(((targetParent.getY() + targetParent.getHeight())/2) - ((targetBtn.getY() + targetBtn.getHeight())/2), 2));
        } else
        {
          targetDistance += Math.sqrt(Math.pow((mouseX-((targetBtn.getX() + targetBtn.getWidth())/2)), 2)+Math.pow((mouseY-((targetBtn.getY() + targetBtn.getHeight())/2)), 2));
        }

        println("Value of tester is: "+tester.getName());

        testCases.add(testCaseB);
        testCases.add(testCaseC);

        initTest = true;
      }
      shouldBuildTest = false;
    }
    if (!isPractice)
    {
      String name = tester.getName();
      textSize(32);
      fill(255);
      textAlign(CENTER, BOTTOM);
      text("The Button to search for is: "+name, scrSizeX*0.5, scrSizeY*0.9);
      if(cases[caseRunning] == 1)
      {
        text("Note: Assistant Tool is DISABLED in this test.", scrSizeX*0.5, scrSizeY*0.8);
      }
      else if(cases[caseRunning] == 2)
      {
        text("Note: Manual Selection is DISABLED in this test. "+name, scrSizeX*0.5, scrSizeY*0.8);
      }

      if (initTest) //Initialize testing variables
      {
        start = millis();
        timer = 0;
        testing = true;
        erroneousClicks = 0;
        initTest = false;
      }
      if (testing) //Actively running test
      {
        timer = millis()-start; //timer increments
      } else
      {
        elapsedTime = timer;
        timer = 0;
        //Submit button click time to stats, submit distance to target, submit erroneousClicks
        println("Button Clicked. Inserting into table: \nUser# "+userNumber+",\nCase# "+cases[caseRunning]+"\nButton# "+button+",\nTarget Distance: "+targetDistance+",\nErroneous Clicks: "+erroneousClicks+",\nElapsed Time: "+elapsedTime/1000+".");
        TableRow trial = stats.addRow();
        trial.setInt("User Number", userNumber);
        trial.setInt("Case", cases[caseRunning]);
        trial.setInt("Button", button);
        trial.setFloat("Target Distance", targetDistance);
        trial.setInt("Erroneous Clicks", erroneousClicks);
        trial.setFloat("Elapsed Time", elapsedTime/1000);
        if (runningTest.isEmpty()) //We have completed a run of tests.
        {
          println("Test case finished.");
          isPaused = true;
          if (testCases.isEmpty()) //We are done
          {
            println("Ran out of test cases!");
            testCompleted = true;
            atTestingScreen = false;
            isPaused = false;
          } else
          {
            runningTest = testCases.remove(0);
            tester = runningTest.remove(0); // set the first one
            caseRunning++;
            button = 1;
            initTest = true;
          }
        } else
        {            
          tester = runningTest.remove(0); // set the first one
          button++;
          println("Value of tester is: "+tester.getName());
          //re-initialize test
          initTest = true; 
          targetDistance = 0;

          InterfaceItem targetBtn = ((InterfaceItem)tester);
          InterfaceItem targetParent = null;
          for (InterfaceItem parent : targetBtn.getPath().values())
          {
            targetParent = parent;
          }
          if (targetParent != null)
          {
            targetDistance += Math.sqrt(Math.pow((mouseX-((targetParent.getX() + targetParent.getWidth())/2)), 2)+Math.pow((mouseY-((targetParent.getY() + targetParent.getHeight())/2)), 2));
            targetDistance += Math.sqrt(Math.pow(((targetParent.getX() + targetParent.getWidth())/2) - ((targetBtn.getX() + targetBtn.getWidth())/2), 2)+Math.pow(((targetParent.getY() + targetParent.getHeight())/2) - ((targetBtn.getY() + targetBtn.getHeight())/2), 2));
          } else
          {
            targetDistance += Math.sqrt(Math.pow((mouseX-((targetBtn.getX() + targetBtn.getWidth())/2)), 2)+Math.pow((mouseY-((targetBtn.getY() + targetBtn.getHeight())/2)), 2));
          }
        }
      }
    }
    for (InterfaceItem btn : interfaceComponents.values())
    {
      btn.update();
    }
  } else if (isPaused)
  {
    background(background);
    textSize(15);
    fill(255);
    textAlign(LEFT, BOTTOM);
    text("Please take a short break and do the questionnaire for this section. Hit the Enter key when ready to begin the next test.", scrSizeX*0.05, scrSizeY*0.9);
  } else if (testCompleted)
  {
    background(0, 255, 0);
    text("Thank you for participating in our Experiment!", scrSizeX/2, (scrSizeY/2)-100);
    text("Output saved as: CompletedTests/UserID"+userNumber+"_"+year()+month()+day()+"-"+hour()+minute()+second()+".tsv", 0, 0, width, height);
    printStats();
    noLoop(); //Finished test.
  }
}

//This method will be called in draw once the interface is ready to be drawn.
void buildTestEnvironment()
{
  interfaceComponents = new HashMap<String, InterfaceItem>();
  workAround = new HashMap<String, InterfaceItem>();
  ribList = new HashMap<String, InterfaceItem>();
  dropList = new HashMap<String, InterfaceItem>();

  //Populate open viewed buttons
  openBtns = new HashMap<String, InterfaceItem>();
  openBtns.putAll(buildOpenButtons());

  //Populate Ribbon Buttons

  ribbon2 = new Ribbon(this, 320, 0, 160, 30, "ribbon 2");
  ribBtns2 = new HashMap<String, InterfaceItem>(); 
  ribBtns2.putAll(buildRibbonButtons2());
  workAround.clear();
  workAround.put("Ribbon", ribbon2);
  ((Ribbon)ribbon2).fillHash(ribBtns2);
  ((Ribbon)ribbon2).setPath(workAround);
  ribList.put("ribbon 2", ribbon2);
  ribbon1 = new Ribbon(this, 160, 0, 160, 30, "ribbon 1");
  ribBtns = new HashMap<String, InterfaceItem>();
  ribBtns.putAll(buildRibbonButtons());
  workAround.clear();
  workAround.put("Ribbon", ribbon1);
  ((Ribbon)ribbon1).fillHash(ribBtns);
  ((Ribbon)ribbon1).setPath(workAround);
  ribList.put("ribbon 1", ribbon1);     
  //Populate dropdowns
  d1 = new AssistantDropDown(this, 200, 200, 160, 30, "drop 1", buildDropdownButtons1());
  d1arrow = ((EDropDown)d1.getRootObj()).getArrow();
  ed1 = ((AssistantDropDown) d1).list;
  d2 = new AssistantDropDown(this, 500, 200, 160, 30, "drop 2", buildDropdownButtons2());
  d2arrow = ((EDropDown)d2.getRootObj()).getArrow();
  ed2 = ((AssistantDropDown) d2).list;

  dropList.put("drop 1", d1);
  dropList.put("drop 2", d2);

  //Populate tags for dropdowns
  populateTxtTags(ed1.getInterfaceList());
  populateTxtTags(ed2.getInterfaceList());

  //put values into dropBtns
  dropBtns = new HashMap<String, InterfaceItem>();
  for (AssistantButton b : ed1.getInterfaceList().values())
  {
    dropBtns.put(b.getName(), (InterfaceItem)b);
  }
  for (AssistantButton b : ed2.getInterfaceList().values())
  {
    dropBtns.put(b.getName(), (InterfaceItem)b);
  }

  Set<String> keys = ribBtns2.keySet();
  for (Iterator<String> it = keys.iterator(); it.hasNext(); )
  {
    InterfaceItem btn = ribBtns2.get(it.next());
    ((AssistantImgButton)btn).setAlpha(0);
  }
  for (InterfaceItem ribbon : ribList.values())
  {
    ribbon.hide();
  }
  //for (InterfaceItem ribbon : ribList.values())
  //{
   // ribbon.show();
   // break;
  //}
  ribList.get("ribbon 1").show();
  ribList.get("ribbon 2").toggleDim(true);
  
  interfaceComponents.putAll(ribBtns);
  interfaceComponents.putAll(ribBtns2);
  interfaceComponents.putAll(openBtns);
  interfaceComponents.putAll(dropBtns);
}


ArrayList<InterfaceItem> buildTestCases(String testCase)
{
  switch(testCase)
  {

  case "Test1":   
    ArrayList<InterfaceItem> testCases1 = new ArrayList<InterfaceItem>(); //7 dd, 7 rib, 6 open
    testCases1.add(interfaceComponents.get("plus"));
    testCases1.add(interfaceComponents.get("arrowdown"));
    testCases1.add(interfaceComponents.get("phone"));
    testCases1.add(interfaceComponents.get("calendar"));
    testCases1.add(interfaceComponents.get("unlock"));
    testCases1.add(interfaceComponents.get("cross"));
    testCases1.add(interfaceComponents.get("video"));
    testCases1.add(interfaceComponents.get("locate"));
    testCases1.add(interfaceComponents.get("desktop"));
    testCases1.add(interfaceComponents.get("previous"));
    testCases1.add(interfaceComponents.get("share"));
    testCases1.add(interfaceComponents.get("download"));
    testCases1.add(interfaceComponents.get("link"));
    testCases1.add(interfaceComponents.get("home"));
    testCases1.add(interfaceComponents.get("settings"));
    testCases1.add(interfaceComponents.get("arrowup"));
    testCases1.add(interfaceComponents.get("frown"));
    testCases1.add(interfaceComponents.get("sync"));
    testCases1.add(interfaceComponents.get("elevator"));
    testCases1.add(interfaceComponents.get("tick"));
    return testCases1;

  case "Test2":   
    ArrayList<InterfaceItem> testCases2 = new ArrayList<InterfaceItem>(); //6 dd, 7 rib, 7 open
    testCases2.add(interfaceComponents.get("arrowleft"));
    testCases2.add(interfaceComponents.get("trash"));
    testCases2.add(interfaceComponents.get("play"));
    testCases2.add(interfaceComponents.get("barstats"));
    testCases2.add(interfaceComponents.get("pause"));
    testCases2.add(interfaceComponents.get("camera"));
    testCases2.add(interfaceComponents.get("bubble"));
    testCases2.add(interfaceComponents.get("piestats"));
    testCases2.add(interfaceComponents.get("dashboard"));
    testCases2.add(interfaceComponents.get("tablet"));
    testCases2.add(interfaceComponents.get("openmail"));
    testCases2.add(interfaceComponents.get("dislike"));
    testCases2.add(interfaceComponents.get("lock"));
    testCases2.add(interfaceComponents.get("user"));
    testCases2.add(interfaceComponents.get("eye"));
    testCases2.add(interfaceComponents.get("upload"));
    testCases2.add(interfaceComponents.get("heart"));
    testCases2.add(interfaceComponents.get("like"));
    testCases2.add(interfaceComponents.get("smile"));
    testCases2.add(interfaceComponents.get("globe"));
    println("Built test case 2");
    return testCases2;

  case "Test3":   
    ArrayList<InterfaceItem> testCases3 = new ArrayList<InterfaceItem>(); //7 dd, 6 rib, 7 open
    testCases3.add(interfaceComponents.get("tower"));//
    testCases3.add(interfaceComponents.get("arrowright"));//
    testCases3.add(interfaceComponents.get("mute"));
    testCases3.add(interfaceComponents.get("star"));//
    testCases3.add(interfaceComponents.get("clock"));//
    testCases3.add(interfaceComponents.get("pencil"));//
    testCases3.add(interfaceComponents.get("image"));//
    testCases3.add(interfaceComponents.get("search"));//
    testCases3.add(interfaceComponents.get("next"));//
    testCases3.add(interfaceComponents.get("document"));//
    testCases3.add(interfaceComponents.get("unreadmail"));//
    testCases3.add(interfaceComponents.get("refresh"));//
    testCases3.add(interfaceComponents.get("list"));//
    testCases3.add(interfaceComponents.get("folder"));//
    testCases3.add(interfaceComponents.get("tag"));//
    testCases3.add(interfaceComponents.get("info"));//
    testCases3.add(interfaceComponents.get("grid"));//
    testCases3.add(interfaceComponents.get("cart"));//
    testCases3.add(interfaceComponents.get("fake"));//
    testCases3.add(interfaceComponents.get("volumeUp"));//
    println("Built test case 3");
    return testCases3;

  default:
    return null;
  }
}

void keyPressed() {
  if (atStartScreen)
  {
    if (noTextYet)
    {
      input = "";
      noTextYet = false;
    }

    if (keyCode == BACKSPACE) {
      if (input.length() > 0) {
        input = input.substring(0, input.length()-1);
      }
    } else if (keyCode == DELETE) {
      input = "";
    } else if (keyCode == ENTER) {
      verifyInput();
    } else if (key == '1' || key == '2' || key == '3' || key == '4' || key == '5' || key == '6' || key == '7' || key == '8' || key == '9' || key == '0') {
      input = input + key;
    }
  } else
  {
    if (keyCode == ALT && cases[caseRunning] != 1) { // Enforce Manual Search  
      try {
        robot = new Robot();
      } 
      catch (AWTException e) {
        e.printStackTrace();
        exit();
      }
      if (!srchExists)
      {
        srch = new SearchMenu(this, mouseX-80, mouseY-20, 160, 40);
        ((SearchMenu)srch).updateMap(ribBtns);
        ((SearchMenu)srch).updateMap(ribBtns2);
        ((SearchMenu)srch).updateMap(dropBtns);
        ((SearchMenu)srch).updateMap(openBtns);
        robotClick = true;
        robot.mousePress(InputEvent.BUTTON1_MASK);
        srchExists = true;
      } else {
        ((SearchMenu)srch).removeSelf();
        srch = new SearchMenu(this, mouseX-80, mouseY-20, 160, 40);
        ((SearchMenu)srch).updateMap(ribBtns);
        ((SearchMenu)srch).updateMap(ribBtns2);
        ((SearchMenu)srch).updateMap(dropBtns);
        ((SearchMenu)srch).updateMap(openBtns);
        robot.mousePress(InputEvent.BUTTON1_MASK);
        srchExists = true;
      }
    } else if (keyCode == ENTER) {
      if (srchExists)
      {
        ((SearchMenu)srch).highlightSearch();
        srchExists = false;
      } else if (isPaused)
      {
        println("We hit ENTER after a pause: recommence testing."); 
        isPaused = false;
      }
    }
  }
}

boolean verifyInput()
{
  if (startMap.get("Practice").isHighlighted)
  {
    isPractice = true;
    atStartScreen = false;
    atTestingScreen = true;
    shouldBuildTest = true;
    for (AssistantButton a : startMap.values())
    {
      a.hide();
    }
    return true; // Skip validation, we're not recording stats.
  } else
  {
    try {
      userNumber= Integer.parseInt(input);
    }
    catch(NumberFormatException e) {
      input = "Invalid input. Please enter an integer.";
      noTextYet = true;
      return false;
    }
    boolean oneSelected = false;
    for (AssistantButton b : startMap.values())
    {
      if (b.isHighlighted)
      {
        oneSelected = true;
        break;
      }
    }
    if (!oneSelected)
    {
      taskChosen = "No task was chosen. Please chose a task from the 4 choices.";
      return false;
    }
    atStartScreen = false;
    atTestingScreen = true;
    shouldBuildTest = true;
    for (AssistantButton a : startMap.values())
    {
      a.hide();
    }
    return true;
  }
}
void mousePressed()
{
  if (tester != null)
  {
    if (tester instanceof InterfaceItem)
    {
      InterfaceItem targetBtn = ((InterfaceItem)tester);
      InterfaceItem targetParent = null;
      for (InterfaceItem parent : targetBtn.getPath().values())
      {
        targetParent = parent;
      }
      if (targetParent != null)
      {
        if ((mouseX >= targetBtn.getX()) && (mouseY >= targetBtn.getY()) && (mouseX < (targetBtn.getX() + targetBtn.getWidth())) && (mouseY < (targetBtn.getY() + targetBtn.getHeight())) && (targetBtn.isHidden() == false))
        {
          testing = false;
        } else if ((mouseX >= targetParent.getX()) && (mouseY >= targetParent.getY()) && (mouseX < (targetParent.getX() + targetParent.getWidth())) && (mouseY < (targetParent.getY() + targetParent.getHeight())))
        {
        } else 
        {
          if(!robotClick)
          {
            erroneousClicks++;
            println("erroneous click with<out> parent");
          }
          else
          {
            robotClick = false;
          }
        }
      } else 
      {
        if (((mouseX >= targetBtn.getX()) && (mouseY >= targetBtn.getY()) && (mouseX < (targetBtn.getX() + targetBtn.getWidth())) && (mouseY < ((targetBtn.getY() + targetBtn.getHeight())))))
        {
          testing = false;
        } else 
        {
          erroneousClicks++;
          println("Erroneous Click without parent");
        }
      }
    }
  }
}

void handleButtonEvents(GImageButton source, GEvent event) 
{
  AssistantImgButton btn = ((AssistantImgButton)source);
  if (btn.getHighlight())
  {
    btn.toggleHighlight(false);
  }
}



void handleTextEvents(GEditableTextControl textControl, GEvent event)
{  
  if (event.getType() == "ENTERED") 
  {
    ((SearchMenu)srch).highlightSearch();
    srchExists = false;
  }
}

void handleButtonEvents(GButton source, GEvent event)
{ 
  AssistantButton b = (AssistantButton) source;
  if (atStartScreen)
  {   
    println("We are at the main screen with a button evt. button is: "+b.getName());
    if (!b.isHighlighted)
    {
      for (AssistantButton a : startMap.values())
      {
        if (a.getName().equals(b.getName()))
        {
          taskChosen = "The task chosen was: "+b.getName();
          testType = b.getName();
          b.toggleHighlight(true); //Highlight the one we clicked
          if (b.getName().equals("Practice"))
          {
            verifyInput();
          }
        } else
          a.toggleHighlight(false); //un-highlight everything else.
      }
      return;
    }
  }


  String srcText = source.getText();
  AssistantButton btn = (AssistantButton)source;
  //System.out.println(btn.getName() + " clicked");  

  if (btn.getHighlight())
  {
    btn.toggleHighlight(false);
  }
  if (btn.getName().length() > 5)
  {
    if (btn.getName().substring(0, 6).toLowerCase().equals("ribbon"))
    {
      for (InterfaceItem ribbon : ribList.values())
      {
        if (((Ribbon)ribbon).getName() == btn.getName())
        {
          ribbon.show();
          ribbon.toggleDim(false);
        } else {
          ribbon.hide();
          ribbon.toggleDim(true);
        }
      }
    }
  }
  //DropLists --------------------
  //if arrow1 is clicked
  if (source ==((EDropDown)((AssistantDropDown) d1).list).getArrow().getRootObj() && event == GEvent.CLICKED)
  {
    ((AssistantDropDown)d1).list.toggleVisible();
    if (((AssistantDropDown)d2).list.getState())
    {
      ((AssistantDropDown)d2).list.toggleVisible();
    }
  }
  if (((AssistantDropDown)d1).list.contains(srcText))
  {
    ((AssistantDropDown)d1).list.setMainText(srcText);
    ((AssistantDropDown)d1).list.toggleVisible();
    if (((AssistantDropDown)d2).list.getState())
    {
      ((AssistantDropDown)d2).list.toggleVisible();
    }
  }
  //if arrow2 is clicked
  if (source ==((EDropDown)((AssistantDropDown) d2).list).getArrow().getRootObj() && event == GEvent.CLICKED)
  {
    ((AssistantDropDown)d2).list.toggleVisible();
    if (((AssistantDropDown)d1).list.getState())
    {
      ((AssistantDropDown)d1).list.toggleVisible();
    }
  }
  if (((AssistantDropDown)d2).list.contains(srcText))
  {
    ((AssistantDropDown)d2).list.setMainText(srcText);
    ((AssistantDropDown)d2).list.toggleVisible(); 
    if (((AssistantDropDown)d1).list.getState())
    {
      ((AssistantDropDown)d1).list.toggleVisible();
    }
  }
}

void handleDropDownEvents(EDropDown list, GEvent event) {
  if (list==d1.getRootObj() && event == GEvent.SELECTED) {
    bclick++;
    if (bclick % 3 == 1) {
      d1.toggleHighlight(true);
    } else if (bclick % 3 == 2) {
      d1.toggleDim(true);
      d1.toggleHighlight(false);
    } else {
      d1.toggleDim(false);
      d1.toggleHighlight(false);
    }
  }
  println("XXX DROPDOWN ONE WAS CLICKED! XXX\n\t" + event);
}

HashMap<String, AssistantImgButton> buildRibbonButtons()
{
  HashMap<String, AssistantImgButton> ribBtns = new HashMap<String, AssistantImgButton>();
  ribBtns.put("arrowdown", new AssistantImgButton(this, 160, 40, 30, 30, "arrowdown", new String[] {"arrow-down.png" } ));
  ribBtns.put("arrowleft", new AssistantImgButton(this, 200, 40, 30, 30, "arrowleft", new String[] {"arrow-left.png" } ));
  ribBtns.put("arrowright", new AssistantImgButton(this, 240, 40, 30, 30, "arrowright", new String[] {"arrow-right.png" }));
  ribBtns.put("arrowup", new AssistantImgButton(this, 280, 40, 30, 30, "arrowup", new String[] {"arrow-up.png"}));
  ribBtns.put("calendar", new AssistantImgButton(this, 320, 40, 30, 30, "calendar", new String[] {"calendar.png"}));
  ribBtns.put("camera", new AssistantImgButton(this, 360, 40, 30, 30, "camera", new String[] {"camera.png"}));
  ribBtns.put("clock", new AssistantImgButton(this, 400, 40, 30, 30, "clock", new String[] {"clock.png"}));
  ribBtns.put("cross", new AssistantImgButton(this, 440, 40, 30, 30, "cross", new String[] {"cross.png"}));
  ribBtns.put("dashboard", new AssistantImgButton(this, 480, 40, 30, 30, "dashboard", new String[] {"dashboard.png"}));
  ribBtns.put("image", new AssistantImgButton(this, 520, 40, 30, 30, "image", new String[] {"image.png"}));
  populateTags(ribBtns);
  return ribBtns;
}

HashMap<String, AssistantImgButton> buildRibbonButtons2()
{
  HashMap<String, AssistantImgButton> ribBtns2 = new HashMap<String, AssistantImgButton>();
  ribBtns2.put("desktop", new AssistantImgButton(this, 160, 40, 30, 30, "desktop", new String[] {"desktop.png"}));
  ribBtns2.put("dislike", new AssistantImgButton(this, 200, 40, 30, 30, "dislike", new String[] {"dislike.png"}));
  ribBtns2.put("document", new AssistantImgButton(this, 240, 40, 30, 30, "document", new String[] {"document.png"}));
  ribBtns2.put("download", new AssistantImgButton(this, 280, 40, 30, 30, "download", new String[] {"download.png"}));
  ribBtns2.put("eye", new AssistantImgButton(this, 320, 40, 30, 30, "eye", new String[] {"eye.png"}));
  ribBtns2.put("folder", new AssistantImgButton(this, 360, 40, 30, 30, "folder", new String[] {"folder.png"}));
  ribBtns2.put("home", new AssistantImgButton(this, 400, 40, 30, 30, "home", new String[] {"home.png"}));
  ribBtns2.put("heart", new AssistantImgButton(this, 440, 40, 30, 30, "heart", new String[] {"heart.png"}));
  ribBtns2.put("grid", new AssistantImgButton(this, 480, 40, 30, 30, "grid", new String[] {"grid.png"}));
  ribBtns2.put("globe", new AssistantImgButton(this, 520, 40, 30, 30, "globe", new String[] {"globe.png"}));

  populateTags(ribBtns2);
  return ribBtns2;
}

HashMap<String, AssistantImgButton> buildOpenButtons()
{

  HashMap<String, AssistantImgButton> openBtns = new HashMap<String, AssistantImgButton>();
  openBtns.put("video", new AssistantImgButton(this, 80, 140, 50, 50, "video", new String[] { "video.png", "video.png", "video.png" } ));
  openBtns.put("trash", new AssistantImgButton(this, 20, 90, 50, 50, "trash", new String[] { "trash.png", "trash.png", "trash.png" } ));
  openBtns.put("volumeUp", new AssistantImgButton(this, 20, 540, 50, 50, "volumeUp", new String[] { "volume-1.png", "volume-1.png", "volume-1.png" }));
  openBtns.put("previous", new AssistantImgButton(this, 80, 540, 50, 50, "previous", new String[] { "previous.png", "previous.png", "previous.png" }));
  openBtns.put("barstats", new AssistantImgButton(this, 80, 490, 50, 50, "barstats", new String[] { "stats-2.png", "stats-2.png", "stats-2.png" }));
  openBtns.put("star", new AssistantImgButton(this, 20, 490, 50, 50, "star", new String[] { "star.png", "star.png", "star.png" }));
  openBtns.put("share", new AssistantImgButton(this, 20, 440, 50, 50, "share", new String[] { "share.png", "share.png", "share.png" }));
  openBtns.put("bubble", new AssistantImgButton(this, 80, 440, 50, 50, "bubble", new String[] { "speech-bubble.png", "speech-bubble.png", "speech-bubble.png" }));
  openBtns.put("search", new AssistantImgButton(this, 20, 390, 50, 50, "search", new String[] { "search.png", "search.png", "search.png" }));
  openBtns.put("settings", new AssistantImgButton(this, 80, 390, 50, 50, "settings", new String[] { "settings.png", "settings.png", "settings.png" }));
  openBtns.put("piestats", new AssistantImgButton(this, 80, 340, 50, 50, "piestats", new String[] { "stats-1.png", "stats-1.png", "stats-1.png" }));
  openBtns.put("refresh", new AssistantImgButton(this, 20, 340, 50, 50, "refresh", new String[] { "refresh.png", "refresh.png", "refresh.png" }));
  openBtns.put("sync", new AssistantImgButton(this, 80, 290, 50, 50, "sync", new String[] { "sync.png", "sync.png", "sync.png" }));
  openBtns.put("tablet", new AssistantImgButton(this, 20, 290, 50, 50, "tablet", new String[] { "tablet.png", "tablet.png", "tablet.png" }));
  openBtns.put("tag", new AssistantImgButton(this, 20, 240, 50, 50, "tag", new String[] { "tag.png", "tag.png", "tag.png" }));
  openBtns.put("tick", new AssistantImgButton(this, 80, 240, 50, 50, "tick", new String[] { "tick.png", "tick.png", "tick.png" }));
  openBtns.put("user", new AssistantImgButton(this, 20, 140, 50, 50, "user", new String[] { "user.png", "user.png", "user.png" }));
  openBtns.put("cart", new AssistantImgButton(this, 20, 190, 50, 50, "cart", new String[] { "trolley.png", "trolley.png", "trolley.png" }));
  openBtns.put("upload", new AssistantImgButton(this, 80, 190, 50, 50, "upload", new String[] { "upload.png", "upload.png", "upload.png" }));
  openBtns.put("mute", new AssistantImgButton(this, 80, 90, 50, 50, "mute", new String[] { "volume-2.png", "volume-2.png", "volume-2.png" }));

  populateTags(openBtns);
  return openBtns;
}

String[] buildDropdownButtons1()
{

  String[] dropBtns1 = new String[10];
  dropBtns1[0]="plus";
  dropBtns1[1]="play";
  dropBtns1[2]="phone";
  dropBtns1[3]="pencil";
  dropBtns1[4]="pause";
  dropBtns1[5]="next";
  dropBtns1[6]="unlock";
  dropBtns1[7]="openmail";
  dropBtns1[8]="unreadmail";
  dropBtns1[9]="lock";
  return dropBtns1;
}

String[] buildDropdownButtons2()
{  
  String[] dropBtns2 = new String[10];
  dropBtns2[0]="locate";
  dropBtns2[1]="list";
  dropBtns2[2]="link";
  dropBtns2[3]="like";
  dropBtns2[4]="info";
  dropBtns2[5]="frown";
  dropBtns2[6]="smile";
  dropBtns2[7]="fake";
  dropBtns2[8]="elevator";
  dropBtns2[9]="tower";

  return dropBtns2;
}


private void populateTxtTags(HashMap<String, AssistantButton> btns)
{
  Iterator<String> it = btns.keySet().iterator();
  String[] tags;
  ArrayList<String> t;
  AssistantButton b;
  while (it.hasNext())
  {
    String ref = it.next();
    switch(ref)
    {

    case "plus": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "play": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "phone": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "pencil": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "pause": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "next": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "unlock": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "openmail": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "unreadmail": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "lock": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "locate": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "list": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "link": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "like": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "info": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "image": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "home": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "heart": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "grid": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "globe": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "frown": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "smile": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "fake": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "elevator": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "tower": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    default: 
      println("Text Button "+ref+" Not found.");
    }
  }
}            

//This function is a big switch statement per button that allows us to provide tags to each button.
private void populateTags(HashMap<String, AssistantImgButton> btns)
{
  Iterator<String> it = btns.keySet().iterator();
  String[] tags;
  ArrayList<String> t;
  AssistantImgButton b;
  while (it.hasNext())
  {
    String ref = it.next();
    switch(ref)
    {

    case "video": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "trash": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "volumeUp": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "previous": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "barstats": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "star": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "share": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "bubble": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "search": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "settings": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "piestats": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "refresh": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "sync": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "tablet": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "tag": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "tick": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "user": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "cart": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "upload": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "mute": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "arrowdown": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "arrowleft": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "arrowright": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "arrowup": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "calendar": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "camera": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "clock": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "cross": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "dashboard": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "desktop": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "dislike": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "document": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "download": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "eye": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "folder": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "globe": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "grid": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "heart": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "home": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    case "image": 
      b = btns.get(ref);
      tags = new String[]{"", ""};
      t = new ArrayList<String>(Arrays.asList(tags));
      b.setTags(t);
      println("Added the following tags to "+ref+": "+t);
      break;
    default: 
      println("Button "+ref+" Not found.");
    }
  }
}

void buildStatsTable()
{
  stats.addColumn("User Number", Table.INT);
  stats.addColumn("Case", Table.INT);
  stats.addColumn("Button", Table.INT);
  stats.addColumn("Target Distance", Table.FLOAT);
  stats.addColumn("Erroneous Clicks", Table.INT);
  stats.addColumn("Elapsed Time", Table.FLOAT);
}

void printStats()
{
  println("Creating file and saving table data into it: UserID"+userNumber+"_"+year()+month()+day()+"-"+hour()+minute()+second()+".csv");
  saveTable(stats, "CompletedTests/UserID"+userNumber+"_"+year()+month()+day()+"-"+hour()+minute()+second()+".csv", "csv");
}