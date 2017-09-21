@echo on

cd %ENG_WORK_SPACE%\\BTTInstallPackaging
ant -logfile logs\updateSite.log -buildfile build_updateSite.xml
cd %ENG_WORK_SPACE%\\SandBox