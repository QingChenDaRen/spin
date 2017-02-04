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
#load /Users/charith/Documents/xrayspectralanalysis/software/xspec_local_models/simplcomp/libsimplcomp.dylib
#load /Users/charith/Documents/xrayspectralanalysis/software/xspec_local_models/relxill/librelxill.dylib
#load ~/Documents/xrayspectralanalysis/software/xspec_local_models/simplcutx/libjscutx.dylib

load /ciri/astro/xspec_local_libs/XSPEC_DIR64/public_SIMPLCUT/libjscutx.so
load /ciri/astro/xspec_local_libs/XSPEC_DIR64/relxill-v0.4j/librelxill.so

# Set ALPHA value when using kerrbb for disk
set alpha 0.05

# Get the file and set it up for analysis
set y [split $datafilename "."]
set obsname [lindex $y 0].[lindex $y 1].[lindex $y 2]
#set chan [open z_fits_${obsname}_${alpha} a]

# Open parameter file
  set chan [open z_fits_${obsname}_${alpha}_m2l a]

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

### MAIN LOOP ###

# Input sorted M,i,D from Python code
  set filename MiD_mid_to_small_test.dat
  set midfile [open $filename]
  while {[gets $midfile line] >= 0} {

    set splitline [split ${line} " "]
    set M [lindex $splitline 0]
    set inc [lindex $splitline 1]
    set D [lindex $splitline 2]

# Change mass, inclination and distance to new values
# Use all other values from previous fit

  newpar 8 ${inc}
  newpar 9 ${M}
  newpar 11 ${D}

  freeze 1 4 6 7 8 9 10 11 14 15 16 18 21 22 23 25 26 29 31 36

  fit 10
# Set systematics
# systematic 0.01
  thaw 29

  fit 10

  thaw 7
# Run the fit
  fit 1000

# Save the .xcm file
  save all ${obsname}_${M}_${inc}_${D}_m2l.xcm

# Parameters

  tclout stat
  scan $xspec_tclout "%f" mychi

  tclout dof
  scan $xspec_tclout "%d" mydof

  tclout param 1
  scan $xspec_tclout "%f" par1
  tclout param 2
  scan $xspec_tclout "%f" par2
  tclout param 3
  scan $xspec_tclout "%f" par3
  tclout param 4
  scan $xspec_tclout "%f" par4
  tclout param 5
  scan $xspec_tclout "%f" par5
  tclout param 6
  scan $xspec_tclout "%f" par6
  tclout param 7
  scan $xspec_tclout "%f" par7
  tclout param 8
  scan $xspec_tclout "%f" par8
  tclout param 9
  scan $xspec_tclout "%f" par9
  tclout param 10
  scan $xspec_tclout "%f" par10
  tclout param 11
  scan $xspec_tclout "%f" par11
  tclout param 12
  scan $xspec_tclout "%f" par12
  tclout param 13
  scan $xspec_tclout "%f" par13
  tclout param 14
  scan $xspec_tclout "%f" par14
  tclout param 15
  scan $xspec_tclout "%f" par15
  tclout param 16
  scan $xspec_tclout "%f" par16
  tclout param 17
  scan $xspec_tclout "%f" par17
  tclout param 18
  scan $xspec_tclout "%f" par18
  tclout param 19
  scan $xspec_tclout "%f" par19
  tclout param 20
  scan $xspec_tclout "%f" par20
  tclout param 21
  scan $xspec_tclout "%f" par21
  tclout param 22
  scan $xspec_tclout "%f" par22
  tclout param 23
  scan $xspec_tclout "%f" par23
  tclout param 24
  scan $xspec_tclout "%f" par24
  tclout param 25
  scan $xspec_tclout "%f" par25
  tclout param 26
  scan $xspec_tclout "%f" par26
  tclout param 27
  scan $xspec_tclout "%f" par27
  tclout param 28
  scan $xspec_tclout "%f" par28
  tclout param 29
  scan $xspec_tclout "%f" par29
  tclout param 30
  scan $xspec_tclout "%f" par30
  tclout param 31
  scan $xspec_tclout "%f" par31
  tclout param 32
  scan $xspec_tclout "%f" par32
  tclout param 33
  scan $xspec_tclout "%f" par33
  tclout param 34
  scan $xspec_tclout "%f" par34
  tclout param 35
  scan $xspec_tclout "%f" par35
  tclout param 36
  scan $xspec_tclout "%f" par36


#Output line
puts $chan "$obsname \t$mychi \t$mydof  \t${M} \t${inc} \t${D} \t$par1 \t$par2 \t$par3 \t$par4 \t$par5 \t$par6 \t$par7 \t$par8 \t$par9 \t$par10 \t$par11 \t$par12 \t$par13 \t$par14 \t$par15 \t$par16 \t$par17 \t$par18 \t$par19 \t$par20 \t$par21 \t$par22 \t$par23 \t$par24 \t$par25 \t$par26 \t$par27 \t$par28 \t$par29 \t$par30 \t$par31 \t$par32 \t$par33 \t$par34 \t$par35 \t$par36"

# End of while loop
}


close $chan
#End of proc
}
