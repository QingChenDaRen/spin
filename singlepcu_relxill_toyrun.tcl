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

load /ciri/astro/xspec_local_libs/XSPEC_DIR64/public_SIMPLCUT/libjscutx.so
load /ciri/astro/xspec_local_libs/XSPEC_DIR64/relxill-v0.4j-hack/librelxill.so
load /ciri/astro/xspec_local_libs/XSPEC_DIR64/XKERRBB/libjsxkbb.so

# Copy the xftab2.dat file into Working Directory (overwrite if it exists)
cp /ciri/astro/xspec_local_libs/XSPEC_DIR64/XKERRBB/xftab2.dat .


# Set ALPHA value when using kerrbb for disk
set alpha 0.01

# Get the file and set it up for analysis
set y [split $datafilename "."]
set obsname [lindex $y 0].[lindex $y 1].[lindex $y 2]
#set chan [open z_fits_${obsname}_${alpha} a]

# Open parameter file
  set chan [open z_fits_${obsname}_${alpha}_toy a]

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
  model TBabs*simplcutx*(xkbb + relxill) & /*

# Set up parameters

# Tbabs
  newpar 1 6.0 -0.01
#simplcutx
  newpar 2 2.5 0.05 0.8 0.8 4.0 4.0
  newpar 3 0.1 0.005 0.0 0.0 1.0 1.0
  newpar 4 1.0 -0.01
  newpar 5 -15.0 0.01 -10.0 -10.0 -100000 -100000
#xkbb
  newpar 6 0.0 -0.01
  newpar 7 0.8 -0.01
  newpar 10 1.5 -0.01
  newpar 14 -1.0 -0.01
  newpar 15 ${alpha} -0.01
  newpar 16=1
  newpar 18 1.0 -0.01
#relxill
  newpar 19 3.0 -0.01
  newpar 20=19
  newpar 21 1.0 -0.01
# Break radius is not used since Ind1=Ind2
  newpar 22=7
  newpar 23=8
  newpar 24 -1.0 -0.01
  newpar 25 400.0 -0.01
  newpar 26 0.0 -0.01
  newpar 27=2
  newpar 28 3.5 -0.01
  newpar 29 2.0 -0.01
  newpar 30=abs(5)
# Check this Ecut kTe relationship 
  newpar 31 -1.0 -0.01
  newpar 32 1.0 -0.01


# refl_frac relationship
  newpar 4=abs(31)
# for later use



### MAIN LOOP ###

# Input sorted M,i,D from Python code
#  set filename MiD_mid_to_small_test.dat
#  set midfile [open $filename]
#  while {[gets $midfile line] >= 0} {
#
#    set splitline [split ${line} " "]
#    set M [lindex $splitline 0]
#    set inc [lindex $splitline 1]
#    set D [lindex $splitline 2]

  set M 12.4
  set inc 60.0
  set D 8.6


# Change mass, inclination and distance to new values
# Use all other values from previous fit

  newpar 8 ${inc} -0.01
  newpar 9 ${M} -0.01
  newpar 11 ${D} -0.01

# thawed at start - refl_frac, a*, m_dot

  freeze 1 2 3 5 6 8 9 11 18 19 21 28 29 32
 
# Set systematics
# systematic 0.01
  thaw 7 10
  fit 1
  thaw 2 3
  thaw 5 28 29 31
  fit 1
  thaw 19
  fit 1

  thaw 7
# Run the fit
  fit 3

# Save the .xcm file
  save all ${obsname}_${alpha}_toy.xcm

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

set COMMENTED_OUT {
  tclout param 33
  scan $xspec_tclout "%f" par33
  tclout param 34
  scan $xspec_tclout "%f" par34
  tclout param 35
  scan $xspec_tclout "%f" par35
  tclout param 36
  scan $xspec_tclout "%f" par36

}

#Output line
puts $chan "$obsname \t$mychi \t$mydof  \t${M} \t${inc} \t${D} \t$par1 \t$par2 \t$par3 \t$par4 \t$par5 \t$par6 \t$par7 \t$par8 \t$par9 \t$par10 \t$par11 \t$par12 \t$par13 \t$par14 \t$par15 \t$par16 \t$par17 \t$par18 \t$par19 \t$par20 \t$par21 \t$par22 \t$par23 \t$par24 \t$par25 \t$par26 \t$par27 \t$par28 \t$par29 \t$par30 \t$par31 \t$par32"


# End of while loop
#}


close $chan
#End of proc
}
