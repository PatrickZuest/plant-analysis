macro "color_analysis [8]" {

// ******************************************************
// Script by:						*
// Patrick Zuest, WSL Birmensdorf, Switzerland		*
// patrick.zuest@hotmail.com				*
// ******************************************************


  dir = getDirectory("image");
  imageTitle = getTitle();

  // color analysis for red, blue and white. parameters represent values for color threshold, directory and title of the image
  analyzeColors(40, 189, 40, 255, 40, 255, "stop", dir, imageTitle, "red");
  analyzeColors(125, 189, 40, 255, 120, 255, "pass", dir, imageTitle, "blue");
  analyzeColors(0, 255, 0, 29, 120, 255, "pass", dir, imageTitle, "white");

  saveSummary(dir, imageTitle);

  //saves a xls-file named after the original image
  function saveSummary(dir, imageTitle){
     selectWindow("Summary");
     saveAs("Measurements", dir+imageTitle+".xls");
     run("Close");
     close();
  }

  //does the color analysis for the specified color threshold
  function analyzeColors(minHue, maxHue, minSat, maxSat, minBright, maxBright, filterVal, dir, imageTitle, color){
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
      rename(imageTitle+"_"+color);

      //defines the measurement area which was previously set and saved in the image directory
      if(File.exists(dir+"selection.roi")) {
	open(dir+"selection.roi");
      }

      //measures the area of a certain color within the specified selection
      run("Analyze Particles...", "size=0-Infinity circularity=0.00-1.00 show=Nothing summarize");

      //closes all the windows
      selectWindow(imageTitle+"_"+color);
      close();
      selectWindow("Threshold Colour");
      run("Close");
  }

}
