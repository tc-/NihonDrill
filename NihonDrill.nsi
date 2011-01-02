
Name "NihonDrill"

OutFile "NihonDrill_0.1.exe"

InstallDir $PROGRAMFILES\NihonDrill

RequestExecutionLevel admin

Page directory
Page instfiles

Section ""
  SetOverwrite on

  SetOutPath $INSTDIR
  File *.lua
  File LICENSE
  File README
  File Tuffy.ttf
  File NihonDrill.bat

  SetOutPath $INSTDIR\images
  File images\*.png

  SetOutPath $INSTDIR\images\hiragana
  File images\hiragana\*.png

  SetOutPath $INSTDIR\images\katakana
  File images\katakana\*.png

  SetOutPath $INSTDIR\images\levels
  File images\levels\*.png

  SetOutPath $INSTDIR\images\special
  File images\special\*.png

  SetOutPath $INSTDIR\love
  File love\*.*

  SetOutPath $INSTDIR\sound
  File /x aiueo.mp3 sound\*.mp3

  SetOutPath $INSTDIR\voc
  File voc\*.lua

  SetOutPath $INSTDIR
  WriteUninstaller "uninstall.exe"

SectionEnd

Section "Start Menu Shortcuts"

  CreateDirectory "$SMPROGRAMS\NihonDrill"
  CreateShortCut "$SMPROGRAMS\NihonDrill\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
  CreateShortCut "$SMPROGRAMS\NihonDrill\NihonDrill.lnk" "$INSTDIR\love\love.exe" "."
  
SectionEnd

Section "Uninstall"
  
  Delete $INSTDIR\*.lua
  Delete $INSTDIR\LICENSE

  Delete $INSTDIR\*.lua
  Delete $INSTDIR\LICENSE
  Delete $INSTDIR\README
  Delete $INSTDIR\Tuffy.ttf
  Delete $INSTDIR\NihonDrill.bat
  Delete $INSTDIR\images\*.png
  Delete $INSTDIR\images\hiragana\*.png
  Delete $INSTDIR\images\katakana\*.png
  Delete $INSTDIR\images\levels\*.png
  Delete $INSTDIR\images\special\*.png
  Delete $INSTDIR\love\*.*
  Delete $INSTDIR\sound\*.mp3
  Delete $INSTDIR\voc\*.lua

  Delete $INSTDIR\uninstall.exe

  RMDir "$INSTDIR\images\hiragana"
  RMDir "$INSTDIR\images\katakana"
  RMDir "$INSTDIR\images\levels"
  RMDir "$INSTDIR\images\special"
  RMDir "$INSTDIR\images"
  RMDir "$INSTDIR\love"
  RMDir "$INSTDIR\sound"
  RMDir "$INSTDIR\voc"
  RMDir "$INSTDIR"

  Delete $SMPROGRAMS\NihonDrill\*.*
  RMDir "$SMPROGRAMS\NihonDrill"

SectionEnd
