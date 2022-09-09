# NETs-quantification
double positive for Cit-H3 and MPO in the Fiji-ImageJ software using one script. 

## Paper
Janssen, Pierre et al. “Neutrophil Extracellular Traps Are Found in Bronchoalveolar Lavage Fluids of Horses With Severe Asthma and Correlate With Asthma Severity.” Frontiers in immunology vol. 13 921077. 13 Jul. 2022, doi:10.3389/fimmu.2022.921077
[link to the paper](https://pubmed.ncbi.nlm.nih.gov/35911691/)

## Description 
Briefly, we defined threshold manually for green and red channels.Then the script replaced each pixel in an image with a black pixel if the image intensity was greater than the defined threshold. The script then produced an image “red inter green”, measured the area of the intersection (i.e., pixels with colocalization) as well as the total number of cells in the picture. Finally, we divided the area of colocalization by the number of cells in the picture to normalize the measurements and we exported the result as a.csv (Comma-separated values) file. 

<img src="https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9326094/bin/fimmu-13-921077-g001.jpg" width="500" title="methods to detect NETs release from blood neutrophils in horses" alt="methods to detect NETs release from blood neutrophils in horses" align="center" vspace = "50">

## Step-by-step tutorial
1. download the script [NET_quantification.ijm](https://github.com/AlexHego/NETs-quantification/blob/main/NET_quantification.ijm)
2. download [imageJ/Fiji](https://imagej.net/software/fiji/downloads)
3. Update ImageJ/Fiji > `Help` > `Update...`
4. Restart ImageJ
5. Drag and drop the script and run it 



