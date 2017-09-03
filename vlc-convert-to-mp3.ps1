$inputDirectory = "C:\Media\Audio\";
$outputDirectory = "C:\Media\Audio\";

$codec = "mp3"; 
$bitrate = 160; 
$channels = 2; 

foreach($inputFile in Get-ChildItem "$inputDirectory" -Recurse -Include *.wma,*.aac,*.ogg,*.m4a) 
{ 
    Write-Host $inputFile;

    $outputFileName = [System.IO.Path]::GetFileNameWithoutExtension($inputFile.FullName) + ".$codec";
    $outputFileName = [System.IO.Path]::Combine($outputDirectory, $outputFileName);

    # Find where VLC is installed
    $programFiles = ${env:ProgramFiles(x86)};
    if($programFiles -eq $null) 
    { 
        $programFiles = $env:ProgramFiles;
    } 

    $processExecutable = $programFiles + "\VideoLAN\VLC\vlc.exe"; 
    $processArguments = "-I dummy -vvv `"$($inputFile.FullName)`" --sout=#transcode{acodec=`"$codec`",ab=`"$bitrate`",vcodec=dummy,channels=`"$channels`"}:standard{access=`"file`",mux=`"raw`",dst=`"$outputFileName`"} vlc://quit";

    Start-Process $processExecutable $processArguments -Wait
}
