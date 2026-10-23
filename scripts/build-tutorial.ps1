$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
$root = Split-Path $PSScriptRoot -Parent
$output = Join-Path $root 'assets/tutorial'
[IO.Directory]::CreateDirectory($output) | Out-Null
$temp = Join-Path ([IO.Path]::GetTempPath()) ('underscore-video-' + [guid]::NewGuid())
[IO.Directory]::CreateDirectory($temp) | Out-Null
$logo = [Drawing.Image]::FromFile((Join-Path $root 'assets/Logo/logo256.png'))
$slides = @(
    @('UNDERSCORE', 'Discord Web Auto Quest', 'SETUP GUIDE', 'Install the extension and explore the quest panel.'),
    @('01 / DOWNLOAD', 'Get the project files', 'DOWNLOAD > EXTRACT', 'Download the repository ZIP from GitHub.', 'Extract it and locate manifest.json.'),
    @('02 / INSTALL', 'Load the extension', 'chrome://extensions', 'Enable Developer mode, then choose Load unpacked.', 'Select the folder containing manifest.json.', 'Edge users: open edge://extensions instead.'),
    @('03 / OPEN DISCORD', 'Find an available quest', 'discord.com/quest-home', 'Sign in, accept an available quest, then refresh.', 'Keep the quest page open.'),
    @('04 / START', 'Open the quest panel', 'Running Quests  >', 'Click Running Quests at the bottom right.', 'Expand the panel to see progress.', 'Copy JSON exports the current progress data.'),
    @('READY TO EXPLORE', 'Keep the guide nearby', 'UNDERSCORE', 'No button? Enable the extension and refresh.', 'Progress stalled? Press F12 and inspect the console.', 'Automation may put your Discord account at risk.')
)
try {
    for ($i = 0; $i -lt $slides.Count; $i++) {
        $bmp = New-Object Drawing.Bitmap(1280,720)
        $g = [Drawing.Graphics]::FromImage($bmp)
        $g.SmoothingMode = 'AntiAlias'
        $g.TextRenderingHint = 'AntiAliasGridFit'
        $bg = New-Object Drawing.SolidBrush([Drawing.Color]::FromArgb(13,16,26))
        $white = New-Object Drawing.SolidBrush([Drawing.Color]::FromArgb(242,245,255))
        $muted = New-Object Drawing.SolidBrush([Drawing.Color]::FromArgb(175,186,208))
        $accent = New-Object Drawing.SolidBrush([Drawing.Color]::FromArgb(113,230,205))
        $panel = New-Object Drawing.SolidBrush([Drawing.Color]::FromArgb(29,36,53))
        $small = New-Object Drawing.Font('Segoe UI',17)
        $title = New-Object Drawing.Font('Segoe UI',42,[Drawing.FontStyle]::Bold)
        $body = New-Object Drawing.Font('Segoe UI',22)
        try {
            $g.FillRectangle($bg,0,0,1280,720)
            $g.FillRectangle($accent,72,65,48,5)
            $g.DrawString($slides[$i][0],$small,$accent,72,90)
            $g.DrawString($slides[$i][1],$title,$white,68,144)
            $g.FillRectangle($panel,72,255,960,78)
            $g.DrawString($slides[$i][2],$body,$white,96,275)
            for ($j = 3; $j -lt $slides[$i].Count; $j++) {
                $g.DrawString($slides[$i][$j],$body,$muted,72,(375 + ($j-3)*55))
            }
            $g.DrawImage($logo,1080,65,120,120)
            $g.DrawString('UNDERSCORE  /  ILLUSTRATED TUTORIAL',$small,$muted,72,645)
            $g.DrawString(('{0:00} / 06' -f ($i+1)),$small,$accent,1100,645)
            $frame = Join-Path $temp "slide$i.png"
            $bmp.Save($frame,[Drawing.Imaging.ImageFormat]::Png)
            if ($i -eq 0) { $bmp.Save((Join-Path $output 'preview.png'),[Drawing.Imaging.ImageFormat]::Png) }
        } finally {
            $g.Dispose(); $bmp.Dispose()
            foreach ($resource in @($bg,$white,$muted,$accent,$panel,$small,$title,$body)) { $resource.Dispose() }
        }
        # Slow zoom and fade transitions animate each six-second scene.
        $filter = "zoompan=z='1+0.00015*on':x='iw/2-iw/zoom/2':y='ih/2-ih/zoom/2':d=180:s=1280x720:fps=30,fade=t=in:st=0:d=0.35,fade=t=out:st=5.65:d=0.35,drawbox=x=0:y=710:w=1280:h=10:color=0x71e6cd:t=fill,crop=1280:720,format=yuv420p"
        & ffmpeg -hide_banner -loglevel error -y -i $frame -vf $filter -t 6 -c:v libx264 -preset fast -crf 23 (Join-Path $temp "clip$i.mp4")
        if ($LASTEXITCODE -ne 0) { throw "Failed to render scene $i" }
    }
    $list = Join-Path $temp 'clips.txt'
    (0..5 | ForEach-Object { "file 'clip$_.mp4'" }) | Set-Content -LiteralPath $list -Encoding ascii
    & ffmpeg -hide_banner -loglevel error -y -f concat -safe 0 -i $list -c copy -movflags +faststart (Join-Path $output 'underscore-tutorial.mp4')
    if ($LASTEXITCODE -ne 0) { throw 'Failed to assemble tutorial' }
} finally {
    $logo.Dispose()
    # Only remove this invocation's explicitly created temporary directory.
    if ((Split-Path $temp -Parent) -eq ([IO.Path]::GetTempPath()).TrimEnd('\')) { Remove-Item -LiteralPath $temp -Recurse -Force }
}
