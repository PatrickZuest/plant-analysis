macro "selection [f4]"{

// ******************************************************
// Script by:						*
// Patrick Zuest, WSL Birmensdorf, Switzerland		*
// patrick.zuest@hotmail.com				*
// ******************************************************



//macro checks whether there is already an existing selection.
//if yes: the selection is shown
//if no: the user is able to make a selection and save it in the image folder

dir = getDirectory("image");

if(File.exists(dir+"selection.roi")) {
	open(dir+"selection.roi");
}

waitForUser( "Pause","Make your Selection and click OK when you are finished."); 

run("Measure");
if(getResult("Area", 0)==getWidth()*getHeight()){
	//there was no selection made, the whole image is selected
	selectWindow("Results");
	run("Close");
	run("Select All");
	}

else{
	selectWindow("Results");
	run("Close");
	}

//save selection in the directory of the image
saveAs("Selection", dir+"selection.roi");
close();
}
