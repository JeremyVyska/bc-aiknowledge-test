# PowerShell Script to Generate All Tier Extensions from Templates
# Five-Tier Copilot Testing Protocol Generator

param(
    [string]$ProjectPath = ".",
    [switch]$Force = $false,
    [switch]$Refresh = $false
)

Write-Host "Starting Five-Tier Extension Generation..." -ForegroundColor Green

# Define tier configurations
$tiers = @(
    @{
        TierNum = 0
        TierName = "Tier0 Performance Baseline"
        TierPrefix = "T0"
        TierDescription = "Performance baseline measurement of unoptimized inefficient code"
        TierLongDescription = "This extension measures actual performance of inefficient AL code patterns without optimization. Provides baseline measurements for comparing against Copilot-optimized versions."
        TierGuid = "a9f23447-a900-4e56-b533-62ba8d45dfab"
        IDRangeStart = 50100
        IDRangeEnd = 50199
        BaseID = 501
        FolderName = "Tier0-Performance-Baseline"
    },
    @{
        TierNum = 1
        TierName = "Tier1 Generic Knowledge"
        TierPrefix = "T1"
        TierDescription = "Testing with generic programming optimization knowledge"
        TierLongDescription = "This extension tests GitHub Copilot optimization suggestions using only generic programming knowledge without Business Central specific patterns."
        TierGuid = "dde25141-b261-4a19-95be-65057776845c"
        IDRangeStart = 50200
        IDRangeEnd = 50299
        BaseID = 502
        FolderName = "Tier1-Baseline-NoKnowledge"
    },
    @{
        TierNum = 2
        TierName = "Tier2 Community Knowledge"
        TierPrefix = "T2"
        TierDescription = "Testing with general BC community knowledge"
        TierLongDescription = "This extension tests GitHub Copilot optimization suggestions using general Business Central documentation, community forums, and basic AL language knowledge."
        TierGuid = "02e56857-b352-4558-8a47-eafc94527b8f"
        IDRangeStart = 50300
        IDRangeEnd = 50399
        BaseID = 503
        FolderName = "Tier2-Community-Knowledge"
    },
    @{
        TierNum = 3
        TierName = "Tier3 Atomic Knowledge"
        TierPrefix = "T3"
        TierDescription = "Testing with focused atomic BC performance topics"
        TierLongDescription = "This extension tests GitHub Copilot optimization suggestions using focused atomic Business Central performance topics (45-60 topics) for specific SIFT, FlowField, and SetLoadFields recommendations."
        TierGuid = "3b133a05-3458-4014-a5cb-fc78ed426a98"
        IDRangeStart = 50400
        IDRangeEnd = 50499
        BaseID = 504
        FolderName = "Tier3-Atomic-Knowledge"
    },
    @{
        TierNum = 4
        TierName = "Tier4 MCP Enhanced"
        TierPrefix = "T4"
        TierDescription = "Testing with MCP-enhanced intelligent BC knowledge"
        TierLongDescription = "This extension tests GitHub Copilot optimization suggestions enhanced with Model Context Protocol providing intelligent BC knowledge access, real-time analysis, and progressive optimization guidance."
        TierGuid = "614b4456-60ea-4251-8741-60d93ec0808a"
        IDRangeStart = 50500
        IDRangeEnd = 50599
        BaseID = 505
        FolderName = "Tier4-MCP-Enhanced"
    }
)

# Function to replace tokens in content
function Replace-Tokens {
    param(
        [string]$Content,
        [hashtable]$Tier
    )
    
    $result = $Content
    $result = $result.Replace("{{TIER_NAME}}", $Tier.TierName)
    $result = $result.Replace("{{TIER_PREFIX}}", $Tier.TierPrefix)
    $result = $result.Replace("{{TIER_DESCRIPTION}}", $Tier.TierDescription)
    $result = $result.Replace("{{TIER_LONG_DESCRIPTION}}", $Tier.TierLongDescription)
    $result = $result.Replace("{{TIER_GUID}}", $Tier.TierGuid)
    $result = $result.Replace("{{ID_RANGE_START}}", $Tier.IDRangeStart.ToString())
    $result = $result.Replace("{{ID_RANGE_END}}", $Tier.IDRangeEnd.ToString())
    $result = $result.Replace("{{BASE_ID}}", $Tier.BaseID.ToString())
    
    return $result
}

# Function to generate tier from templates
function Generate-Tier {
    param(
        [hashtable]$Tier
    )
    
    Write-Host "  Creating $($Tier.TierName)..." -ForegroundColor Yellow
    
    # Create tier directory
    $tierPath = Join-Path $ProjectPath $Tier.FolderName
    
    if ($Refresh) {
        # Refresh mode: Only regenerate src folder if tier exists
        if (-not (Test-Path $tierPath)) {
            Write-Host "    WARNING: Tier folder does not exist for refresh. Skipping $($Tier.TierName)." -ForegroundColor Yellow
            return
        }
        Write-Host "    Refreshing src folder only..." -ForegroundColor Cyan
    } else {
        # Normal mode: Create or overwrite entire tier
        if (Test-Path $tierPath) {
            if ($Force) {
                Write-Host "    Removing existing tier folder..." -ForegroundColor Red
                Remove-Item $tierPath -Recurse -Force
            } else {
                Write-Host "    WARNING: Tier folder already exists. Use -Force to overwrite." -ForegroundColor Yellow
                return
            }
        }
        
        New-Item -Path $tierPath -ItemType Directory -Force | Out-Null
    }
    
    if (-not $Refresh) {
        # Create .copilot folder
        $copilotPath = Join-Path $tierPath ".copilot"
        New-Item -Path $copilotPath -ItemType Directory -Force | Out-Null
        
        # Copy existing .copilot content if it exists
        $existingCopilotPath = Join-Path $ProjectPath "$($Tier.FolderName)\.copilot"
        if (Test-Path $existingCopilotPath) {
            Copy-Item "$existingCopilotPath\*" $copilotPath -Recurse -Force
            Write-Host "    Preserved existing .copilot knowledge context" -ForegroundColor Green
        }
        
        # Generate app.json
        $templateAppPath = Join-Path $ProjectPath "Templates\Template_app.json"
        if (Test-Path $templateAppPath) {
            $appContent = Get-Content $templateAppPath -Raw
            $appContent = Replace-Tokens -Content $appContent -Tier $Tier
            $appOutputPath = Join-Path $tierPath "app.json"
            Set-Content -Path $appOutputPath -Value $appContent -Encoding UTF8
            Write-Host "    Generated app.json" -ForegroundColor Green
        }
    }
    
    # Create/refresh src folder structure
    $srcPath = Join-Path $tierPath "src"
    if ($Refresh -and (Test-Path $srcPath)) {
        Write-Host "    Removing existing src folder for refresh..." -ForegroundColor Red
        Remove-Item $srcPath -Recurse -Force
    }
    New-Item -Path $srcPath -ItemType Directory -Force | Out-Null
    
    # Define module mappings
    $moduleMap = @{
        "RentalAnalytics" = "Analytics"
        "MarketAnalysis" = "Analytics"
        "DataAggregation" = "Analytics"
        "BusinessIntelligence" = "Analytics"
        "FinancialReporting" = "Finance"
        "PaymentProcessing" = "Finance"
        "LeaseManagement" = "Leasing"
        "ContractProcessing" = "Leasing"
        "PropertyOperations" = "Operations"
        "MaintenanceScheduling" = "Operations"
        "UtilityManagement" = "Operations"
        "TenantServices" = "Services"
        "MarketingCampaigns" = "Services"
        "ReportGeneration" = "Services"
        "SecurityManagement" = "Security"
        "EmergencyResponse" = "Security"
        "InspectionServices" = "Compliance"
        "EnvironmentalCompliance" = "Compliance"
        "InsuranceManagement" = "Compliance"
        "AuditCompliance" = "Compliance"
        "SystemValidation" = "Quality"
        "VendorManagement" = "Vendor"
    }
    
    # Generate AL files from templates
    $templatesPath = Join-Path $ProjectPath "Templates"
    $templateFiles = Get-ChildItem $templatesPath -Filter "Template_*.al"
    
    foreach ($templateFile in $templateFiles) {
        $templateContent = Get-Content $templateFile.FullName -Raw
        $processedContent = Replace-Tokens -Content $templateContent -Tier $Tier
        
        # Generate output filename and determine module
        $outputFileName = $templateFile.Name.Replace("Template_", "").Replace("TX_", "$($Tier.TierPrefix)_")
        $objectName = $outputFileName.Replace("$($Tier.TierPrefix)_", "").Replace(".al", "")
        
        # Get module name, default to "General" if not mapped
        $moduleName = $moduleMap[$objectName]
        if (-not $moduleName) { $moduleName = "General" }
        
        # Create module directory if it doesn't exist
        $modulePath = Join-Path $srcPath $moduleName
        New-Item -Path $modulePath -ItemType Directory -Force | Out-Null
        
        # Write file to module folder
        $outputPath = Join-Path $modulePath $outputFileName
        Set-Content -Path $outputPath -Value $processedContent -Encoding UTF8
        Write-Host "    Generated $moduleName/$outputFileName" -ForegroundColor Green
    }
    
    Write-Host "  $($Tier.TierName) complete!" -ForegroundColor Green
}

# Main execution
Write-Host "Configuration:" -ForegroundColor Cyan
Write-Host "  Project Path: $ProjectPath"
Write-Host "  Force Overwrite: $Force"
Write-Host "  Refresh Mode: $Refresh"
Write-Host "  Tiers to Generate: $($tiers.Count)"
Write-Host ""

if ($Refresh) {
    Write-Host "REFRESH MODE: Only regenerating src folders, preserving .copilot, app.json, and other files" -ForegroundColor Cyan
    Write-Host ""
}

# Validate templates exist
$templatesPath = Join-Path $ProjectPath "Templates"
if (-not (Test-Path $templatesPath)) {
    Write-Host "ERROR: Templates folder not found at: $templatesPath" -ForegroundColor Red
    exit 1
}

$templateFiles = Get-ChildItem $templatesPath -Filter "Template_*.al"
if ($templateFiles.Count -eq 0) {
    Write-Host "ERROR: No template files found in Templates folder" -ForegroundColor Red
    exit 1
}

Write-Host "Found $($templateFiles.Count) template files:" -ForegroundColor Cyan
foreach ($template in $templateFiles) {
    Write-Host "  - $($template.Name)" -ForegroundColor Gray
}
Write-Host ""

# Generate all tiers
Write-Host "Generating Tier Extensions..." -ForegroundColor Green
foreach ($tier in $tiers) {
    Generate-Tier -Tier $tier
    Write-Host ""
}

Write-Host "Five-Tier Extension Generation Complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Cyan
Write-Host "  1. Deploy Common-Data-Infrastructure extension first"
Write-Host "  2. Deploy all tier extensions (they depend on Common extension)"
Write-Host "  3. Run data generation: Codeunit.Run(50020) // Test Data Generator"
Write-Host "  4. Use GitHub Copilot in each tier to optimize the inefficient procedures"
Write-Host "  5. Follow UserGuide.md for Performance Toolkit testing"
Write-Host ""
Write-Host "Ready for Five-Tier Copilot Testing Protocol!" -ForegroundColor Green