# 读取CSV文件
$stats = Import-Csv -Path "word_count_stats.csv" -Encoding UTF8

# 计算总计
$totalFiles = $stats.Count
$totalWords = ($stats | Measure-Object -Property Words -Sum).Sum
$totalChineseChars = ($stats | Measure-Object -Property ChineseChars -Sum).Sum
$totalEnglishWords = ($stats | Measure-Object -Property EnglishWords -Sum).Sum

# 按章节分组
$chapterStats = $stats | Group-Object { $_.RelativePath.Split('\')[0] } | 
    ForEach-Object {
        $chapterName = $_.Name
        $files = $_.Group.Count
        $words = ($_.Group | Measure-Object -Property Words -Sum).Sum
        $chineseChars = ($_.Group | Measure-Object -Property ChineseChars -Sum).Sum
        $englishWords = ($_.Group | Measure-Object -Property EnglishWords -Sum).Sum
        
        [PSCustomObject]@{
            Chapter = $chapterName
            Files = $files
            Words = $words
            ChineseChars = $chineseChars
            EnglishWords = $englishWords
        }
    } | Sort-Object { [regex]::Replace($_.Chapter, 'chapter(\d+)', '$1') -as [int] }

# 获取字数最多的10个文件
$top10Files = $stats | Sort-Object { [int]$_.Words } -Descending | Select-Object -First 10

# 生成百分比
$chinesePercentage = [math]::Round(($totalChineseChars / $totalWords) * 100, 2)
$englishPercentage = [math]::Round(($totalEnglishWords / $totalWords) * 100, 2)

# 生成HTML报告
$reportHtml = @"
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>项目字数统计报告</title>
    <style>
        body {
            font-family: 'Microsoft YaHei', '微软雅黑', Arial, sans-serif;
            line-height: 1.6;
            color: #333;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        h1, h2 {
            color: #2c3e50;
            border-bottom: 2px solid #eee;
            padding-bottom: 10px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
            background-color: white;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #4CAF50;
            color: white;
        }
        tr:hover {
            background-color: #f5f5f5;
        }
        .summary-box {
            background-color: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .summary-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }
        .summary-item {
            background-color: #e8f5e9;
            padding: 20px;
            border-radius: 5px;
            text-align: center;
        }
        .summary-item h3 {
            color: #2c3e50;
            margin-top: 0;
        }
        .summary-value {
            font-size: 2em;
            color: #4CAF50;
            font-weight: bold;
        }
        .progress-container {
            height: 20px;
            background-color: #e0e0e0;
            border-radius: 10px;
            margin-top: 5px;
        }
        .progress-bar {
            height: 100%;
            background-color: #4CAF50;
            border-radius: 10px;
        }
        .chart-container {
            max-width: 800px;
            margin: 0 auto;
            background-color: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <h1>项目字数统计报告</h1>
    
    <div class="summary-box">
        <h2>总体统计</h2>
        <div class="summary-grid">
            <div class="summary-item">
                <h3>总文件数</h3>
                <div class="summary-value">$totalFiles</div>
            </div>
            <div class="summary-item">
                <h3>总字数</h3>
                <div class="summary-value">$totalWords</div>
            </div>
            <div class="summary-item">
                <h3>中文字符</h3>
                <div class="summary-value">$totalChineseChars</div>
                <div class="progress-container">
                    <div class="progress-bar" style="width: $chinesePercentage%;"></div>
                </div>
                <div>$chinesePercentage%</div>
            </div>
            <div class="summary-item">
                <h3>英文单词</h3>
                <div class="summary-value">$totalEnglishWords</div>
                <div class="progress-container">
                    <div class="progress-bar" style="width: $englishPercentage%;"></div>
                </div>
                <div>$englishPercentage%</div>
            </div>
        </div>
    </div>

    <div class="chart-container">
        <h2>章节统计</h2>
        <table>
            <thead>
                <tr>
                    <th>序号</th>
                    <th>章节</th>
                    <th>文件数</th>
                    <th>总字数</th>
                    <th>中文字符</th>
                    <th>英文单词</th>
                </tr>
            </thead>
            <tbody>
$(
    $index = 1
    foreach ($chapter in $chapterStats) {
        "                <tr>
                    <td>$index</td>
                    <td>$($chapter.Chapter)</td>
                    <td>$($chapter.Files)</td>
                    <td>$($chapter.Words)</td>
                    <td>$($chapter.ChineseChars)</td>
                    <td>$($chapter.EnglishWords)</td>
                </tr>"
        $index++
    }
)
            </tbody>
        </table>
    </div>

    <div class="chart-container">
        <h2>章节字数排名</h2>
        <table>
            <thead>
                <tr>
                    <th>排名</th>
                    <th>章节</th>
                    <th>总字数</th>
                    <th>占总字数比例</th>
                </tr>
            </thead>
            <tbody>
$(
    $index = 1
    foreach ($chapter in ($chapterStats | Sort-Object Words -Descending)) {
        $percentage = [math]::Round(($chapter.Words / $totalWords) * 100, 2)
        "                <tr>
                    <td>$index</td>
                    <td>$($chapter.Chapter)</td>
                    <td>$($chapter.Words)</td>
                    <td>${percentage}%</td>
                </tr>"
        $index++
    }
)
            </tbody>
        </table>
    </div>

    <div class="chart-container">
        <h2>字数最多的10个文件</h2>
        <table>
            <thead>
                <tr>
                    <th>排名</th>
                    <th>文件</th>
                    <th>总字数</th>
                    <th>中文字符</th>
                    <th>英文单词</th>
                </tr>
            </thead>
            <tbody>
$(
    $index = 1
    foreach ($file in $top10Files) {
        "                <tr>
                    <td>$index</td>
                    <td>$($file.RelativePath)</td>
                    <td>$($file.Words)</td>
                    <td>$($file.ChineseChars)</td>
                    <td>$($file.EnglishWords)</td>
                </tr>"
        $index++
    }
)
            </tbody>
        </table>
    </div>

    <footer>
        <p>报告生成时间: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")</p>
    </footer>
</body>
</html>
"@

# 保存HTML报告
$reportHtml | Out-File -FilePath "word_count_report.html" -Encoding UTF8

Write-Host "HTML报告已生成: word_count_report.html"

# 尝试自动打开报告
try {
    Start-Process "word_count_report.html"
} catch {
    Write-Host "无法自动打开报告，请手动打开 word_count_report.html 文件"
} 