$port = 8080
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$port/")
$listener.Start()
Write-Host "Server running at http://localhost:$port/"
$htmlFile = Join-Path $PSScriptRoot "index.html"

while ($listener.IsListening) {
    $context = $listener.GetContext()
    $response = $context.Response
    if (Test-Path $htmlFile) {
        $content = [System.IO.File]::ReadAllBytes($htmlFile)
        $response.ContentType = "text/html; charset=utf-8"
        $response.ContentLength64 = $content.Length
        $response.OutputStream.Write($content, 0, $content.Length)
    } else {
        $response.StatusCode = 404
    }
    $response.OutputStream.Close()
}
