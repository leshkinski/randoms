function Expand-ZIPFile($file, $destination)
{
    $shell = new-object -com shell.application
    $zip = $shell.NameSpace($file)
    foreach($item in $zip.items())
    {
        $shell.Namespace($destination).copyhere($item)
    }
}
function installWMF5
{
    # Install WMF5.0 Preview and reboot
    #
    $Workingdir = "c:\dsc"
    # Download link for Windows Management Framework 5 (Preview - February 2015)
    # Latest version available here: http://goo.gl/0JEPhy
    #
    $wmf5Uri = "http://b2989bfbc7e056e23914-e8ef2cfe4f3b7f0c925c72e6b0f7018a.r70.cf3.rackcdn.com/WindowsBlue-KB3055381-x64.msu"
    # Create our working direcotry
    if (!(Test-Path $Workingdir)){mkdir $Workingdir}
    Set-Location $Workingdir
    # Download WMF5 and silently install it
    #
    #  REBOOT WILL OCCUR A FEW SECONDS AFTER THE INSTALL HAPPENS!!!!
    #
    #
    Invoke-WebRequest -Uri $wmf5Uri -OutFile WMF5preview.msu
    & wusa .\WMF5preview.msu /quiet
}
function installModules
{
    # Download and install DSC modules
    #
    $ModulePath = "C:\Program Files\WindowsPowerShell\Modules\"
    $Workingdir = "c:\dsc"
    if (!(Test-Path $Workingdir)){mkdir $Workingdir}
    Set-Location $Workingdir
    Invoke-WebRequest -Uri http://b2989bfbc7e056e23914-e8ef2cfe4f3b7f0c925c72e6b0f7018a.r70.cf3.rackcdn.com/DSC%20Resource%20Kit%20Wave%208%2011102014.zip -OutFile .\DSCResourceKitWave8.zip
    Invoke-WebRequest -uri https://github.com/leshkinski/DSC/archive/master.zip -OutFile .\DSC-master.zip
    Invoke-WebRequest -Uri https://github.com/PowerShellOrg/cChoco/archive/master.zip -OutFile .\cChoco.zip
    Expand-ZIPFile -file $Workingdir\DSCResourceKitWave8.zip -Destination $Workingdir
    Expand-ZIPFile -file $Workingdir\DSC-master.zip -Destination $Workingdir
    Expand-ZIPFile -file $Workingdir\cChoco.zip -Destination $Workingdir
    Copy-Item -Path ".\All Resources\*" -Destination $ModulePath -Recurse  -Force
    Copy-Item -Path ".\DSC-master\Resources\cGit" -Destination $ModulePath -Recurse  -Force
    Copy-Item -Path ".\DSC-master\Resources\cWebAdministration" -Destination $ModulePath -Recurse  -Force
    Copy-Item -Path ".\cChoco-master\" -Destination "$ModulePath\cChoco" -Force -Recurse
    Remove-Item -Path $Workingdir/* -Recurse -Force
    (Get-ChildItem "C:\Program Files\WindowsPowerShell\Modules\" -Recurse -file).FullName | ForEach-Object {Unblock-File $_}
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine -Force
    Update-Help
    Clear-Host
    Write-Host "Complete"
}
 
 
#installModules
 
## Uncomment below to install WMF 5.0 - will reboot the machine
installWMF5

