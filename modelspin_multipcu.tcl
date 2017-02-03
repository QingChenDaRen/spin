proc myfit {datafilename pculist} {
# Return TCL results for XSPEC commands.
  set xs_return_result 1

# Keep going until fit converges.
  query no

# Go to Data directory
# TODO: SET PATH TO DIRECTORY HERE
  cd ..

# Set model name for filenaming
  set mod m98

# Define new models in xspec.init
  load /Users/charith/Documents/xrayspectralanalysis/software/xspec_local_models/simplcomp/libsimplcomp.dylib
  load /Users/charith/Documents/xrayspectralanalysis/software/xspec_local_models/relxill/librelxill.dylib
  load ~/Documents/xrayspectralanalysis/software/xspec_local_models/simplcutx/libjscutx.dylib

# Set ALPHA value when using kerrbb for disk
  set alpha 0.05

# Get the file and set it up for analysis
  set y [split $datafilename "."]
  set obsname [lindex $y 0].[lindex $y 1]

# Open parameter file
  set chan [open z_fits_${obsname}_${alpha} a]

  setplot energy
# Set energies
  energies 0.01 500 400 log

# Set abundances
  abund wilm

# Data input from observation with multiple PCUs
  set m 1
  foreach i $pculist {

  data $m:$m ${obsname}.${i}.pha;
  ignore $m: 0.0-2.52;
  ignore $m: 45.0-**;
  incr m

  }

# Set up the model.
  model none
  model TBabs*constant*simplcutx*(ezdiskbb + relxill)*constant & /*

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
  newpar 13 60.0 -0.01   
  newpar 14 -1.23 -0.01
  newpar 17=3
  newpar 18 3.1 -0.01
  newpar 19 1.0 -0.01
  newpar 20=abs(p6)
  newpar 21=-5
  newpar 22 1.0 -0.01
  newpar 23 1.0 -0.01
  newpar 24 1.0 -0.01


# Set Normalization constants for PCUs. Normalized to PCU2.
  set p 1
  foreach j $pculist {
  newpar [expr {24 * $p}] 1.0 0.01
    if $j==2 {
    newpar [expr {24 * $p}] 1.0 -0.01
    }
  incr p  
  }


### MAIN LOOP ###

# Input sorted M,i,D from Python code
  set filename midfile.dat
  set midfile [open $filename]
  while {[gets $midfile line] >= 0} {

    set splitline [split ${line} " "]
    set M [lindex $splitline 0]
    set inc [lindex $splitline 1]
    set D [lindex $splitline 2]

# Change mass, inclination and distance to new values
# Use all other values from previous fit

  newpar 13 ${inc} -0.01

  freeze 1 5 6
  thaw 14 18 19
  thaw 12

# Set systematics
# systematic 0.01

# Run the fit
  fit 10

# Save the .xcm file
  save all ${obsname}_${M}_${inc}_${D}.xcm
  
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

#Output line
puts $chan "$obsname \t$mychi \t$mydof  \t${M} \t${inc} \t${D} \t$par1 \t$par2 \t$par3 \t$par4 \t$par5 \t$par6 \t$par7 \t$par8 \t$par9 \t$par10 \t$par11 \t$par12 \t$par13 \t$par14 \t$par15 \t$par16 \t$par17 \t$par18 \t$par19 \t$par20 \t$par21 \t$par22 \t$par23 \t$par24"

# End of while loop
}

# Close the parameter file
  close $chan

# End of proc
}
