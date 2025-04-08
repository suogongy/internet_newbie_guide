# 查找所有的md文件（排除README.md）
$files = Get-ChildItem -Recurse -Filter "*.md" | Where-Object { $_.Name -ne "README.md" }

$totalWords = 0
$totalChineseChars = 0
$totalEnglishWords = 0
$totalFiles = $files.Count

Write-Host "开始统计项目中的Markdown文档字数..."

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw
    
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
}

# 计算百分比
$chinesePercentage = [math]::Round(($totalChineseChars / $totalWords) * 100, 2)
$englishPercentage = [math]::Round(($totalEnglishWords / $totalWords) * 100, 2)

# 输出统计结果
Write-Host "================================================="
Write-Host "               项目字数统计                       "
Write-Host "================================================="
Write-Host "总文件数: $totalFiles"
Write-Host "总字数: $totalWords"
Write-Host "中文字符: $totalChineseChars ($chinesePercentage%)"
Write-Host "英文单词: $totalEnglishWords ($englishPercentage%)"
Write-Host "================================================="

# 如果需要更详细的统计，可以使用以下命令：
Write-Host "提示: 运行 .\count_words_cn.ps1 获取详细统计"
Write-Host "提示: 运行 .\generate_report.ps1 生成HTML报告" 