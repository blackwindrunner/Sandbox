"E:\BTT_Installer\8210\materials\BTT_IDE_Windows\eclipsec.exe" -nosplash -application org.eclipse.equinox.p2.director -uninstallIU com.ibm.btt.tools.feature.feature.group -destination "E:\BTT_Installer\8210\materials\BTT_IDE_Windows"

"E:\BTT_Installer\8210\materials\BTT_IDE_Windows\eclipsec.exe" -nosplash -application org.eclipse.equinox.p2.garbagecollector.application -profile epp.package.modeling

"E:\BTT_Installer\8210\materials\BTT_IDE_Windows\eclipsec.exe" -nosplash -application org.eclipse.equinox.p2.director -repository "jar:file:/E:\BTT_Installer\8210\materials\BTTInstallPackaging\plugins\updateSite\BTT_UpdateSite.zip!/" -installIU com.ibm.btt.tools.feature.feature.group -destination "E:\BTT_Installer\8210\materials\BTT_IDE_Windows" 