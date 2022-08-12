# NETs-quantification
double positive for Cit-H3 and MPO in the Fiji-ImageJ software using one script. 

Briefly, we defined threshold manually for green and red channels.Then the script replaced each pixel in an image with a black pixel if the image intensity was greater than the defined threshold. The script then produced an image “red inter green”, measured the area of the intersection (i.e., pixels with colocalization) as well as the total number of cells in the picture. Finally, we divided the area of colocalization by the number of cells in the picture to normalize the measurements and we exported the result as a.csv (Comma-separated values) file. 
