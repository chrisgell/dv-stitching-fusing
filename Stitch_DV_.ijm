//Macro to stictch a DV-collected panel data set.
//Chris Gell 11-07-2018
//Version 1


//open a series from a .dv file, save them out so sinple Fiji stitching works.
//currently only supports single channels.


//need to do a preload of the data here:


nChannels=getNumber("How manu channels did you record?", 2);

waitForUser("You will now be asked to load the stack.");

run("Bio-Formats Importer", "autoscale color_mode=Default concatenate_series open_all_series rois_import=[ROI manager] split_channels view=Hyperstack stack_order=XYCZT");

waitForUser("Please save out the stacks for each channel to a folder, close them and click OK.");




//get the size of the panel in tiles
xsize=getNumber("Enter the number of columns", 2);
ysize=getNumber("Enter the number of rows", 5);

waitForUser("You'll now be asked to load each of the stacks you just saved in tern, and to choose a location for the tiles to be stored. \n The software will then fuse the tiles and you can then save it.");


for (p=1; p<nChannels; i++) { 


setBatchMode(true); 
open();
run("Stack to Images");



//see if any images are open.
if (nImages<=1) {
	
	Dialog.create("");
	Dialog.addMessage("Too few images open, open at least 2 images.");
	Dialog.show();
	exit; 
}
//where to save everything
dir = getDirectory("Choose a Directory for saving");

 //create an array with a list of open window names
 n = xsize*ysize;

  
    
setBatchMode(true); 
    for (i=1; i<=n; i++) { 
        selectImage(i);
        rename("tile_"+i);
        title = getTitle;
        print("i="+i+" n="+n+" title="+title);
       saveAs("tiff", dir+title);





    }

 setBatchMode(false);


 
 //edit the grid size in this line 
 run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Right & Down                ] grid_size_x="+xsize+" grid_size_y="+ysize+" tile_overlap=1 first_file_index_i=1 directory="+dir+" file_names=tile_{i}.tif output_textfile_name=TileConfiguration.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 computation_parameters=[Save memory (but be slower)] image_output=[Fuse and display]");

 waitForUser("Please save the result, close the image, then click OK and you'll be asked to repeat the previous steps for the other channels.");

}
