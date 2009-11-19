!> \file config.F90

!> \brief the module that handles the config file
!<
module config_mod
use myf90_mod
use global_mod, only: GV


contains


!> reads the config file 
!==============================
subroutine read_config_file(config_file)

  character(clen), intent(in) :: config_file  !< file to read config vars from
  character(clen) :: keyword
  character(clen) :: str
  logical :: file_exists

  character(clen), parameter :: myname="read_config_file"
  logical, parameter :: crash = .true.

    write(str,'(A,A)') ' using configuration file: ', trim(config_file)
    call mywrite(str,verb=0,fmt='(A,T29,A)') 

    inquire( file=config_file, exist=file_exists )
    if (.not. file_exists) then
       call myerr("config file does not exist",myname,crash)
    end if


    keyword = "Verbosity:"
    call scanfile(config_file,keyword,GV%Verbosity)
    myf90_verbosity = GV%verbosity

    keyword = "DoTestScenario:"
    call scanfile(config_file,keyword,GV%DoTestScenario)

    keyword = "TestScenario:"
    call scanfile(config_file,keyword,GV%TestScenario)
!-----------------------

    keyword = "JustInit:"
    call scanfile(config_file,keyword,GV%JustInit)

    keyword = "Comoving:"
    call scanfile(config_file,keyword,GV%Comoving)

    keyword = "IsoTemp:"
    call scanfile(config_file,keyword,GV%IsoTemp)

    keyword = "FixSnapTemp:"
    call scanfile(config_file,keyword,GV%FixSnapTemp)

    keyword = "IntSeed:"
    call scanfile(config_file,keyword,GV%IntSeed)

    keyword = "StaticFieldSimTime:"
    call scanfile(config_file,keyword,GV%StaticFieldSimTime)

    keyword = "StaticSimTimeUnit:"
    call scanfile(config_file,keyword,GV%StaticSimTimeUnit)    

    !   input snapshot information
    !------------------------------
    keyword = "InputType:"
    call scanfile(config_file,keyword,GV%InputType)

    keyword = "SnapPath:"
    call scanfile(config_file,keyword,GV%SnapPath)

    keyword = "SourcePath:"
    call scanfile(config_file,keyword,GV%SourcePath)

    keyword = "SpectraFile:"
    call scanfile(config_file,keyword,GV%SpectraFile)

    keyword = "b2cdFile:"
    call scanfile(config_file,keyword,GV%b2cdFile)

    keyword = "AtomicRatesFile:"
    call scanfile(config_file,keyword,GV%AtomicRatesFile)

    keyword = "ParFileBase:"
    call scanfile(config_file,keyword,GV%ParFileBase)

    keyword = "SourceFileBase:"
    call scanfile(config_file,keyword,GV%SourceFileBase)

    keyword = "StartSnapNum:"
    call scanfile(config_file,keyword,GV%StartSnapNum)

    keyword = "EndSnapNum:"
    call scanfile(config_file,keyword,GV%EndSnapNum)

    keyword = "ParFilesPerSnap:"
    call scanfile(config_file,keyword,GV%ParFilesPerSnap)

    keyword = "SourceFilesPerSnap:"
    call scanfile(config_file,keyword,GV%SourceFilesPerSnap)


    !   ray tracing
    !----------------------------
    keyword = "RayScheme:"
    call scanfile(config_file,keyword,GV%RayScheme)

    keyword = "ForcedRayNumber:"
    call scanfile(config_file,keyword,GV%ForcedRayNumber)
 
    keyword = "RayStats:"
    call scanfile(config_file,keyword,GV%RayStats)

    keyword = "BndryCond:"
    call scanfile(config_file,keyword,GV%BndryCond)

    keyword = "RecRayTol:"
    call scanfile(config_file,keyword,GV%RecRayTol)

    keyword = "RayPhotonTol:"
    call scanfile(config_file,keyword,GV%RayPhotonTol)


    !   ion/temp solving
    !----------------------------
    keyword = "OnTheSpotH:"
    call scanfile(config_file,keyword,GV%OnTheSpotH)

    keyword = "OnTheSpotHe:"
    call scanfile(config_file,keyword,GV%OnTheSpotHe)

    keyword = "HydrogenCaseA:"
    call scanfile(config_file,keyword,GV%HydrogenCaseA)

    keyword = "HeliumCaseA:"
    call scanfile(config_file,keyword,GV%HeliumCaseA)

    keyword = "IonTempSolver:"
    call scanfile(config_file,keyword,GV%IonTempSolver)

    keyword = "Tfloor:"
    call scanfile(config_file,keyword,GV%Tfloor)

    keyword = "Tceiling:"
    call scanfile(config_file,keyword,GV%Tceiling)

    keyword = "xfloor:"
    call scanfile(config_file,keyword,GV%xfloor)

    keyword = "xceiling:"
    call scanfile(config_file,keyword,GV%xceiling)

    keyword = "NeBackGround:"
    call scanfile(config_file,keyword,GV%NeBackGround)

    keyword = "UpdateAllRays:"
    call scanfile(config_file,keyword,GV%UpdateAllRays)

    keyword = "RecRaysPerSrcRay:"
    call scanfile(config_file,keyword,GV%RecRaysPerSrcRay)

    keyword = "H_mf:"
    call scanfile(config_file,keyword,GV%H_mf)

    keyword = "He_mf:"
    call scanfile(config_file,keyword,GV%He_mf)

    !   output
    !-------------
    keyword = "OutputDir:"
    call scanfile(config_file,keyword,GV%OutputDir)

    keyword = "OutputFileBase:"
    call scanfile(config_file,keyword,GV%OutputFileBase)

    keyword = "OutputType:"
    call scanfile(config_file,keyword,GV%OutputType)

    keyword = "OutputTiming:"
    call scanfile(config_file,keyword,GV%OutputTiming)

    keyword = "NumStdOuts:"
    call scanfile(config_file,keyword,GV%NumStdOuts)

    keyword = "DoInitialOutput:"
    call scanfile(config_file,keyword,GV%DoInitialOutput)

    keyword = "IonFracOutRays:"
    call scanfile(config_file,keyword,GV%IonFracOutRays)

    keyword = "ForcedOutFile:"
    call scanfile(config_file,keyword,GV%ForcedOutFile)

    keyword = "ForcedUnits:"
    call scanfile(config_file,keyword,GV%ForcedUnits)
 
!--------------------
    keyword = "PartPerCell:"
    call scanfile(config_file,keyword,GV%PartPerCell)


    GV%config_file = config_file

    call dummy_check_config_variables()
    call config_info_to_file()

end subroutine read_config_file


!> run dummy checks on config variables
!========================================
subroutine dummy_check_config_variables()

  character(clen) :: Cwarning, Mwarning
  logical :: config_good
  logical :: charmatch

  Cwarning = "please edit " // trim(GV%config_file)
  Mwarning = "please edit Makefile"
  config_good = .true. 

  if (GV%InputType /= 1 .and. GV%InputType /= 2 .and. GV%InputType /= 3) then
     write(*,*) "Input Type ", GV%InputType, " not recognized"
     write(*,*) "must be 1 (Sphray), 2 (Gadget Public), or 3 (Gadget Tiziana)"
     config_good = .false. 
  end if

  if (GV%OutputType /= 1 .and. GV%OutputType /= 2) then
     write(*,*) "Input Type ", GV%OutputType, " not recognized"
     write(*,*) "must be 1 (Standard Gadget) or 2 (HDF5 Gadget)"
     config_good = .false. 
  end if


  if (GV%Tfloor < 0.0 .or. GV%Tceiling < 0.0) then
     write(*,*) "Tfloor and Tceiling must be greater than or equal to 0.0"
     config_good = .false. 
  end if

  if (GV%Tfloor > 1.0e9 .or. GV%Tceiling > 1.0e9) then
     write(*,*) "Tfloor and Tceiling must be less than or equal to 1.0e9"
     config_good = .false. 
  end if

  if (GV%Tfloor > GV%Tceiling) then
     write(*,*) "Tceiling must be greater than Tfloor"
     config_good = .false. 
  end if

  if (GV%IsoTemp > 0.0) then
  
     if (GV%IsoTemp < GV%Tfloor) then
        write(*,*) "IsoTemp cannot be set lower than Tfloor"
        config_good = .false. 
     end if
     
     if (GV%IsoTemp > GV%Tceiling) then
        write(*,*) "IsoTemp cannot be set higher than Tceiling"
        config_good = .false. 
     end if

  end if

  if (GV%StartSnapNum < 0 .or. GV%EndSnapNum < 0) then
     write(*,*) "Starting and Ending snapshot numbers must be > 0"
     config_good = .false. 
  end if

  if (GV%StartSnapNum > GV%EndSnapNum) then
     write(*,*) "Starting snapshot number cannot be > Ending snapshot number"
     config_good = .false. 
  end if


  if ( GV%IonTempSolver /= 1 .and. GV%IonTempSolver /= 2) then
     config_good = .false.
     write(*,*) "IonTempSolver: ", GV%IonTempSolver, " not recognized"
     write(*,*) "must be '1'=euler or '2'=bdf "
  end if


  charmatch = .false.
  if ( trim(GV%StaticSimTimeUnit) == "codetime" ) charmatch = .true.
  if ( trim(GV%StaticSimTimeUnit) == "myr"      ) charmatch = .true.
  if (.not. charmatch) then
     write(*,*) "StaticSimTimeUnit: ", trim(GV%StaticSimTimeUnit), " not recognized"
     write(*,*) "must be 'codetime' or 'myr' "
     config_good = .false.
  end if

  charmatch = .false.
  if ( trim(GV%RayScheme) == "raynum" ) charmatch = .true.
  if ( trim(GV%RayScheme) == "header"   ) charmatch = .true.
  if (.not. charmatch) then
     write(*,*) "RayScheme: ", trim(GV%RayScheme), " not recognized"
     write(*,*) "must be 'raynum' or 'header' "
     config_good = .false.
  end if

  charmatch = .false.
  if ( trim(GV%OutputTiming) == "standard" ) charmatch = .true.
  if ( trim(GV%OutputTiming) == "forced"   ) charmatch = .true.
  if (.not. charmatch) then
     write(*,*) "OutputTiming: ", trim(GV%OutputTiming), " not recognized"
     write(*,*) "must be 'standard' or 'forced' "
     config_good = .false.
  end if

  charmatch = .false.
  if ( trim(GV%ForcedUnits) == "codetime" ) charmatch = .true.
  if ( trim(GV%ForcedUnits) == "myr"      ) charmatch = .true.
  if ( trim(GV%ForcedUnits) == "mwionfrac") charmatch = .true.
  if (.not. charmatch) then
     write(*,*) "ForcedUnits: ", trim(GV%ForcedUnits), " not recognized"
     write(*,*) "must be 'codetime', 'myr', or 'mwionfrac' "
     config_good = .false.
  end if

#ifdef incHe
  if (GV%He_mf == 0.0) then
     write(*,*) "You have defined the incHe macro in the Makefile, but"
     write(*,*) "the Helium mass fraction is set to 0.0 in the config file."
     write(*,*) "Please comment out incHe in the Makefile or set the Helium"
     write(*,*) "mass fraction to something greater than zero in the config file."
     config_good = .false.
  end if
#else
  if (GV%He_mf /= 0.0) then
     write(*,*) "You have not defined the incHe macro in the Makefile, but"
     write(*,*) "the Helium mass fraction is non-zero in the config file."
     write(*,*) "Please uncomment the incHe line in the Makefile or set the"
     write(*,*) "Helium mass fraction to zero in the config file."
     config_good = .false.
  end if
#endif




  if (GV%DoTestScenario) then  
     charmatch = .false.

     if ( trim(GV%TestScenario) == "iliev_test1" ) then
        charmatch = .true.
        if (GV%IsoTemp /= 1.0d4) then
           config_good = .false.
           write(*,*) "iliev test 1 must have IsoTemp = 1.0e4"
        end if
     end if

     if ( trim(GV%TestScenario) == "iliev_test1He" ) then
        charmatch = .true.
        if (GV%IsoTemp /= 1.0d4) then
           config_good = .false.
           write(*,*) "iliev test 1 He must have IsoTemp = 1.0e4"
        end if
     end if

     if ( trim(GV%TestScenario) == "iliev_test2" ) then
        charmatch = .true.
        if (GV%IsoTemp /= 0.0) then
           config_good = .false.
           write(*,*) "iliev test 2 must have IsoTemp = 0.0"
        end if
     end if

     if ( trim(GV%TestScenario) == "iliev_test3" ) then
        charmatch = .true.
        if (GV%IsoTemp /= 0.0) then
           config_good = .false.
           write(*,*) "iliev test 3 must have IsoTemp = 0.0"
        end if
     end if

     if ( trim(GV%TestScenario) == "iliev_test4" ) then
        charmatch = .true.
        if (GV%IsoTemp /= 0.0) then
           config_good = .false.
           write(*,*) "iliev test 4 must have IsoTemp = 0.0"
        end if
     end if


     if (.not. charmatch) then
        write(*,*) "TestScenario: ", trim(GV%TestScenario), " not recognized"
        write(*,*) "must be 'iliev_test1(He)', 'iliev_test2', 'iliev_test3' or 'iliev_test4' "
        config_good = .false.
     end if
  end if

  if (.not. config_good) then
     write(*,*) Cwarning
     stop
  end if


end subroutine dummy_check_config_variables




!> writes the configuration file information to the output directory
!====================================================================
subroutine config_info_to_file()

  character(200) :: config_log_file
  integer(i8b) :: lun

  config_log_file = trim(GV%OutputDir) // "/config_values_used.log"
  
  call open_formatted_file_w(config_log_file,lun)

  105 format(T2,A,I3.3)
  111 format(T2,A,I10)
  120 format(T2,A,ES10.3)

  write(lun,*)"============================================"
  write(lun,*)"The SPHRAY configuration file has been read "
  write(lun,*)"The SPHRAY configuration file variables are "
  write(lun,*)"============================================"
  write(lun,*)"Verbosity " , GV%Verbosity
  write(lun,*)
  write(lun,*)"Do a test scenario? " , GV%DoTestScenario
  write(lun,*)
  write(lun,*)"Which test scenario? " , trim(GV%TestScenario)
  write(lun,*)
  write(lun,*)"Just initialize? " , GV%JustInit
  write(lun,*)
  write(lun,*)"Input is in comoving coords? " , GV%Comoving
  write(lun,*)
  write(lun,*)"Iso temperature (0.0 = variable temperature): ", GV%IsoTemp
  write(lun,*) 
  write(lun,*)"Fix temperature at snapshot values?: ", GV%FixSnapTemp
  write(lun,*) 
  write(lun,*)"Integer Seed for RNG ", GV%IntSeed
  write(lun,*) 
  write(lun,*)"Static field simulation time: ", GV%StaticFieldSimTime
  write(lun,*) 
  write(lun,*)"Static field time unit: ", trim(GV%StaticSimTimeUnit)
  write(lun,*) 

  write(lun,*)

  write(lun,*)"Input Type (1=Sphray, 2=Gadget Public, 3=Gadget Tiziana)", GV%InputType
  write(lun,*)
  write(lun,*)"Path to Snapshot File(s):"
  write(lun,*)trim(GV%SnapPath)
  write(lun,*)
  write(lun,*)"Path to Source File(s):"
  write(lun,*)trim(GV%SourcePath)
  write(lun,*) 
  write(lun,*)"Path to the Spectra file:"
  write(lun,*)trim(GV%SpectraFile)
  write(lun,*) 
  write(lun,*)"Path to the impact parameter -> column depth file:"
  write(lun,*)trim(GV%b2cdFile)
  write(lun,*) 
  write(lun,*)"Path to the atomic rates file:"
  write(lun,*)trim(GV%AtomicRatesFile)

  write(lun,*)
  write(lun,*)"Particle file base: ", trim(GV%ParFileBase)
  write(lun,*)"Source file base:   ", trim(GV%SourceFileBase)
  write(lun,*)
  write(lun,"(A,I3.3)") "Starting snapshot number:", GV%StartSnapNum
  write(lun,"(A,I3.3)") "Ending snapshot number:  ", GV%EndSnapNum
  write(lun,"(A,I3)") "Par Files per snapshot:    ", GV%ParFilesPerSnap
  write(lun,"(A,I10)") "Source Files per snapshot:", GV%SourceFilesPerSnap

  write(lun,*)
  write(lun,*)
  write(lun,*)  "Ray Scheme : ", trim(GV%RayScheme)
  write(lun,120) "Forced Ray Number : ", real(GV%ForcedRayNumber)

  write(lun,*) "Report ray statistics in raystats.dat?", GV%RayStats

  if(GV%BndryCond==-1) then
  write(lun,*)  "Boundry Conditions : ", "reflecting"
  else if(GV%BndryCond==0) then
  write(lun,*)  "Boundry Conditions : ", "vacuum"
  else if(GV%BndryCond==1) then  
  write(lun,*)  "Boundry Conditions : ", "periodic"
  end if

  write(lun,*)  "Rec Ray Frac Tol   : ", GV%RecRayTol
  write(lun,*)  "Ray Photon Tol     : ", GV%RayPhotonTol

  write(lun,*)  "Use On The Spot for Hydrogen? : ", GV%OnTheSpotH
  write(lun,*)  "Use On The Spot for Helium?   : ", GV%OnTheSpotHe

  write(lun,*)  "Use Case A recombination rates for Hydrogen? :", GV%HydrogenCaseA
  write(lun,*)  "Use Case A recombination rates for Helium?   :", GV%HeliumCaseA

  write(lun,*)  "Ionization and temperature solver :", GV%IonTempSolver

  write(lun,*)  "Temperature floor   : ", GV%Tfloor
  write(lun,*)  "Temperature ceiling : ", GV%Tceiling
  write(lun,*)  "Ionization floor    : ", GV%xfloor
  write(lun,*)  "Ionization ceiling  : ", GV%xceiling


  write(lun,*)  "ne background      : ", GV%NeBackGround
  write(lun,*)  "Rays between all particle update:  ", GV%UpdateAllRays
  write(lun,*)  "Recomb ray / src ray: ", GV%RecRaysPerSrcRay

  write(lun,*) 
  write(lun,*) 
  write(lun,*)  "Hydrogen Mass Fraction: ", GV%H_mf
  write(lun,*)  "Helium Mass Fraction: ", GV%He_mf
  
  write(lun,*)
  write(lun,*)
  write(lun,*)  "Output Dir         : ", trim(GV%OutputDir)
  write(lun,*)  "Output File Base   : ", trim(GV%OutputFileBase)
  write(lun,*)  "Output Type (1=Std. Gadget, 2=HDF5 Gadget) : ", GV%OutputType

  write(lun,*)  "Output timing plan : ", trim(GV%OutputTiming)

  write(lun,*)  "Number Std Outs    : ", GV%NumStdOuts
  write(lun,*)  "Do Initial Output  : ", GV%DoInitialOutput

  write(lun,*)  "Ion Frac Out Rays  : ", GV%IonFracOutRays

  write(lun,*)  "ForcedOutFile      : ", trim(GV%ForcedOutFile)
  write(lun,*)  "ForcedUnits        : ", trim(GV%ForcedUnits)

  write(lun,*)  "Particles Per Tree Cell: ", GV%PartPerCell


  write(lun,*)"====================================="
  write(lun,*)"   End SPHRAY Configuration Output   "
  write(lun,*)"====================================="
  write(lun,*)
  write(lun,*)

  if (GV%FixSnapTemp) then
     write(lun,*) "***********************************************************"
     write(lun,*) "you are running a constant temperature simulation."
     write(lun,*) "the temperatures are fixed at the readin snapshot values"
     write(lun,*) "***********************************************************"
  else
     if (GV%IsoTemp /= 0.0) then
        write(lun,*) "***********************************************************"
        write(lun,*) "you are running a constant temperature simulation."
        write(lun,*) "the temperature is fixed at T (K) = ", GV%IsoTemp
        write(lun,*) "***********************************************************"
     end if
  end if

 
  close(lun)

end subroutine config_info_to_file


end module config_mod