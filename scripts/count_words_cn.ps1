# 查找所有的md文件（排除README.md）
$files = Get-ChildItem -Recurse -Filter "*.md" | Where-Object { $_.Name -ne "README.md" }

$totalWords = 0
$totalChineseChars = 0
$totalEnglishWords = 0
$totalFiles = $files.Count
$chapterStats = @{}
$fileStats = @()

Write-Host "开始统计项目中的Markdown文档字数..."
Write-Host "---------------------------------------------"

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw
    
    # 章节目录提取
    $chapterName = $file.Directory.Name
    
    # 移除Markdown标记以便更准确地计算字数
    $plainText = $content -replace '```.*?```', '' `
                          -replace '\[.*?\]\(.*?\)', '' `
                          -replace '#', '' `
                          -replace '\*\*', '' `
                          -replace '\*', '' `
                          -replace '\|', ' ' `
                          -replace '^\s+', '' `
                          -replace '\s+$', ''
    
    # 统计中文字符数（使用正则表达式匹配中文字符）
    $chineseChars = [regex]::Matches($plainText, "[\u4e00-\u9fff]").Count
    
    # 统计英文单词数（将文本按空格分割，移除空项）
    $englishText = $plainText -replace "[\u4e00-\u9fff]", " "
    $englishWords = ($englishText -split '\s+' | Where-Object { $_ -ne '' -and $_ -match '[a-zA-Z]' }).Count
    
    # 总字数（中文字符 + 英文单词）
    $wordCount = $chineseChars + $englishWords
    
    $totalChineseChars += $chineseChars
    $totalEnglishWords += $englishWords
    $totalWords += $wordCount
    
    # 文件相对路径
    $relativePath = $file.FullName.Replace("$((Get-Location).Path)\", "")
    
    # 累加章节统计
    if ($chapterStats.ContainsKey($chapterName)) {
        $chapterStats[$chapterName].Files += 1
        $chapterStats[$chapterName].Words += $wordCount
        $chapterStats[$chapterName].ChineseChars += $chineseChars
        $chapterStats[$chapterName].EnglishWords += $englishWords
    } else {
        $chapterStats[$chapterName] = @{
            Files = 1
            Words = $wordCount
            ChineseChars = $chineseChars
            EnglishWords = $englishWords
        }
    }
    
    # 添加到文件统计数组
    $fileStats += [PSCustomObject]@{
        RelativePath = $relativePath
        Words = $wordCount
        ChineseChars = $chineseChars
        EnglishWords = $englishWords
    }
    
    Write-Host "已处理: $relativePath - 总字数: $wordCount (中文: $chineseChars, 英文: $englishWords)"
}

Write-Host "---------------------------------------------"
Write-Host "各章节统计:"
Write-Host "---------------------------------------------"

$sortedChapters = $chapterStats.GetEnumerator() | Sort-Object { [regex]::Replace($_.Name, 'chapter(\d+)', '$1') -as [int] }
foreach ($chapter in $sortedChapters) {
    Write-Host "$($chapter.Name): $($chapter.Value.Files)个文件, $($chapter.Value.Words)字 (中文: $($chapter.Value.ChineseChars), 英文: $($chapter.Value.EnglishWords))"
}

# 按字数排序章节
$wordRankingChapters = $chapterStats.GetEnumerator() | Sort-Object { $_.Value.Words } -Descending
Write-Host "---------------------------------------------"
Write-Host "章节字数排名:"
Write-Host "---------------------------------------------"
$rank = 1
foreach ($chapter in $wordRankingChapters) {
    Write-Host "$rank. $($chapter.Name): $($chapter.Value.Words)字"
    $rank++
}

# 最长的10个文件
$top10Files = $fileStats | Sort-Object Words -Descending | Select-Object -First 10
Write-Host "---------------------------------------------"
Write-Host "字数最多的10个文件:"
Write-Host "---------------------------------------------"
$rank = 1
foreach ($file in $top10Files) {
    Write-Host "$rank. $($file.RelativePath): $($file.Words)字 (中文: $($file.ChineseChars), 英文: $($file.EnglishWords))"
    $rank++
}

Write-Host "---------------------------------------------"
Write-Host "总计:"
Write-Host "总文件数: $totalFiles"
Write-Host "总字数: $totalWords"
Write-Host "中文字符: $totalChineseChars"
Write-Host "英文单词: $totalEnglishWords"
Write-Host "---------------------------------------------"

# 导出详细统计到CSV
$fileStats | Export-Csv -Path "word_count_stats.csv" -NoTypeInformation -Encoding UTF8
Write-Host "详细统计已导出至 word_count_stats.csv" 