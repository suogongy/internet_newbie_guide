# 查找所有的md文件（排除README.md）
$files = Get-ChildItem -Recurse -Filter "*.md" | Where-Object { $_.Name -ne "README.md" }

$totalWords = 0
$totalChars = 0
$totalFiles = $files.Count
$chapterStats = @{}

Write-Host "开始统计项目中的Markdown文档字数..."
Write-Host "---------------------------------------------"

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw
    
    # 章节目录提取
    $chapterName = $file.Directory.Name
    
    # 移除Markdown标记以便更准确地计算字数
    $plainText = $content -replace '```.*?```', '' -replace '\[.*?\]\(.*?\)', '' -replace '#', '' -replace '\*\*', '' -replace '\*', '' -replace '\|', ' '
    
    # 统计字数（中文每个字符算一个字，英文以空格分隔计算）
    $charCount = $plainText.Length
    $wordCount = ($plainText -split '\s+' | Where-Object { $_ -ne '' }).Count
    
    $totalChars += $charCount
    $totalWords += $wordCount
    
    # 累加章节统计
    if ($chapterStats.ContainsKey($chapterName)) {
        $chapterStats[$chapterName].Files += 1
        $chapterStats[$chapterName].Words += $wordCount
        $chapterStats[$chapterName].Chars += $charCount
    } else {
        $chapterStats[$chapterName] = @{
            Files = 1
            Words = $wordCount
            Chars = $charCount
        }
    }
    
    Write-Host "已处理: $($file.FullName) - $wordCount 词 / $charCount 字符"
}

Write-Host "---------------------------------------------"
Write-Host "各章节统计:"
Write-Host "---------------------------------------------"

$sortedChapters = $chapterStats.GetEnumerator() | Sort-Object Name
foreach ($chapter in $sortedChapters) {
    Write-Host "$($chapter.Name): $($chapter.Value.Files)个文件, $($chapter.Value.Words)词, $($chapter.Value.Chars)字符"
}

Write-Host "---------------------------------------------"
Write-Host "总计:"
Write-Host "总文件数: $totalFiles"
Write-Host "总词数: $totalWords"
Write-Host "总字符数: $totalChars"
Write-Host "---------------------------------------------" 