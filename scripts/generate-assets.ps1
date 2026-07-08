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

# ---------------------------------------------------------------------------
# §9 sample photos: unmistakably-fake striped stand-ins for the seed
# adoptables (real CMS uploads replace them). Cream bg + camel stripes +
# label, 800x1000 (the site's 4:5 card ratio).
# ---------------------------------------------------------------------------

$adoptImgDir = Join-Path $root 'src\content\adoptables\images'
New-Item -ItemType Directory -Force -Path $adoptImgDir | Out-Null

function New-SamplePhoto($path, $title) {
    $w = 800; $h = 1000
    $bmp = New-Object System.Drawing.Bitmap($w, $h, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.Clear([System.Drawing.Color]::FromArgb(255, 237, 224, 212))   # Almond Cream token

    $stripePen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(70, 166, 138, 100), 26)  # Camel token @ ~27%
    for ($x = -$h; $x -lt $w + $h; $x += 64) {
        $g.DrawLine($stripePen, $x, 0, ($x + $h), $h)
    }
    $stripePen.Dispose()

    $borderPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 166, 138, 100), 6)
    $borderPen.DashStyle = [System.Drawing.Drawing2D.DashStyle]::Dash
    $g.DrawRectangle($borderPen, 12, 12, ($w - 24), ($h - 24))
    $borderPen.Dispose()

    $ebonyBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 65, 72, 51))
    $fmt = New-Object System.Drawing.StringFormat
    $fmt.Alignment = [System.Drawing.StringAlignment]::Center
    $fmt.LineAlignment = [System.Drawing.StringAlignment]::Center
    $fontBig = New-Object System.Drawing.Font('Segoe UI', 44, [System.Drawing.FontStyle]::Bold)
    $fontSmall = New-Object System.Drawing.Font('Segoe UI', 22)
    $g.DrawString($title, $fontBig, $ebonyBrush, (New-Object System.Drawing.RectangleF(40, 340, ($w - 80), 200)), $fmt)
    $g.DrawString("Sample photo -- real animals`nget real photos via /admin", $fontSmall, $ebonyBrush, (New-Object System.Drawing.RectangleF(40, 540, ($w - 80), 160)), $fmt)
    $fontBig.Dispose(); $fontSmall.Dispose(); $ebonyBrush.Dispose(); $fmt.Dispose()

    $g.Dispose()
    $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

New-SamplePhoto (Join-Path $adoptImgDir 'sample-photo-1.png') 'SAMPLE KITTEN'
New-SamplePhoto (Join-Path $adoptImgDir 'sample-photo-2.png') 'SAMPLE PUP'
New-SamplePhoto (Join-Path $adoptImgDir 'sample-photo-3.png') 'SAMPLE SENIOR'
Write-Output 'Sample adoptable photos written to src/content/adoptables/images/'

# ---------------------------------------------------------------------------
# Resident photo import: copy the owner's temp photos (Ash, Midna) into the
# residents collection, EXIF-orientation corrected, resized to max 1600px,
# JPEG q85 — keeps the public repo lean vs 4000px phone originals.
# ---------------------------------------------------------------------------

$resImgDir = Join-Path $root 'src\content\residents\images'
New-Item -ItemType Directory -Force -Path $resImgDir | Out-Null
$photoSrcDir = Join-Path $root 'Initial Files\Temporary Photos'

$jpegCodec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() |
    Where-Object { $_.MimeType -eq 'image/jpeg' } | Select-Object -First 1
$encParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
$encParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, [long]85)

function Import-Photo($srcDir, $srcName, $destDir, $destName) {
    $img = New-Object System.Drawing.Bitmap((Join-Path $srcDir $srcName))
    # apply EXIF orientation (id 274) so pixels match how phones display them
    if ($img.PropertyIdList -contains 274) {
        switch ($img.GetPropertyItem(274).Value[0]) {
            3 { $img.RotateFlip([System.Drawing.RotateFlipType]::Rotate180FlipNone) }
            6 { $img.RotateFlip([System.Drawing.RotateFlipType]::Rotate90FlipNone) }
            8 { $img.RotateFlip([System.Drawing.RotateFlipType]::Rotate270FlipNone) }
        }
    }
    $scale = [Math]::Min(1.0, 1600.0 / [Math]::Max($img.Width, $img.Height))
    $w = [int]($img.Width * $scale); $h = [int]($img.Height * $scale)
    $out = New-Object System.Drawing.Bitmap($w, $h)
    $g = [System.Drawing.Graphics]::FromImage($out)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.DrawImage($img, 0, 0, $w, $h)
    $g.Dispose()
    $out.Save((Join-Path $destDir $destName), $jpegCodec, $encParams)
    $out.Dispose(); $img.Dispose()
    Write-Output ("  {0} -> {1} ({2}x{3})" -f $srcName, $destName, $w, $h)
}

Import-Photo $photoSrcDir 'Ash1.jpg' $resImgDir 'ash-1.jpg'
Import-Photo $photoSrcDir 'Ash2.jpg' $resImgDir 'ash-2.jpg'
Import-Photo $photoSrcDir 'Midna1.jpg' $resImgDir 'midna-1.jpg'
Import-Photo $photoSrcDir 'Midna2.jpg' $resImgDir 'midna-2.jpg'
Import-Photo $photoSrcDir 'AshMidna1.jpg' $resImgDir 'ash-midna-1.jpg'
Import-Photo $photoSrcDir 'AshMidna2.jpg' $resImgDir 'ash-midna-2.jpg'
Write-Output 'Resident photos imported to src/content/residents/images/'

# ---------------------------------------------------------------------------
# 2026-07-08 drop (_incoming/File dump): full family roster, hero, highlights.
# Picks come from the photo-triage pass (progress.md). Skips gracefully if the
# drop folder has been emptied — committed outputs are the durable copies.
# ---------------------------------------------------------------------------

$dump = Join-Path $root '_incoming\File dump\Animal Sanctuary Pictures'
if (Test-Path $dump) {
    $heroDir = Join-Path $root 'src\assets\hero'
    $hlImgDir = Join-Path $root 'src\content\highlights\images'
    New-Item -ItemType Directory -Force -Path $heroDir | Out-Null
    New-Item -ItemType Directory -Force -Path $hlImgDir | Out-Null

    # Ash & Midna upgrades (main portraits + extra gallery shots)
    Import-Photo (Join-Path $dump 'Ash') '20260427_105137.jpg' $resImgDir 'ash-3.jpg'
    Import-Photo (Join-Path $dump 'Ash') '20260310_121940.jpg' $resImgDir 'ash-4.jpg'
    Import-Photo (Join-Path $dump 'Ash') '20260322_110449.jpg' $resImgDir 'ash-5.jpg'
    Import-Photo (Join-Path $dump 'Midna') '20251120_113003.jpg' $resImgDir 'midna-3.jpg'
    Import-Photo (Join-Path $dump 'Midna') '20260323_122523.jpg' $resImgDir 'midna-4.jpg'
    Import-Photo (Join-Path $dump 'Midna') '20251206_121852.jpg' $resImgDir 'midna-5.jpg'

    # Charlie (memorial — the namesake)
    Import-Photo (Join-Path $dump 'Charlie') '20211008_181502.jpg' $resImgDir 'charlie-1.jpg'
    Import-Photo (Join-Path $dump 'Charlie') '20211008_181522.jpg' $resImgDir 'charlie-2.jpg'
    Import-Photo (Join-Path $dump 'Charlie') '20210820_184620.jpg' $resImgDir 'charlie-3.jpg'
    Import-Photo (Join-Path $dump 'Charlie') '20221109_181424.jpg' $resImgDir 'charlie-4.jpg'
    Import-Photo (Join-Path $dump 'Charlie') '20210921_1347251.jpg' $resImgDir 'charlie-5.jpg'

    # Molson (memorial)
    Import-Photo (Join-Path $dump 'Molson') '20211028_141556.jpg' $resImgDir 'molson-1.jpg'
    Import-Photo (Join-Path $dump 'Molson') '20201104_150650.jpg' $resImgDir 'molson-2.jpg'
    Import-Photo (Join-Path $dump 'Molson') '20230411_131516.jpg' $resImgDir 'molson-3.jpg'
    Import-Photo (Join-Path $dump 'Molson') '20240617_113214.jpg' $resImgDir 'molson-4.jpg'

    # Lily
    Import-Photo (Join-Path $dump 'Lily') '20260417_153231.jpg' $resImgDir 'lily-1.jpg'
    Import-Photo (Join-Path $dump 'Lily') '20250704_102118.jpg' $resImgDir 'lily-2.jpg'
    Import-Photo (Join-Path $dump 'Lily') '20260408_164250.jpg' $resImgDir 'lily-3.jpg'
    Import-Photo (Join-Path $dump 'Lily') '20260420_080712.jpg' $resImgDir 'lily-4.jpg'

    # Oliver
    Import-Photo (Join-Path $dump 'Oliver') '20260126_124944.jpg' $resImgDir 'oliver-1.jpg'
    Import-Photo (Join-Path $dump 'Oliver') '20240117_134449.jpg' $resImgDir 'oliver-2.jpg'
    Import-Photo (Join-Path $dump 'Oliver') '20250422_164218.jpg' $resImgDir 'oliver-3.jpg'
    Import-Photo (Join-Path $dump 'Oliver') '20230129_164307.jpg' $resImgDir 'oliver-4.jpg'

    # Homepage hero: Charlie's pasture under autumn trees
    Import-Photo (Join-Path $dump 'Charlie') '20221021_161920.jpg' $heroDir 'charlie-pasture.jpg'

    # About page portrait: developer-owned copy (static pages must never import
    # from CMS-managed media folders — an owner edit could break the build)
    $aboutDir = Join-Path $root 'src\assets\about'
    New-Item -ItemType Directory -Force -Path $aboutDir | Out-Null
    Import-Photo (Join-Path $dump 'Charlie') '20211008_181502.jpg' $aboutDir 'charlie-portrait.jpg'

    # Photo-highlights strip seeds (owner curates via /admin from here on)
    Import-Photo (Join-Path $dump 'Ash') '20260322_110449.jpg' $hlImgDir 'ash-midna-cuddle.jpg'
    Import-Photo (Join-Path $dump 'Charlie') '20221021_161920.jpg' $hlImgDir 'charlie-autumn.jpg'
    Import-Photo (Join-Path $dump 'Molson') '20211028_141556.jpg' $hlImgDir 'molson-autumn.jpg'
    Import-Photo (Join-Path $dump 'Lily') '20260408_164250.jpg' $hlImgDir 'lily-sunroll.jpg'
    Import-Photo (Join-Path $dump 'Oliver') '20260126_124944.jpg' $hlImgDir 'oliver-portrait.jpg'
    Import-Photo (Join-Path $dump 'Midna') '20260423_094806.jpg' $hlImgDir 'midna-stretch.jpg'

    Write-Output '2026-07-08 drop imported: residents, hero, highlights'
}
else {
    Write-Output '_incoming drop not found - skipping 2026-07-08 import (outputs already committed)'
}
