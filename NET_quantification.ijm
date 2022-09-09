////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////// Imagej macro
////// https://imagej.net/software/fiji/
////// This macro will count the number of nuclei per image, and measure the area of colocalisation Green and Red
////// This macro will run in batch mode and need bio-format (include in FIJI)
////// If you need more informations please contact alexandre.hego@uliege.be
////// Please remove the space in the folder name and file name
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////////////////////
// get directory = where are the files + suffix
#@ File (label = "Input directory", style = "directory") input
#@ Integer (label = "area per nucleus µm²", min=0, max= 1000, value = 100) area_nucleus
#@ String (label = "File suffix", value = ".czi") suffix


// Create a folder to save the results and the quality control
output= input + "/image_tif/";
output2 =  input + "/statistics/";
File.makeDirectory(output);
File.makeDirectory(output2);
//////////////////////////////////////////////////////////////////////////////////////////////////


processFolder(input);
// function to scan folders/subfolders/files to find files with correct suffix
function processFolder(input) {
	list = getFileList(input);
	list = Array.sort(list);
	for (i = 0; i < list.length; i++) {
		if(File.isDirectory(input + File.separator + list[i]))
			processFolder(input + File.separator + list[i]);
		if(endsWith(list[i], suffix))
			processFile(input, output, list[i]);
	}
}

function processFile(input, output, file) {
inputPath = input + File.separator + list[i];
run("Bio-Formats Importer", "open=inputPath color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
imagesName = getTitle();
run("Split Channels");

//Creation cell mask base on DAPI
////////////////////////////////////////////////
selectImage("C3-" + imagesName);
rename(imagesName + "_nuclei");
//filter artefact with median filter
run("Median...", "radius=5");
// set 8 bit because auto local threshold work only with 8 bits images
run("8-bit");
run("Auto Local Threshold", "method=Phansalkar radius=30 parameter_1=0 parameter_2=0 white");
run("Grays");
//Measurements Area of DAPI
///////////////////////////////////////////////////
run("Set Measurements...", "area redirect=None decimal=3");
run("Analyze Particles...", "size=15-Infinity summarize");
/////////////////////////////////////////////////////////////////


// Creation mask Green and Red for colocalisation
//////////////////////////////////////////////////
//Green
selectImage("C2-" + imagesName);
rename("green");
run("Subtract Background...", "rolling=15");
run("Gaussian Blur...", "sigma=2");
//Change here the threshold !!!!!!!!!!!!!!!! MIN only 250
setThreshold(250, 65535);
setOption("BlackBackground", true);
run("Convert to Mask");
// size before 0,4
run("Analyze Particles...", "size=0.4-Infinity show=Masks");
selectImage("Mask of green");
run("Invert LUT");
selectWindow("green");
close();
selectWindow("Mask of green");
rename("green");

//Red
selectImage("C1-" + imagesName);
rename("red");
run("Subtract Background...", "rolling=160");
run("Gaussian Blur...", "sigma=2");
//Change here the threshold !!!!!!!!!!!!!!!! MIN only 225 
setThreshold(400, 65535);
run("Convert to Mask");
// size before 0,4
run("Analyze Particles...", "size=0.4-Infinity show=Masks");
selectImage("Mask of red");
run("Invert LUT");
selectWindow("red");
close();selectWindow("Mask of red");
rename("red");
///////////////////////////////////////////////////////

//creation of a new images Green AND Red
/////////////////////////////////////////////////////
imageCalculator("AND create", "green","red");
selectWindow("Result of green");
rename(imagesName+"_colocalisation");
///////////////////////////////////////////////////

//Measurements Area of colocalisation
///////////////////////////////////////////////////
run("Set Measurements...", "area redirect=None decimal=3");
run("Analyze Particles...", "size=15-Infinity summarize");
/////////////////////////////////////////////////////////////////

// save image for quality control
/////////////////////////////////////////////////////////////
selectImage(imagesName + "_nuclei");
saveAs("Tiff", output + File.separator  +imagesName +"_nuclei" );

selectImage("green");
saveAs("Tiff", output + File.separator  +imagesName +"_green" );

selectImage("red");
saveAs("Tiff", output + File.separator  +imagesName +"_red" );

selectImage(imagesName+"_colocalisation");
saveAs("Tiff", output + File.separator  +imagesName +"_coloc" );
///////////////////////////////////////////////////////////////

// Close images
close("*");
}


// Create a table in .csv and save it
//////////////////////////////////////////////////////////////////////////
selectWindow("Summary");
Table.rename("Summary", "Results");

// create new Array
n = nResults;
slice = newArray(n);
TotalArea = newArray(n);

// get results and clear
for (i=0; i<n; i++) {
	slice[i] = getResultString('Slice', i);
	TotalArea[i] = getResult('Total Area', i);
}
run("Clear Results");

// create a new result table based on Array and save it 
for (i=0; i<n; i++) {
	setResult("Slice", i, slice[i]);
	if (matches(slice[i], ".*nuclei.*")) {
		setResult("count nuclei", i, TotalArea[i]/area_nucleus);}
	else {
	setResult("Area µm2", i, TotalArea[i]);
	}
}
updateResults();
selectWindow("Results"); 
saveAs("Measurements", output2 + File.separator +"Area_measurements.csv");
run("Close");
////////////////////////////////////////////////////////////////////////////////

print("the macro ends");