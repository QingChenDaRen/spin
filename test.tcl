proc myfit {datafilename} {
# Return TCL results for XSPEC commands.
set xs_return_result 1

# Keep going until fit converges.
query no

# Go to Data directory
# TODO: SET PATH TO DIRECTORY HERE
cd ..

# Set model number
set mod m98
# Define new models in xspec.init
#load /ciri/astro/xspec_local_libs/XSPEC_DIR64/XKERRBB/libjsxkbb.dylib
load /ciri/astro/xspec_local_libs/XSPEC_DIR64/public_SIMPLCUT/libjscutx.so
#load /ciri/astro/xspec_local_libs/XSPEC_DIR64/RELXILL_v04a_FAST/librelxill.dylib 
#load /ciri/astro/xspec_local_libs/XSPEC_DIR64/RELXILL_v04g/librelxill.so
load /ciri/astro/xspec_local_libs/XSPEC_DIR64/relxill-v0.4j/librelxill.so 


# Set ALPHA value when using kerrbb for disk
set alpha 0.05

# Get the file and set it up for analysis
set y [split $datafilename "."]
set obsname [lindex $y 0].[lindex $y 1].[lindex $y 2]
#set chan [open z_fits_${obsname}_${alpha} a]

# Open parameter file
  set chan [open z_fits_${obsname}_${alpha}_m2h a]

  setplot energy
# Set energies
  energies 0.01 500 400 log

# Set abundances
  abund wilm


  data ${obsname}.pha
  ignore 0.0-2.52
  ignore 45.0-**
  setplot energy



# Set up the model.
  model none
  model TBabs*simplcutx*(kerrbb + relxill)*gabs*smedge & /*

# Set up parameters
  newpar 1 5.0 0.0
  newpar 2 2.3 0.05 0.8 0.8 4.0 4.0
  newpar 3 0.05 0.005 0.0 0.0 1.0 1.0
  newpar 4 -1.0 0.0
  newpar 5 100.0 0.01 10.0 10.0 100000 100000
  newpar 6 0.0 -0.01
  newpar 7 0.7 -0.01
  newpar 8 60.0 -0.01
  newpar 9 12.6 -0.01
  newpar 10 15.0 -0.01
  newpar 11 8.6 -0.01
  newpar 14 1.0 -0.01
  newpar 15 1.0 -0.01


  newpar 16 3.0 -0.01
  newpar 17=16
  newpar 18 15.0 -0.01
  newpar 19=7
  newpar 20=8
  newpar 21 -1.23 -0.01
  newpar 22 400.0 -0.01
  newpar 23 0.0 -0.01
  newpar 24=2
  newpar 25 3.1 -0.01
  newpar 26 1.0 -0.01
  newpar 27=5*0.3     
# Check this Ecut kTe relationship 
  newpar 28=abs(p6)
  newpar 29 1.0 -0.01

  newpar 30 7.0 0.01 6.3 6.3 8.5 8.5
  newpar 31 0.5 -0.01
  newpar 32 1.0 0.01

  newpar 33 8.0 0.01 6.9 6.9 9.0 9.0
  newpar 36 7.0 -0.01

  freeze 1 4 6 7 8 9 10 11 14 15 16 18 21 22 23 25 26 29 31 36

  fit 10
# Set systematics
# systematic 0.01
  thaw 29

  fit 10

  thaw 7
# Run the fit
  fit 1000

#End of proc
}
