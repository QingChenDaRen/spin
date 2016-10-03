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

  data $datafilename
  ignore 0.0-2.52
  ignore 45.0-**
  setplot energy

# Input from Python code
set filename midfile.dat
set midfile [open $filename]
while {[gets $midfile line] >= 0} {

    set splitline [split ${line} " "]
    set M [lindex $splitline 0]
    set inc [lindex $splitline 1]
    set D [lindex $splitline 2]


# TODO: COMMENT FOLLOWING SECTION AND TEST

# Set up the model.
  model none
  model TBabs*constant*simplcomp*(ezdiskbb + relxill)*constant & /*


# Set up parameters
  newpar 1 5.0 0.0
  newpar 2=1.0-7
  newpar 3 2.3 0.05 0.8 0.8 4.0 4.0
  newpar 4 0.05 0.005 0.0 0.0 1.0 1.0
  newpar 5 -1.0 0.0
  newpar 6 100.0 0.01 10.0 10.0 100000 100000
  newpar 7 1.5 0.01 0.5 0.5 4.0 4.0
  newpar 8 300 0.01 0.00000001 0.00000001 10000 10000
  newpar 9=3
  newpar 10=9
  newpar 11 15.0 -0.01
  newpar 12 0.998 -0.01
  newpar 13 ${inc} -0.01
  newpar 14 -1.23 -0.01
  newpar 17=3
  newpar 18 3.1 -0.01
  newpar 19 1.0 -0.01
  newpar 20=abs(p6)
  newpar 21=-5
  newpar 22 1.0 -0.01
  newpar 23 1.0 -0.01
  newpar 24 1.0 -0.01

  freeze 1 5 6 
  energies 0.01 500 400 log
  abund wilm

 
  thaw 14 18 19
  thaw 12
# Fit it to the model.
#  systematic 0.01
  fit 400

# TODO: Set up the puts commands here


# End of while loop
}


#close $chan
#End of proc
}
