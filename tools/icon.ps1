# Draws the app icon: a gradient tile with a white egg, text lines cut out of it.
#   .\tools\icon.ps1  -> web\icon-512.png, web\icon-192.png
Add-Type -AssemblyName System.Drawing
$root = Split-Path $PSScriptRoot -Parent
function Draw($size, $out) {
  $s = $size / 1024.0
  $bmp = New-Object System.Drawing.Bitmap $size, $size
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = 'AntiAlias'; $g.PixelOffsetMode = 'HighQuality'
  $g.Clear([System.Drawing.Color]::Transparent)
  # rounded tile
  $r = 228 * $s; $x = 32 * $s; $w = 960 * $s
  $tile = New-Object System.Drawing.Drawing2D.GraphicsPath
  $tile.AddArc($x, $x, 2*$r, 2*$r, 180, 90); $tile.AddArc($x+$w-2*$r, $x, 2*$r, 2*$r, 270, 90)
  $tile.AddArc($x+$w-2*$r, $x+$w-2*$r, 2*$r, 2*$r, 0, 90); $tile.AddArc($x, $x+$w-2*$r, 2*$r, 2*$r, 90, 90); $tile.CloseFigure()
  $c1 = [System.Drawing.Color]::FromArgb(255, 0x2E, 0xC4, 0xB6); $c2 = [System.Drawing.Color]::FromArgb(255, 0x23, 0x83, 0xE2)
  $br = New-Object System.Drawing.Drawing2D.LinearGradientBrush ([System.Drawing.PointF]::new(0,0)), ([System.Drawing.PointF]::new($size,$size)), $c1, $c2
  $g.FillPath($br, $tile)
  # egg (same outline as the other Yaytsa icons)
  $e = New-Object System.Drawing.Drawing2D.GraphicsPath
  $P = { param($a,$b) [System.Drawing.PointF]::new($a*$s, $b*$s) }
  $e.AddBezier((& $P 512 196), (& $P 384 196), (& $P 268 392), (& $P 268 552))
  $e.AddBezier((& $P 268 552), (& $P 268 704), (& $P 376 828), (& $P 512 828))
  $e.AddBezier((& $P 512 828), (& $P 648 828), (& $P 756 704), (& $P 756 552))
  $e.AddBezier((& $P 756 552), (& $P 756 392), (& $P 640 196), (& $P 512 196))
  $e.CloseFigure()
  $g.FillPath([System.Drawing.Brushes]::White, $e)
  # text lines: read ones pale, the current one full color, upcoming ones gradient color
  $lines = @(@(392, 220, 0.35), @(470, 300, 0.35), @(548, 300, 1.0), @(626, 260, 1.0), @(704, 160, 1.0))
  foreach ($l in $lines) {
    $y = $l[0] * $s; $lw = $l[1] * $s; $h = 34 * $s; $lx = (512 - $l[1] / 2) * $s
    $p = New-Object System.Drawing.Drawing2D.GraphicsPath
    $p.AddArc($lx, $y, $h, $h, 90, 180); $p.AddArc($lx + $lw - $h, $y, $h, $h, 270, 180); $p.CloseFigure()
    $col = [System.Drawing.Color]::FromArgb([int](255 * $l[2]), 0x25, 0x9C, 0xD0)
    $g.FillPath((New-Object System.Drawing.SolidBrush $col), $p)
  }
  $bmp.Save($out, [System.Drawing.Imaging.ImageFormat]::Png)
  $g.Dispose(); $bmp.Dispose()
}
Draw 512 (Join-Path $root 'web\icon-512.png')
Draw 192 (Join-Path $root 'web\icon-192.png')
"ok"
