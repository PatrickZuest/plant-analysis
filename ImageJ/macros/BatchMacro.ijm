macro "run_color_analysis [0]"{
AFileName = getTitle();

runMacro("red");
runMacro("blue");
runMacro("white");

selectWindow("Summary");
   dir = getDirectory("image");
   name = AFileName;
   index = lastIndexOf(name, ".");
   if (index!=-1) name = substring(name, 0, index);
   name = name + ".xls";
   saveAs("Measurements", dir+name);
run("Close");
close();

}
