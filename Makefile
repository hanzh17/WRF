#	Top level Makefile for wrf system

LN      =       ln -s
MAKE    =       make -i -r
MV	=	/bin/mv
RM      =       /bin/rm -f

# this will be overridden if WRF_CHEM is set to 1 in the configure.wrf file
WRF_CHEM = 0

include ./configure.wrf

EM_MODULE_DIR = -I../dyn_em
EM_MODULES =  $(EM_MODULE_DIR)


#### 3.d.   add macros to specify the modules for this core

#EXP_MODULE_DIR = -I../dyn_exp
#EXP_MODULES =  $(EXP_MODULE_DIR)


NMM_MODULE_DIR = -I../dyn_nmm
NMM_MODULES =  $(NMM_MODULE_DIR)

ALL_MODULES =                           \
               $(EM_MODULE_DIR)         \
               $(NMM_MODULES)           \
               $(EXP_MODULES)           \
               $(INCLUDE_MODULES)

deflt :
		@ echo Please compile the code using ./compile

configcheck:
	@if [ "$(A2DCASE)" -a "$(DMPARALLEL)" ] ; then \
	 echo "------------------------------------------------------------------------------" ; \
	 echo "WRF CONFIGURATION ERROR                                                       " ; \
	 echo "The $(A2DCASE) case cannot be used on distributed memory parallel systems." ; \
	 echo "Only 3D WRF cases will run on these systems." ; \
	 echo "Please chose a different case or rerun configure and chose a different option."  ; \
	 echo "------------------------------------------------------------------------------" ; \
         exit 2 ; \
	fi

wrf : configcheck
	$(MAKE) MODULE_DIRS="$(ALL_MODULES)" ext
	$(MAKE) MODULE_DIRS="$(ALL_MODULES)" toolsdir
	/bin/rm -f main/libwrflib.a
	$(MAKE) MODULE_DIRS="$(ALL_MODULES)" framework
	$(MAKE) MODULE_DIRS="$(ALL_MODULES)" shared
	$(MAKE) MODULE_DIRS="$(ALL_MODULES)" physics
	if [ $(WRF_CHEM) -eq 1 ]    ; then $(MAKE) MODULE_DIRS="$(ALL_MODULES)" chemics ; fi
	if [ $(WRF_EM_CORE) -eq 1 ]    ; then $(MAKE) MODULE_DIRS="$(ALL_MODULES)" em_core ; fi
	if [ $(WRF_NMM_CORE) -eq 1 ]   ; then $(MAKE) MODULE_DIRS="$(ALL_MODULES)" nmm_core ; fi
	if [ $(WRF_EXP_CORE) -eq 1 ]   ; then $(MAKE) MODULE_DIRS="$(ALL_MODULES)" exp_core ; fi
	( cd main ; $(MAKE) MODULE_DIRS="$(ALL_MODULES)" SOLVER=em em_wrf )
	( cd run ; /bin/rm -f wrf.exe ; ln -s ../main/wrf.exe . )

### 3.a.  rules to build the framework and then the experimental core

exp_wrf : configcheck
	$(MAKE) MODULE_DIRS="$(ALL_MODULES)" ext
	$(MAKE) MODULE_DIRS="$(ALL_MODULES)" toolsdir
	$(MAKE) MODULE_DIRS="$(ALL_MODULES)" framework
	$(MAKE) MODULE_DIRS="$(ALL_MODULES)" shared
	( cd main ; $(MAKE) MODULE_DIRS="$(ALL_MODULES)" SOLVER=exp exp_wrf )


nmm_wrf : wrf


#  Eulerian mass coordinate initializations

em_quarter_ss : wrf
	@ echo '--------------------------------------'
	( cd main ; $(MAKE) MODULE_DIRS="$(ALL_MODULES)" SOLVER=em IDEAL_CASE=quarter_ss em_ideal )
	( cd test/em_quarter_ss ; /bin/rm -f wrf.exe ; ln -s ../../main/wrf.exe . )
	( cd test/em_quarter_ss ; /bin/rm -f ideal.exe ; ln -s ../../main/ideal.exe . )
	( cd test/em_quarter_ss ; /bin/rm -f README.namelist ; ln -s ../../run/README.namelist . )
	( cd test/em_quarter_ss ; /bin/rm -f gribmap.txt ; ln -s ../../run/gribmap.txt . )
	( cd run ; /bin/rm -f ideal.exe ; ln -s ../main/ideal.exe . )
	( cd run ; /bin/rm -f namelist.input ; ln -s ../test/em_quarter_ss/namelist.input . )
	( cd run ; /bin/rm -f input_sounding ; ln -s ../test/em_quarter_ss/input_sounding . )

em_squall2d_x : wrf
	@ echo '--------------------------------------'
	( cd main ; $(MAKE) MODULE_DIRS="$(ALL_MODULES)" SOLVER=em IDEAL_CASE=squall2d_x em_ideal )
	( cd test/em_squall2d_x ; /bin/rm -f wrf.exe ; ln -s ../../main/wrf.exe . )
	( cd test/em_squall2d_x ; /bin/rm -f ideal.exe ; ln -s ../../main/ideal.exe . )
	( cd test/em_squall2d_x ; /bin/rm -f README.namelist ; ln -s ../../run/README.namelist . )
	( cd test/em_squall2d_x ; /bin/rm -f gribmap.txt ; ln -s ../../run/gribmap.txt . )
	( cd run ; /bin/rm -f ideal.exe ; ln -s ../main/ideal.exe . )
	( cd run ; /bin/rm -f namelist.input ; ln -s ../test/em_squall2d_x/namelist.input . )
	( cd run ; /bin/rm -f input_sounding ; ln -s ../test/em_squall2d_x/input_sounding . )

em_squall2d_y : wrf
	@ echo '--------------------------------------'
	( cd main ; $(MAKE) MODULE_DIRS="$(ALL_MODULES)" SOLVER=em IDEAL_CASE=squall2d_y em_ideal )
	( cd test/em_squall2d_y ; /bin/rm -f wrf.exe ; ln -s ../../main/wrf.exe . )
	( cd test/em_squall2d_y ; /bin/rm -f ideal.exe ; ln -s ../../main/ideal.exe . )
	( cd test/em_squall2d_y ; /bin/rm -f README.namelist ; ln -s ../../run/README.namelist . )
	( cd test/em_squall2d_y ; /bin/rm -f gribmap.txt ; ln -s ../../run/gribmap.txt . )
	( cd run ; /bin/rm -f ideal.exe ; ln -s ../main/ideal.exe . )
	( cd run ; /bin/rm -f namelist.input ; ln -s ../test/em_squall2d_y/namelist.input . )
	( cd run ; /bin/rm -f input_sounding ; ln -s ../test/em_squall2d_y/input_sounding . )

em_b_wave : wrf
	@ echo '--------------------------------------'
	( cd main ; $(MAKE) MODULE_DIRS="$(ALL_MODULES)" SOLVER=em IDEAL_CASE=b_wave em_ideal )
	( cd test/em_b_wave ; /bin/rm -f wrf.exe ; ln -s ../../main/wrf.exe . )
	( cd test/em_b_wave ; /bin/rm -f ideal.exe ; ln -s ../../main/ideal.exe . )
	( cd test/em_b_wave ; /bin/rm -f README.namelist ; ln -s ../../run/README.namelist . )
	( cd test/em_b_wave ; /bin/rm -f gribmap.txt ; ln -s ../../run/gribmap.txt . )
	( cd run ; /bin/rm -f ideal.exe ; ln -s ../main/ideal.exe . )
	( cd run ; /bin/rm -f namelist.input ; ln -s ../test/em_b_wave/namelist.input . )
	( cd run ; /bin/rm -f input_jet ; ln -s ../test/em_b_wave/input_jet . )

em_real : wrf
	@ echo '--------------------------------------'
	( cd main ; $(MAKE) MODULE_DIRS="$(ALL_MODULES)" SOLVER=em IDEAL_CASE=real em_real )
	( cd test/em_real ; /bin/rm -f wrf.exe ; ln -s ../../main/wrf.exe . )
	( cd test/em_real ; /bin/rm -f real.exe ; ln -s ../../main/real.exe . )
	( cd test/em_real ; /bin/rm -f ndown.exe ; ln -s ../../main/ndown.exe . )
	( cd test/em_real ; /bin/rm -f README.namelist ; ln -s ../../run/README.namelist . )
	( cd test/em_real ; /bin/rm -f ETAMPNEW_DATA RRTM_DATA ;    \
             ln -sf ../../run/ETAMPNEW_DATA . ;                     \
             ln -sf ../../run/RRTM_DATA . ;                         \
             if [ $(RWORDSIZE) -eq 8 ] ; then                       \
                ln -sf ../../run/ETAMPNEW_DATA_DBL ETAMPNEW_DATA ;  \
                ln -sf ../../run/RRTM_DATA_DBL RRTM_DATA ;          \
             fi )
	( cd test/em_real ; /bin/rm -f GENPARM.TBL ; ln -s ../../run/GENPARM.TBL . )
	( cd test/em_real ; /bin/rm -f LANDUSE.TBL ; ln -s ../../run/LANDUSE.TBL . )
	( cd test/em_real ; /bin/rm -f SOILPARM.TBL ; ln -s ../../run/SOILPARM.TBL . )
	( cd test/em_real ; /bin/rm -f VEGPARM.TBL ; ln -s ../../run/VEGPARM.TBL . )
	( cd test/em_real ; /bin/rm -f tr49t67 ; ln -s ../../run/tr49t67 . )
	( cd test/em_real ; /bin/rm -f tr49t85 ; ln -s ../../run/tr49t85 . )
	( cd test/em_real ; /bin/rm -f tr67t85 ; ln -s ../../run/tr67t85 . )
	( cd test/em_real ; /bin/rm -f gribmap.txt ; ln -s ../../run/gribmap.txt . )
	( cd run ; /bin/rm -f real.exe ; ln -s ../main/real.exe . )
	( cd run ; /bin/rm -f ndown.exe ; ln -s ../main/ndown.exe . )
	( cd run ; /bin/rm -f namelist.input ; ln -s ../test/em_real/namelist.input . )


em_hill2d_x : wrf
	@ echo '--------------------------------------'
	( cd main ; $(MAKE) MODULE_DIRS="$(ALL_MODULES)" SOLVER=em IDEAL_CASE=hill2d_x em_ideal )
	( cd test/em_hill2d_x ; /bin/rm -f wrf.exe ; ln -s ../../main/wrf.exe . )
	( cd test/em_hill2d_x ; /bin/rm -f ideal.exe ; ln -s ../../main/ideal.exe . )
	( cd test/em_hill2d_x ; /bin/rm -f README.namelist ; ln -s ../../run/README.namelist . )
	( cd test/em_hill2d_x ; /bin/rm -f gribmap.txt ; ln -s ../../run/gribmap.txt . )
	( cd run ; /bin/rm -f ideal.exe ; ln -s ../main/ideal.exe . )
	( cd run ; /bin/rm -f namelist.input ; ln -s ../test/em_hill2d_x/namelist.input . )
	( cd run ; /bin/rm -f input_sounding ; ln -s ../test/em_hill2d_x/input_sounding . )

em_grav2d_x : wrf
	@ echo '--------------------------------------'
	( cd main ; $(MAKE) MODULE_DIRS="$(ALL_MODULES)" SOLVER=em IDEAL_CASE=grav2d_x em_ideal )
	( cd test/em_grav2d_x ; /bin/rm -f wrf.exe ; ln -s ../../main/wrf.exe . )
	( cd test/em_grav2d_x ; /bin/rm -f ideal.exe ; ln -s ../../main/ideal.exe . )
	( cd test/em_grav2d_x ; /bin/rm -f README.namelist ; ln -s ../../run/README.namelist . )
	( cd test/em_grav2d_x ; /bin/rm -f gribmap.txt ; ln -s ../../run/gribmap.txt . )
	( cd run ; /bin/rm -f ideal.exe ; ln -s ../main/ideal.exe . )
	( cd run ; /bin/rm -f namelist.input ; ln -s ../test/em_grav2d_x/namelist.input . )
	( cd run ; /bin/rm -f input_sounding ; ln -s ../test/em_grav2d_x/input_sounding . )

#### anthropogenic emissions converter

emi_conv : wrf
	@ echo '--------------------------------------'
	( cd main ; $(MAKE) MODULE_DIRS="$(ALL_MODULES)" SOLVER=em IDEAL_CASE=real convert_emiss )
	( cd test/em_real ; /bin/rm -f convert_emiss.exe ; ln -s ../../main/convert_emiss.exe . )
	( cd test/em_real ; /bin/rm -f README.namelist ; ln -s ../../run/README.namelist . )
	( cd run ; /bin/rm -f namelist.input ; ln -s ../test/em_real/namelist.input . )

#### biogenic emissions converter

bio_conv : wrf
	@ echo '--------------------------------------'
	( cd main ; $(MAKE) MODULE_DIRS="$(ALL_MODULES)" SOLVER=em IDEAL_CASE=real convert_bioemiss )
	( cd test/em_real ; /bin/rm -f convert_bioemiss.exe ; ln -s ../../main/convert_bioemiss.exe . )
	( cd test/em_real ; /bin/rm -f README.namelist ; ln -s ../../run/README.namelist . )
	( cd run ; /bin/rm -f namelist.input ; ln -s ../test/em_real/namelist.input . )

#### nmm converter

nmm_real : nmm_wrf
	@ echo '--------------------------------------'
	( cd main ; $(MAKE) MODULE_DIRS="$(ALL_MODULES)" SOLVER=nmm IDEAL_CASE=real convert_nmm )
	( cd test/nmm_real ; /bin/rm -f wrf.exe ; ln -s ../../main/wrf.exe . )
	( cd test/nmm_real ; /bin/rm -f convert_nmm.exe ; ln -s ../../main/convert_nmm.exe . )
	( cd test/nmm_real ; /bin/rm -f README.namelist ; ln -s ../../run/README.namelist . )
	( cd test/nmm_real ; /bin/rm -f gribmap.txt ; ln -s ../../run/gribmap.txt . )



# semi-Lagrangian initializations


ext :
	@ echo '--------------------------------------'
	( cd frame ; $(MAKE) externals )

framework :
	@ echo '--------------------------------------'
#	( cd frame ; $(MAKE) framework )
	( cd frame ; $(MAKE) framework; \
	cd ../external/io_netcdf ; make NETCDFPATH="$(NETCDFPATH)" FC="$(FC) $(FCBASEOPTS)" CPP="$(CPP)" diffwrf; \
	cd ../io_grib1 ; make FC="$(FC) -I. $(FCBASEOPTS)" CC="$(CC)" CFLAGS="$(CFLAGS)" CPP="$(CPP)"; \
	cd ../io_int ; $(MAKE) FC="$(FC) $(FCBASEOPTS)" CPP="$(CPP)" diffwrf ; cd ../../frame )

shared :
	@ echo '--------------------------------------'
	( cd share ; $(MAKE) )

chemics :
	@ echo '--------------------------------------'
	( cd chem ; $(MAKE) )

physics :
	@ echo '--------------------------------------'
	( cd phys ; $(MAKE) )

em_core :
	@ echo '--------------------------------------'
	( cd dyn_em ; $(MAKE) )


### 3.b.  sub-rule to build the expimental core

# uncomment the two lines after exp_core for EXP
exp_core :
	@ echo '--------------------------------------'
	( cd dyn_exp ; $(MAKE) )

# uncomment the two lines after nmm_core for NMM
nmm_core :
	@ echo '--------------------------------------'
	( cd dyn_nmm ; $(MAKE) )

toolsdir :
	@ echo '--------------------------------------'
	( cd tools ; $(MAKE) CC="$(CC_TOOLS)" )

clean :
		@ echo 'Use the clean script'

# DO NOT DELETE
