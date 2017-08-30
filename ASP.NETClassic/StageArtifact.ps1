$target = "C:\inetpub\wwwroot\MVCDemo\" 

function DeleteIfExistsAndCreateEmptyFolder($dir )
{
    if ( Test-Path $dir ) {    
           Get-ChildItem -Path  $dir -Force -Recurse | Remove-Item -force -recurse
           Remove-Item $dir -Force
    }
    New-Item -ItemType Directory -Force -Path $dir
}
# Clean up target Directory
DeleteIfExistsAndCreateEmptyFolder($target )

# MS WebDeploy creates a Web Artifact with multiple levels of folders. We only need the 
# content of the folder which has Web.Config within it 
function GetWebArtifactFolderPath($path)
{
    foreach ($item in Get-ChildItem $path)
    {   
        if (Test-Path $item.FullName -PathType Container)
        {   
            # return the full path for the folder which contains Global.asax
            if (Test-Path ($item.fullname + "\Global.asax"))
            {
                #$item.FullName
                return $item.FullName;
            }
            GetWebArtifactFolderPath $item.FullName
        }
    }
}


$path = GetWebArtifactFolderPath("C:\temp\WebApp\MVCDemo")
$path2 = $path + "\*"
Copy-Item $path2 $target -recurse -force



