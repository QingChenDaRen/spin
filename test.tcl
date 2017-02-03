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
#load /Users/charith/Documents/xrayspectralanalysis/software/xspec_local_models/simplcut/libsimplcut.dylib
load /Users/charith/Documents/xrayspectralanalysis/software/xspec_local_models/simplcomp/libsimplcomp.dylib
load /Users/charith/Documents/xrayspectralanalysis/software/xspec_local_models/relxill/librelxill.dylib
load ~/Documents/xrayspectralanalysis/software/xspec_local_models/simplcutx/libjscutx.dylib

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
  model TBabs*simplcutx*(ezdiskbb + relxill)*gabs*smedge & /*

# Set up parameters
  newpar 1 5.0 0.0
  newpar 2 2.3 0.05 0.8 0.8 4.0 4.0
  newpar 3 0.05 0.005 0.0 0.0 1.0 1.0
  newpar 4 -1.0 0.0
  newpar 5 100.0 0.01 10.0 10.0 100000 100000
  newpar 6 1.5 0.01 0.5 0.5 4.0 4.0
  newpar 7 300 0.01 0.00000001 0.00000001 10000 10000
  newpar 8=3
  newpar 9=8
  newpar 10 15.0 -0.01
  newpar 11 0.998 -0.01
  newpar 12 60.0 -0.01
  newpar 13 -1.23 -0.01
  newpar 17 3.1 -0.01
  newpar 18 1.0 -0.01
  newpar 19=abs(p6)
  newpar 20=-4
  newpar 21 1.0 -0.01
  newpar 22 1.0 -0.01
  newpar 23 7.0 0.01 6.3 6.3 8.5 8.5
  newpar 24 0.5 -0.01
  newpar 25 1.0 0.01
  newpar 26 8.0 0.01 6.9 6.9 9.0 9.0
  newpar 29 7.0 -0.01

  freeze 1 4 10 11 12 13 17 18 21 22 24 29

# Set systematics
# systematic 0.01

# Run the fit
  fit 1000

#End of proc
}
