macro "color_random [0]" {

// ******************************************************
// Script by:						*
// Patrick Zuest, WSL Birmensdorf, Switzerland		*
// patrick.zuest@hotmail.com				*
// ******************************************************


dir = getDirectory("image");
imageTitle = getTitle();
size=100;
count=100;

if(File.exists(dir+"selection.roi")) {
	open(dir+"selection.roi");
	run("Measure");
	
	if(getResult("Area", 0)==getWidth()*getHeight()){
	//saved selection does not exclude any parts of the image
	selectWindow("Results");
	run("Close");
	createSelection(size,count);
	}
	else{
	selectWindow("Results");
	run("Close");
	createSelectionWith(size,count);
	}
	
      }
else{
createSelection(size,count);
}


analyzeColors(40, 189, 40, 255, 40, 255, "stop", dir, imageTitle, "red");
analyzeColors(125, 189, 40, 255, 120, 255, "pass", dir, imageTitle, "blue");
analyzeColors(0, 255, 0, 29, 120, 255, "pass", dir, imageTitle, "white");

saveSummary(dir, imageTitle);

  //saves a xls-file named after the original image
  function saveSummary(dir, imageTitle){

     roiManager("Select", 0);
     run("Select All");
     roiManager("Delete");
     selectWindow("ROI Manager");
     run("Close");

     selectWindow("Summary");
     saveAs("Measurements", dir+imageTitle+"_RAND"+".xls");

     run("Close");
     close();
  }  


  function createSelection(size,count){
     n=0;
     while(n<count){
       valid=true;
       valid2=false;
       random1=random()*getWidth();
       random2=random()*getHeight();
       if(random1+size>getWidth()||random2+size>getHeight()){
       valid=false;}
       if(valid==true){
       makeRectangle(random1, random2, size, size);
       roiManager("Add");
       n=n+1;
     }
  }

  function createSelectionWith(size,count){
     run("Clear Outside");
     n=0;
       while(n<count){
       valid=true;
       valid2=false;
       random1=random()*getWidth();
       random2=random()*getHeight();
       if(random1+size>getWidth()||random2+size>getHeight()){
       valid=false;}
       if(valid==true){
       makeRectangle(random1, random2, size, size);
       run("Measure");
       if(getResult("Min", 0)>0){valid2=true;}
       selectWindow("Results");
       run("Close");
       if(valid==true&&valid2==true){
       roiManager("Add");
         n=n+1;
         }
       }
       roiManager("Deselect");
       run("Select All");
  }


 function analyzeColors(minHue, maxHue, minSat, maxSat, minBright, maxBright, filterVal, dir, imageTitle, color){
      setBatchMode(true);
      run("Select All");
      run("Duplicate...", "title=1.tif");
      run("Threshold Colour");
      //creates array to store the values
      min=newArray(3);
      max=newArray(3);
      filter=newArray(3);
      //Converts to a 3-slice stack (hue, saturation, brightness)
      run("HSB Stack");
      run("Convert Stack to Images");
      selectWindow("Hue");
      rename("0");
      selectWindow("Saturation");
      rename("1");
      selectWindow("Brightness");
      rename("2");

        min[0]=minHue;
        max[0]=maxHue;
        filter[0]=filterVal;
        min[1]=minSat;
        max[1]=maxSat;
        filter[1]="pass";
        min[2]=minBright;
        max[2]=maxBright;
        filter[2]="pass";

     //applies threshold on the different images
     for (i=0;i<3;i++){
	selectWindow(""+i);
	setThreshold(min[i], max[i]);
	run("Convert to Mask");
  	if (filter[i]=="stop")  run("Invert");
      }
      
      //combines the filtered images
      imageCalculator("AND create", "0","1");
      imageCalculator("AND create", "Result of 0","2");

      //closes all the filtered images
      for (i=0;i<3;i++){
	selectWindow(""+i);
	close();
      }

      //closes the combined image
      selectWindow("Result of 0");
      close();

      //renames the restulting image to the current directory
      selectWindow("Result of Result of 0");
      rename(imageTitle+"_"+color+"_RAND");


       roiManager("Select", 0);
       run("Select All");
       roiManager("Select", newArray       (0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99));
       roiManager("Combine");

      //measures the area of a certain color within the specified selection
      run("Analyze Particles...", "size=0-Infinity circularity=0.00-1.00 show=Nothing summarize");

      //closes all the windows
      selectWindow(imageTitle+"_"+color+"_RAND");
      close();
      selectWindow("Threshold Colour");
      run("Close");

      setBatchMode(false);
      }

} //End Function

} // End Macro
