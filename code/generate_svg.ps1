# PowerShell script to generate basic SVG from Graphviz DOT files
# Generates SVG files from TraceyGraph/*.dot and places them in traceygraphs/trajecto/

param(
    [string]$DotDir = "build\trajecto\TraceyGraph",
    [string]$SvgDir = "traceygraphs\trajecto"
)

$graphs = @("avsa", "avsall", "refvsref", "allvsr", "allvsall")

# Color map for SVG (CSS named colors used in dot files)
$colorMap = @{
    "mistyrose"       = "#FFE4E1"
    "paleturquoise1"  = "#BBFFFF"
    "pink"            = "#FFC0CB"
    "palegreen"       = "#98FB98"
    "khaki1"          = "#FFFF87"
    "ivory"           = "#FFFFF0"
    "darkgoldenrod1"  = "#FFB90F"
    "lavender"        = "#E6E6FA"
    "lightblue"       = "#ADD8E6"
}

function Get-SVGColor($color) {
    if ($colorMap.ContainsKey($color)) { return $colorMap[$color] }
    return "#FFFFFF"
}

function ConvertDotToSVG($dotFile, $svgFile) {
    $content = Get-Content $dotFile -Raw

    # Parse nodes: id [shape=box, ..., fillcolor=COLOR, label="LABEL"]
    $nodePattern = '(\S+)\s+\[shape=box[^\]]*fillcolor=(\w+)[^\]]*label="([^"]+)"\]'
    $nodes = @{}
    foreach ($match in [regex]::Matches($content, $nodePattern)) {
        $id = $match.Groups[1].Value
        $color = $match.Groups[2].Value
        $label = $match.Groups[3].Value
        $nodes[$id] = @{ id = $id; color = $color; label = $label; group = "" }
    }

    # Parse subgraphs to assign group names
    $subgraphPattern = 'subgraph (\w+) \{[^}]*\{([^}]+)\}'
    foreach ($match in [regex]::Matches($content, $subgraphPattern, [System.Text.RegularExpressions.RegexOptions]::Singleline)) {
        $groupName = $match.Groups[1].Value
        $members = $match.Groups[2].Value -split ',' | ForEach-Object { $_.Trim() }
        foreach ($m in $members) {
            if ($nodes.ContainsKey($m)) {
                $nodes[$m].group = $groupName
            }
        }
    }

    # Parse edges: id -> id;
    $edgePattern = '(\S+)\s+->\s+(\S+);'
    $edges = @()
    foreach ($match in [regex]::Matches($content, $edgePattern)) {
        $edges += @{ from = $match.Groups[1].Value; to = $match.Groups[2].Value }
    }

    # Group nodes by their subgraph
    $groups = @{}
    foreach ($node in $nodes.Values) {
        $g = $node.group
        if (-not $g) { $g = "Other" }
        if (-not $groups.ContainsKey($g)) { $groups[$g] = @() }
        $groups[$g] += $node
    }

    # Layout parameters
    $nodeW = 160
    $nodeH = 30
    $padX = 20
    $padY = 15
    $colW = $nodeW + $padX * 2
    $rowH = $nodeH + $padY

    # Assign positions: one column per group
    $colIndex = 0
    $nodePos = @{}
    $groupOrder = $groups.Keys | Sort-Object
    foreach ($gName in $groupOrder) {
        $rowIndex = 0
        foreach ($node in $groups[$gName]) {
            $x = $colIndex * $colW + $padX
            $y = $rowIndex * $rowH + $padY + 40  # leave room for title
            $nodePos[$node.id] = @{ x = $x; y = $y; w = $nodeW; h = $nodeH; label = $node.label; color = $node.color }
            $rowIndex++
        }
        $colIndex++
    }

    # Calculate SVG dimensions
    $maxX = 0
    $maxY = 0
    foreach ($pos in $nodePos.Values) {
        $right = $pos.x + $pos.w + $padX
        $bottom = $pos.y + $pos.h + $padY
        if ($right -gt $maxX) { $maxX = $right }
        if ($bottom -gt $maxY) { $maxY = $bottom }
    }
    if ($maxX -lt 400) { $maxX = 400 }
    if ($maxY -lt 200) { $maxY = 200 }

    # Generate SVG
    $svgLines = @()
    $svgLines += "<?xml version=`"1.0`" encoding=`"UTF-8`"?>"
    $svgLines += "<svg xmlns=`"http://www.w3.org/2000/svg`" width=`"$maxX`" height=`"$maxY`" viewBox=`"0 0 $maxX $maxY`">"
    $svgLines += "  <defs>"
    $svgLines += "    <marker id=`"arrow`" markerWidth=`"10`" markerHeight=`"7`" refX=`"10`" refY=`"3.5`" orient=`"auto`">"
    $svgLines += "      <polygon points=`"0 0, 10 3.5, 0 7`" fill=`"#333`" />"
    $svgLines += "    </marker>"
    $svgLines += "  </defs>"
    $svgLines += "  <rect width=`"$maxX`" height=`"$maxY`" fill=`"white`" />"

    # Draw edges first (behind nodes)
    foreach ($edge in $edges) {
        $from = $edge.from
        $to = $edge.to
        if ($nodePos.ContainsKey($from) -and $nodePos.ContainsKey($to)) {
            $fp = $nodePos[$from]
            $tp = $nodePos[$to]
            $x1 = $fp.x + $fp.w
            $y1 = $fp.y + $fp.h / 2
            $x2 = $tp.x
            $y2 = $tp.y + $tp.h / 2
            # Simple horizontal/vertical routing
            $mx = ($x1 + $x2) / 2
            $svgLines += "  <polyline points=`"$x1,$y1 $mx,$y1 $mx,$y2 $x2,$y2`" fill=`"none`" stroke=`"#333`" stroke-width=`"1`" marker-end=`"url(#arrow)`" />"
        }
    }

    # Draw nodes
    foreach ($id in $nodePos.Keys) {
        $pos = $nodePos[$id]
        $fillColor = Get-SVGColor $pos.color
        $x = $pos.x; $y = $pos.y; $w = $pos.w; $h = $pos.h
        $label = [System.Web.HttpUtility]::HtmlEncode($pos.label)
        $cx = $x + $w / 2
        $cy = $y + $h / 2
        $svgLines += "  <rect x=`"$x`" y=`"$y`" width=`"$w`" height=`"$h`" fill=`"$fillColor`" stroke=`"black`" stroke-width=`"1`" />"
        $svgLines += "  <text x=`"$cx`" y=`"$($cy + 4)`" text-anchor=`"middle`" font-family=`"sans-serif`" font-size=`"11`">$label</text>"
    }

    $svgLines += "</svg>"
    $svgLines | Out-File -FilePath $svgFile -Encoding UTF8
    Write-Host "Generated: $svgFile"
}

# Ensure output directory exists
New-Item -ItemType Directory -Force -Path $SvgDir | Out-Null

# Load System.Web for HtmlEncode
Add-Type -AssemblyName System.Web

# Generate each graph
foreach ($graph in $graphs) {
    $dotFile = Join-Path $DotDir "$graph.dot"
    $svgFile = Join-Path $SvgDir "$graph.svg"
    if (Test-Path $dotFile) {
        ConvertDotToSVG $dotFile $svgFile
    } else {
        Write-Host "DOT file not found: $dotFile"
    }
}

Write-Host "Done."
