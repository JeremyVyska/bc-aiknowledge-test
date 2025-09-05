# PowerShell Script to Analyze Optimization Logs Across All Tiers
# Five-Tier Copilot Testing Protocol - Log Analysis Helper

param(
    [string]$ProjectPath = ".",
    [switch]$GenerateReport = $false,
    [switch]$CompareAnswerKey = $false
)

Write-Host "Analyzing Optimization Logs Across All Tiers..." -ForegroundColor Green

# Define tier information
$tiers = @(
    @{ Name = "Tier0-Performance-Baseline"; DisplayName = "Tier 0 (Baseline)" },
    @{ Name = "Tier1-Baseline-NoKnowledge"; DisplayName = "Tier 1 (Generic)" },
    @{ Name = "Tier2-Community-Knowledge"; DisplayName = "Tier 2 (Community)" },
    @{ Name = "Tier3-Atomic-Knowledge"; DisplayName = "Tier 3 (Atomic)" },
    @{ Name = "Tier4-MCP-Enhanced"; DisplayName = "Tier 4 (MCP)" }
)

# Analysis results storage
$analysisResults = @()

foreach ($tier in $tiers) {
    $tierPath = Join-Path $ProjectPath $tier.Name
    $logPath = Join-Path $tierPath "OptimizationLog.md"
    
    if (Test-Path $logPath) {
        Write-Host "  Analyzing $($tier.DisplayName)..." -ForegroundColor Yellow
        
        $logContent = Get-Content $logPath -Raw
        
        # Extract key metrics from log
        $result = @{
            Tier = $tier.DisplayName
            TierFolder = $tier.Name
            HasLog = $true
            FilesAnalyzed = 0
            OptimizationsFound = 0
            ChangesApplied = 0
            HighImpactChanges = 0
            KnowledgeGaps = 0
            FalsePositivesAvoided = 0
            SessionCount = 0
        }
        
        # Parse session count
        $sessions = ([regex]::Matches($logContent, "## .* - Optimization Analysis Session")).Count
        $result.SessionCount = $sessions
        
        # Extract metrics using regex patterns
        $filesAnalyzedMatches = [regex]::Matches($logContent, "Files Analyzed.*?(\d+)")
        $result.FilesAnalyzed = ($filesAnalyzedMatches | ForEach-Object { [int]$_.Groups[1].Value } | Measure-Object -Sum).Sum
        
        $optimizationsFoundMatches = [regex]::Matches($logContent, "Optimization Opportunities Found.*?(\d+)")
        $result.OptimizationsFound = ($optimizationsFoundMatches | ForEach-Object { [int]$_.Groups[1].Value } | Measure-Object -Sum).Sum
        
        $changesAppliedMatches = [regex]::Matches($logContent, "Changes Applied.*?(\d+)")  
        $result.ChangesApplied = ($changesAppliedMatches | ForEach-Object { [int]$_.Groups[1].Value } | Measure-Object -Sum).Sum
        
        # Count OPTIMIZED vs NO_CHANGE_NEEDED entries
        $optimizedCount = ([regex]::Matches($logContent, "Status.*?OPTIMIZED")).Count
        $noChangeCount = ([regex]::Matches($logContent, "Status.*?NO_CHANGE_NEEDED")).Count
        $knowledgeGapCount = ([regex]::Matches($logContent, "Status.*?KNOWLEDGE_GAP")).Count
        
        $result.HighImpactChanges = $optimizedCount
        $result.FalsePositivesAvoided = $noChangeCount
        $result.KnowledgeGaps = $knowledgeGapCount
        
        $analysisResults += $result
    } else {
        Write-Host "    No log found for $($tier.DisplayName)" -ForegroundColor Red
        $analysisResults += @{
            Tier = $tier.DisplayName
            TierFolder = $tier.Name
            HasLog = $false
            FilesAnalyzed = 0
            OptimizationsFound = 0
            ChangesApplied = 0
            HighImpactChanges = 0
            KnowledgeGaps = 0
            FalsePositivesAvoided = 0
            SessionCount = 0
        }
    }
}

# Display Summary Table
Write-Host ""
Write-Host "OPTIMIZATION ANALYSIS SUMMARY" -ForegroundColor Cyan
Write-Host "=============================" -ForegroundColor Cyan
Write-Host ""

$table = $analysisResults | Format-Table -Property `
    @{Label="Tier"; Expression={$_.Tier}; Width=20},
    @{Label="Sessions"; Expression={$_.SessionCount}; Width=8},
    @{Label="Files"; Expression={$_.FilesAnalyzed}; Width=6}, 
    @{Label="Found"; Expression={$_.OptimizationsFound}; Width=6},
    @{Label="Applied"; Expression={$_.ChangesApplied}; Width=7},
    @{Label="High Impact"; Expression={$_.HighImpactChanges}; Width=11},
    @{Label="False Pos Avoided"; Expression={$_.FalsePositivesAvoided}; Width=16},
    @{Label="Gaps"; Expression={$_.KnowledgeGaps}; Width=5}

$table

# Calculate effectiveness metrics
Write-Host ""
Write-Host "KNOWLEDGE EFFECTIVENESS ANALYSIS" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan

foreach ($result in $analysisResults) {
    if ($result.HasLog -and $result.OptimizationsFound -gt 0) {
        $successRate = [math]::Round(($result.ChangesApplied / $result.OptimizationsFound) * 100, 1)
        $falsePositiveRate = if ($result.FilesAnalyzed -gt 0) { [math]::Round(($result.FalsePositivesAvoided / $result.FilesAnalyzed) * 100, 1) } else { 0 }
        
        Write-Host ""
        Write-Host "$($result.Tier):" -ForegroundColor Yellow
        Write-Host "  Optimization Success Rate: $successRate%"
        Write-Host "  False Positive Avoidance: $falsePositiveRate%"
        Write-Host "  Knowledge Coverage: $(100 - [math]::Round(($result.KnowledgeGaps / $result.FilesAnalyzed) * 100, 1))%"
    }
}

# Generate detailed report if requested
if ($GenerateReport) {
    $reportPath = Join-Path $ProjectPath "OptimizationAnalysisReport.md"
    Write-Host ""
    Write-Host "Generating detailed report: $reportPath" -ForegroundColor Green
    
    $report = @"
# Five-Tier Copilot Testing Protocol - Optimization Analysis Report

**Generated**: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

## Executive Summary

This report analyzes GitHub Copilot's optimization effectiveness across 5 knowledge tiers.

### Overall Results

"@

    foreach ($result in $analysisResults) {
        $report += @"

#### $($result.Tier)
- **Sessions Completed**: $($result.SessionCount)
- **Files Analyzed**: $($result.FilesAnalyzed)  
- **Optimizations Found**: $($result.OptimizationsFound)
- **Changes Applied**: $($result.ChangesApplied)
- **Knowledge Gaps**: $($result.KnowledgeGaps)

"@
    }

    $report += @"

## Tier Comparison Analysis

### Knowledge Effectiveness Progression
"@

    # Add tier comparison analysis
    for ($i = 1; $i -lt $analysisResults.Count; $i++) {
        $current = $analysisResults[$i]
        $baseline = $analysisResults[0]
        
        if ($current.HasLog -and $baseline.HasLog) {
            $improvementRatio = if ($baseline.ChangesApplied -gt 0) { 
                [math]::Round($current.ChangesApplied / $baseline.ChangesApplied, 2) 
            } else { "N/A" }
            
            $report += @"

**$($current.Tier) vs Baseline**:
- Change Implementation Ratio: ${improvementRatio}x
- Knowledge Gap Reduction: $(($baseline.KnowledgeGaps - $current.KnowledgeGaps)) fewer gaps

"@
        }
    }

    $report += @"

## Detailed Log Contents

"@

    # Include excerpts from each log
    foreach ($tier in $tiers) {
        $tierPath = Join-Path $ProjectPath $tier.Name
        $logPath = Join-Path $tierPath "OptimizationLog.md"
        
        if (Test-Path $logPath) {
            $logContent = Get-Content $logPath -Raw
            $report += @"

### $($tier.DisplayName) Log Summary

``````
$(($logContent -split "`n" | Select-Object -First 50) -join "`n")
``````

"@
        }
    }

    Set-Content -Path $reportPath -Value $report -Encoding UTF8
    Write-Host "Report generated successfully!" -ForegroundColor Green
}

# Answer Key Comparison (if requested)
if ($CompareAnswerKey) {
    Write-Host ""
    Write-Host "ANSWER KEY VALIDATION" -ForegroundColor Cyan
    Write-Host "====================" -ForegroundColor Cyan
    
    # This would compare against the expected optimization targets from UserGuide.md
    # Implementation would parse the answer key and validate against actual changes
    Write-Host "Answer key comparison feature - implement based on specific validation needs" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Analysis Complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Cyan
Write-Host "1. Review individual tier logs for detailed optimization decisions"
Write-Host "2. Compare with Performance Toolkit results for validation"
Write-Host "3. Use -GenerateReport switch for comprehensive markdown report"
Write-Host "4. Analyze knowledge effectiveness patterns across tiers"