
-------------------------------------------------------------------------------
Computer code and simulated data of the study
"Mapping the Paleo Ice-Flow in Larsemann Hills, East Antarctica by UAV Remote Sensing and Terrain Analysis"
-------------------------------------------------------------------------------
This work was improved by Li Yibo from Sun Yat-sen University, 
who modified the fitting formula and added an automatic fitting 
feature to the kriging toolset. These enhancements were integrated to streamline the process 
of fitting variograms and improve the overall performance of the reconstruction method.

This MATLAB code and data 
associated with the numerical method put forward by the original authors, 
Ng, F.S.L. and Hughes, A.L.C., in the following article:

Ng, F.S.L. and Hughes, A.L.C. 
Reconstructing ice-flow fields from streamlined subglacial bedforms: a kriging approach. 
Earth Surface Processes and Landforms. doi: 10.1002/esp.4538.


License for the code: MIT open source license.


-----------------
Quick-start guide
-----------------

Copy all files into a working folder ("home" folder) and create a sub-folder under it called 
"/results". 

Run "process.m" in order to re-run the reconstruction in the case study. 

To process a different flowset, create an input data file "flowset.mat" by following the instructions
in Item (1) below . Then run a modified version of the commands in
"process.m" and its associated functions. See the instructions given in "process.m" and 
Item (3).

The computed outputs of a kriging run are stored in the data file "/results/kriging_results.mat".
See Item (4) for the list and format of output variables in this file.


------------------------------------------------------------------------------------------

(1) INPUT DATA REQUIREMENT AND PREPARATION

For a flowset containing n bedform lineaments, the user prepares input data as a n-by-5 matrix F, 
with the columns 
			[Lineament_ID xstart ystart xend yend] ,

and saves it to a MATLAB data file named "flowset.mat" in the home folder (see the current file
"flowset.mat" in our toolset, for example). Each row of F refers to a lineament; Lineament_ID is its
identification number specified by the user; xstart and ystart denote its start position, and 
xend and yend its end position. All distances/coordinates in our case study are measured in 
kilometres; if a different unit [L] is used (e.g. metre) then all distance/coordinate parameters 
should be in that unit, the computed convergence and curvature have the unit [L]^{-1}. No special
row ordering in F need to be observed. For bedforms whose outlines have been mapped, these need 
to be first converted to lineaments for F to be prepared, or converted to direction data (radian)
to form or be appended to the matrix F1 described below.

To check whether F has been compiled correctly, load it into the MATLAB workspace and type: 
			>> lin_visual(F,'r')
to plot the lineaments.


(2) KRIGING TOOLSET

The toolset consists of the following generic MATLAB functions, which do not need to be changed 
when used to process a given flowset. To learn more about the syntax, input(s) and output(s)
of each "function" listed below, type "help function.m" in the MATLAB workspace.

lin_visual.m		Plot the lineaments in matrix F in map view, in a colour specified by the 
			user. A point is plotted to mark the start position (xstart, ystart) 
			of each lineament.

make_flowdir_matrix.m	Load matrix F from the data file "flowset.mat" and make matrix F1 with the
			3-column structure [ x-midpoint y-midpoint theta ], where theta is in radian.	

find_vg.m  		Compile the experimental vectorial semivariogram (gamma--h data pairs) for 
			the spatial dataset of flow directions contained in the vectors 
			x, y, and theta (radian), using histogram bins whose edges increase from 
 			h = 0 to h = hmax in steps of dh. Both dh and hmax must be specified in
			the same unit as position.
			The user should choose hmax to be large enough so any potential 
			 of the variogram is not missed, and choose dh to 
			be small enough to resolve the profile of the variogram, but not so small 
			to limit the number of samples in each bin (typically, the resulting 
			variogram will look excessively noisy in this case).

krig_pos.m		Use Continuous-Part Kriging (CPK) interpolation to estimate flow direction 
			(theta_k), convergence (C) and curvature (Chi) and associated kriging 
			STDs at the position (x0, y0), using the input data in F1, the kriging 
			range R and the variogram model in "vg_mod.m". If the experimental 
			variogram exhibits a sill, R should be chosen near where the sill begins, 
			beyond the shoulder of the rise. In the absence 
			of a clear sill, R can be chosen as large as possible permitted by computing 
			time constraints.
			krig_pos.m calls the next three functions: krig_sys.m, vg_mod.m, wraptopi.m. 

krig_sys.m		Assemble the kriging system (matrix M and vector b) at position of interest.

vg_mod.m		Evaluate the "LINEAR + GAUSSIAN" variogram model function in Eqns (1) & (2).

wraptopi.m		Wrap an angle (in radian) to the interval [-pi,pi].

krig_domain.m		Given the input data of a flowset, krig-estimate its flow-direction field, 
			convergence field and curvature field across a rectangular domain and at 
			grid resolutions dx and dy specified by the user, and save the outputs to
 
					/results/kriging_results.mat .

			The domain is defined by its edge positions in the vector

					domain = [xmin xmax ymin ymax];
			
			where xmin and xmax are the minimum and maximum limits in the x-direction,
			and ymin and ymax are the minimum and maximum limits in the y-direction.
			A typical choice is set the domain to contain an entire flowset. The output
			fields have the grid dimensions (xmax min)/dx by (ymax min)/dy (or to the
			nearest integers after rounding). Small values of dx and dy lead to a 
			finely-resolved reconstruction, but demand long computation time.

trace_flowlines.m  	Starting from positions defined by mouse clicks, trace a flowline through 
			each position by kriging the flow direction at successive locations in
			both the upstream and downstream directions. Save the results in 
				/results/traced_flowlines_results.mat .

krig_validation.m 	Perform cross-validation on the kriging of flow directions for a flowset.

color_Exchange.m	This function converts RGB color values from the standard 0–255 range to the normalized 0–1 range.
			It is useful for ensuring compatibility with color specifications in 
			many plotting and visualization tools.

------------------------------------------------------------------------------------------
(3) SPECIFIC COMMANDS AND INPUT/COMPUTED DATA OF THE LARSEMANN HILLS CASE STUDY

The following files were used to undertake the "full reconstruction" of the palaeo ice-flow 
field using all direction data from Glacial lineations in the Flowset 
--- To re-run this example, place the file "flowset.mat" 
in the home folder and run "process.m".

To process another flowset, use its input direction data to create a new "flowset.mat" file (Item
(1)) and run a modified version of the commands in "process.m" and its associated functions.


flowset.mat*		Input data file of a flowset. (The given file is for Flowset fs10.) 
			The matrix F has the 5-column structure
				[Lineament_ID x_start y_start x_end y_end]. 
			The matrix F1 has the 3-column structure 
				[ x-midpoint y-midpoint theta ]. 
			Theta is in radian.

process.m		A complete list of commands (including calls to the following three functions)
			to process Flowset fs

compile_variogram_example.m 	
			Commands using "find_vg.m" to compile the Experimental Variogram data for
			Flowset . The example does this at two resolutions:
					(i) dh = 50, hmax = 800
					(ii) dh = 100, hmax = 2000
			in order to (i) resolve the detailed profile of the variogram near the origin
			and (ii) capture its sill.

Model_Autofit.m
			This script is used to automatically fit the variogram model (as described in Equations (5) and (6)) 
            		to the experimental variogram of Flowset The program first prompts the user to 
         		input rough initial estimates for the parameters C0 to C5. Then, using a least-squares algorithm, 
            		it optimizes these parameters to best fit the experimental variogram data. 
            		The script plots both the model curve and the experimental variogram, 
            		allowing the user to visually assess the quality of the fit. 
            		The automatic fitting process ensures that the variogram model parameters 
            		are determined more precisely through iterative optimization.
 
krig_fs_example.m	Kriging of Flowset fs, using the input data matrix F1 in "flowset.mat",
			the kriging range R = 2000 m and the model variogram in "vg_mod.m" (after its
			fitting was done in "Model_Autofit.m"), across the
			rectangular domain [549500 556500 2298640 2304300] at 20-m resolution in both horizontal
			directions.



------------------------------------------------------------------------------------------
(4) FORMAT OF COMPUTED (OUTPUT) DATA IN THE FILE "/results/kriging_results.mat"

Variables:

domain		rectangular domain (specified by the user) for computing the spatial fields, in 
			the format [xmin xmax ymin ymax]
dx		grid spacing of the domain in x-direction (specified by the user)
dy		grid spacing of the domain in y-direction (specified by the user)
gx		x-axis of the gridded domain
gy		y-axis of the gridden domain
R		the kriging range used (chosen by user based on the experimental variogram)
vg_params	the model-variogram parameters used, in the vector format [C0 C1 C2 C3 C4 C5]
theta		the field of krige-estimated palaeo flow direction (radian)
thetas		the field of approximate kriging standard deviation error estimate on theta 
C		the field of krige-estimated palaeo ice-flow convergence
Cs		the field of kriging standard deviation error estimate on C 
Chi		the field of krige-estimated palaeo ice-flow curvature
Chis		the field of kriging standard deviation error estimate on Chi 
N		the number of input observations used (i.e. those inside kriging range) at each kriging location
F		input data matrix, with the column structure [Lineament_ID x_start y_start x_end y_end]
			(see above)
F1		processed input data matrix, with the column structure [ x-midpoint y-midpoint theta ]
			(see above)

Note: If the user-specified position and distance variables (dx, dy, domain, R, x_start, y_start, etc.)
	are in kilometre, then the computed convergence and curvature have the unit "m^{-1}").

------------------------------------------------------------------------------------------

