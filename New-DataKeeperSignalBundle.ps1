$PSScriptRoot
cd $PSScriptRoot

# create temp files in build folder
if(-Not (Test-Path -Path ".\build")) {
    mkdir .\build
}
mkdir .\build\Signal_iQ
Copy-Item .\Signal_iQ\python\SignaliQ\* .\build\SignaliQ -Recurse
Copy-Item .\scripts\Setup.py .\build
Copy-Item .\Windows_Signal\report_event.py .\build
&'python' -m pip install -r .\Signal_iQ\python\requirements.txt

cd .\build
&'python' .\setup.py py2exe

# Py2exe ignores the certs folder during build, so extract the library archive 
# and put them in anyway. The archive needs to not be compressed on the target 
# machine anyway.
Expand-Archive .\dist\library.zip -DestinationPath .\dist\library -Force

# create the destination folder for the cert files
$path =  ".\dist\library\SignaliQ\certs"
if(-Not (Test-Path -Path $path)) { 
    mkdir $path 
}

# copy the cert files over and do some clean up.
Copy-Item .\SignaliQ\certs\* $path
Remove-Item .\dist\library.zip
Rename-Item -Path ".\dist\library" -NewName "library.zip"
Remove-Item -Path .\build -Recurse -Force
Remove-Item -Path .\SignaliQ -Recurse -Force
Remove-Item -Path .\*.py -Force

if(-Not (Test-Path -Path ".\json")) { 
    mkdir ".\json"
}
Copy-Item ..\Windows_Signal\json\* .\json
Copy-Item ..\Windows_Signal\*.ps1 .\
Copy-Item ..\scripts\Install-DataKeeperSignal.ps1 .\

cd $PSScriptRoot