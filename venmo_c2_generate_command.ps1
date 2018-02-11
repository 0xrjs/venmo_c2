# prompt user for command input
$original_venmo_c2_command = Read-Host -Prompt "Enter command to be encoded"

# create memory stream object
$memory_stream = New-Object System.IO.MemoryStream

# create compression stream object
$compression_stream = New-Object System.IO.Compression.GZipStream($memory_stream, [System.IO.Compression.CompressionMode]::Compress)

# create stream writer object
$stream_writer = New-Object System.IO.StreamWriter($compression_stream)

# write unencoded command into stream writer object
$stream_writer.Write($original_venmo_c2_command)

# close the stream writer object
$stream_writer.Close()

# fetch contents writter into memory stream and base64 encode it
$encoded_venmo_c2_command = [System.Convert]::ToBase64String($memory_stream.ToArray())

# present compressed and encoded command output
Write-Host $encoded_venmo_c2_command