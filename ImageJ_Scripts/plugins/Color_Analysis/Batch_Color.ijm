macro "Batch_Color [f9]"{

// ******************************************************
// Script by:						*
// Patrick Zuest, WSL Birmensdorf, Switzerland		*
// patrick.zuest@hotmail.com				*
// ******************************************************



  dir = getDirectory("Select Directory"); 
  setBatchMode(true);
  processFiles(dir);


  function processFiles(dir) {

     list = getFileList(dir);
     for (i=0; i<list.length; i++) {
         if (endsWith(list[i], "/"))
             processFiles(""+dir+list[i]);
         else {
             if ((endsWith(list[i], ".JPG"))||(endsWith(list[i], ".jpg"))){
            path = dir+list[i];
            processFile(path);
	}
         }
     }
 }

 function processFile(path) {
          open(path);
	runMacro("color_analysis");
}
}
