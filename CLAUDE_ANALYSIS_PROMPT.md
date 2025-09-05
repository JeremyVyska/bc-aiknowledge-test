# Quick Start Prompt for Claude Analysis Session

## Context Setup
```
I need your help analyzing the results of a Five-Tier Copilot Testing Protocol experiment. 

This project scientifically measured whether atomic Business Central knowledge improves GitHub Copilot's AL code optimization across 5 tiers:
- Tier 0: Baseline (unoptimized)  
- Tier 1: Generic programming knowledge
- Tier 2: BC community knowledge
- Tier 3: Atomic BC knowledge (key hypothesis)
- Tier 4: MCP-enhanced knowledge

Please read ANALYSIS_CONTEXT.md first for complete background, then help me analyze the results.
```

## Key Files to Reference
1. **ANALYSIS_CONTEXT.md** - Complete project background and analysis framework
2. **UserGuide.md** - Answer key with expected optimizations (🟢🟡🔴🚫 classifications)
3. **Tier*/OptimizationLog.md** - Copilot's logged decisions per tier
4. **Performance Toolkit Results** - Quantified performance measurements
5. **README.md** - Project architecture overview

## Primary Analysis Goals
1. **Validate Core Hypothesis**: Did Tier 3 (atomic knowledge) significantly outperform Tier 2?
2. **ROI Decision Support**: Is atomic knowledge pipeline investment justified?
3. **Pattern Effectiveness**: Which BC optimizations benefited most from atomic knowledge?
4. **Quality Assessment**: How accurate were optimization decisions vs answer key?

## Analysis Approach
1. **Run Log Analysis**: Execute `AnalyzeOptimizationLogs.ps1 -GenerateReport` if not done
2. **Cross-Reference Answer Key**: Compare logged decisions against expected optimizations
3. **Performance Correlation**: Match optimization quality to measured improvements  
4. **Strategic Recommendations**: Provide clear business decision guidance

## Expected Deliverables
- Performance improvement analysis across tiers
- Optimization accuracy assessment (true/false positives)
- Knowledge effectiveness patterns identification
- Clear ROI recommendation with supporting data
- Next steps guidance for pipeline decision

This framework represents a significant investment decision - focus on strategic business insights rather than just technical details.

---
**Quick Start**: Read ANALYSIS_CONTEXT.md, then ask what specific analysis you'd like me to focus on first.