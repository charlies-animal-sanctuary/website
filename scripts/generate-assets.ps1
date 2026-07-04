# Generates the site's logo variants and favicons from the provided white
# line-art logo (Initial Files/logo/charlie-logo-white.png — white strokes on
# transparency). The Ebony (#414833) recolor is done with a ColorMatrix so the
# anti-aliased alpha channel stays clean. Cream (#EDE0D4) below is the Almond
# Cream token from src/styles/tokens.css.
# Windows-only dev tooling (GDI+); outputs are committed, so this rarely reruns.

Add-Type -AssemblyName System.Drawing
$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$srcPath = Join-Path $root 'Initial Files\logo\charlie-logo-white.png'
$logoDir = Join-Path $root 'src\assets\logo'
$pubDir = Join-Path $root 'public'
New-Item -ItemType Directory -Force -Path $logoDir | Out-Null
New-Item -ItemType Directory -Force -Path $pubDir | Out-Null

$src = New-Object System.Drawing.Bitmap($srcPath)
Write-Output ("Source: {0}x{1}" -f $src.Width, $src.Height)

# Ebony recolor: zero RGB, translate to (65, 72, 51), keep alpha untouched.
$cm = New-Object System.Drawing.Imaging.ColorMatrix
$cm.Matrix00 = 0; $cm.Matrix11 = 0; $cm.Matrix22 = 0
$cm.Matrix40 = 65 / 255; $cm.Matrix41 = 72 / 255; $cm.Matrix42 = 51 / 255
$ebonyAttr = New-Object System.Drawing.Imaging.ImageAttributes
$ebonyAttr.SetColorMatrix($cm)

function Copy-Region($img, $fx, $fy, $fw, $fh) {
    $x = [int]($img.Width * $fx); $y = [int]($img.Height * $fy)
    $w = [int]($img.Width * $fw); $h = [int]($img.Height * $fh)
    $bmp = New-Object System.Drawing.Bitmap($w, $h, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $dest = New-Object System.Drawing.Rectangle(0, 0, $w, $h)
    $g.DrawImage($img, $dest, $x, $y, $w, $h, [System.Drawing.GraphicsUnit]::Pixel)
    $g.Dispose()
    return $bmp
}

function Copy-Recolored($img, $attr) {
    $bmp = New-Object System.Drawing.Bitmap($img.Width, $img.Height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $dest = New-Object System.Drawing.Rectangle(0, 0, $img.Width, $img.Height)
    $g.DrawImage($img, $dest, 0, 0, $img.Width, $img.Height, [System.Drawing.GraphicsUnit]::Pixel, $attr)
    $g.Dispose()
    return $bmp
}

function New-IconTile($paw, $attr, $size) {
    $bmp = New-Object System.Drawing.Bitmap($size, $size, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic

    # cream rounded-square tile (reads on light and dark browser chrome)
    $r = [int]($size * 0.22); $d = $r * 2
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $path.AddArc(0, 0, $d, $d, 180, 90)
    $path.AddArc($size - $d, 0, $d, $d, 270, 90)
    $path.AddArc($size - $d, $size - $d, $d, $d, 0, 90)
    $path.AddArc(0, $size - $d, $d, $d, 90, 90)
    $path.CloseFigure()
    $brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 237, 224, 212))
    $g.FillPath($brush, $path)

    # paw centered at ~64% of the tile, aspect preserved
    $scale = ($size * 0.64) / [Math]::Max($paw.Width, $paw.Height)
    $w = [int]($paw.Width * $scale); $h = [int]($paw.Height * $scale)
    $dest = New-Object System.Drawing.Rectangle([int](($size - $w) / 2), [int](($size - $h) / 2), $w, $h)
    $g.DrawImage($paw, $dest, 0, 0, $paw.Width, $paw.Height, [System.Drawing.GraphicsUnit]::Pixel, $attr)

    $g.Dispose(); $brush.Dispose(); $path.Dispose()
    return $bmp
}

# Full mark, margins trimmed (fractions eyeballed against the source, verified visually)
$mark = Copy-Region $src 0.20 0.15 0.60 0.67
$mark.Save((Join-Path $logoDir 'logo-white.png'), [System.Drawing.Imaging.ImageFormat]::Png)
$ebony = Copy-Recolored $mark $ebonyAttr
$ebony.Save((Join-Path $logoDir 'logo-ebony.png'), [System.Drawing.Imaging.ImageFormat]::Png)

# Paw element only, for favicons (full circular mark is illegible at 16-48px)
$paw = Copy-Region $src 0.630 0.566 0.110 0.114
foreach ($spec in @(@{ n = 'favicon.png'; s = 48 }, @{ n = 'apple-touch-icon.png'; s = 180 })) {
    $tile = New-IconTile $paw $ebonyAttr $spec.s
    $tile.Save((Join-Path $pubDir $spec.n), [System.Drawing.Imaging.ImageFormat]::Png)
    $tile.Dispose()
}

$paw.Dispose(); $ebony.Dispose(); $mark.Dispose(); $src.Dispose()
Write-Output 'Assets written: src/assets/logo/logo-white.png, logo-ebony.png; public/favicon.png, apple-touch-icon.png'
