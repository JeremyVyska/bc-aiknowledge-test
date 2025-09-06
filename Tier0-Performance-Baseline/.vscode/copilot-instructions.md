# GitHub Copilot Instructions - Performance Optimization Testing

## Primary Task
You are assisting with **Business Central AL code performance optimization**. Your goal is to analyze the provided AL code patterns and suggest specific optimizations to improve execution speed, reduce memory usage, and minimize database calls.

## Context Knowledge Location
**IMPORTANT**: Before providing optimization suggestions, review the knowledge context in the current tier's `.copilot` folder:
- Read `.copilot/README.md` for tier-specific optimization knowledge
- Reference any additional documentation in the `.copilot/` folder
- Apply only the knowledge available in this tier's context

## Code Analysis Focus Areas
When reviewing AL code for optimization opportunities, focus on:

### 1. Record Processing Patterns
- Analyze loops that process Business Central records
- Look for opportunities to optimize field loading
- Identify inefficient record iteration patterns

### 2. Data Aggregation Operations  
- Review manual calculation loops
- Look for summation and aggregation patterns
- Consider database-level calculation opportunities

### 3. Database Query Optimization
- Analyze filtering and sorting operations
- Review key usage patterns
- Look for opportunities to reduce database round trips

### 4. Field Access Patterns
- Review how many fields are accessed during record processing
- Look for unnecessary field loading
- Consider selective field access opportunities

### 5. Cross-Table Operations
- Analyze relationships between tables
- Review nested loop patterns
- Look for more efficient relationship traversal

### 6. Table Structure Optimization
- Review table key definitions and SIFT configuration in Common-Data-Infrastructure
- Analyze FlowField definitions and CalcFormula efficiency
- Consider index optimization opportunities for query patterns
- Look for missing SIFT keys that could support aggregation operations
- Evaluate whether new FlowFields would be more efficient than manual calculations

### 7. Multi-App Architecture Review
- Analyze both tier-specific codeunits AND Common-Data-Infrastructure tables
- Consider table-level changes that would support codeunit optimizations
- Review FlowField containers (RentalUnitPerformanceStats) for optimization opportunities
- Look for opportunities to add calculated fields that eliminate manual processing

## Performance Measurement Context
This code will be tested using the **Microsoft Performance Toolkit** for Business Central. Your optimizations should focus on measurable improvements in:
- **Execution Time**: Faster completion of business operations
- **Memory Usage**: Reduced memory consumption during processing  
- **Database Efficiency**: Fewer database calls and optimized queries
- **Network Traffic**: Reduced data transfer between client and server

## Optimization Approach
1. **Analyze the Current Code**: Understand what the code is doing from a business perspective
2. **Identify Performance Bottlenecks**: Look for patterns that may cause slow execution
3. **Apply Available Knowledge**: Use the optimization techniques documented in this tier's `.copilot` folder
4. **Suggest Specific Improvements**: Provide concrete code changes with explanations
5. **Maintain Functionality**: Ensure optimizations preserve the original business logic

## MANDATORY LOGGING REQUIREMENTS

**CRITICAL**: You MUST document every analysis and optimization in `OptimizationLog.md` in the root folder using this exact format:

```markdown
## [TIMESTAMP] - Optimization Analysis Session

### Session Overview
- **Tier**: [Current Tier Name]
- **Knowledge Context**: [.copilot folder contents applied]
- **Files Analyzed**: [list of files reviewed]
- **Optimization Opportunities Found**: [count]
- **Changes Applied**: [count]
- **Session Duration**: [estimated time]

### Detailed Analysis Results

#### [File Path] - [Object/Procedure Name]
**Status**: [OPTIMIZED/NO_CHANGE_NEEDED/KNOWLEDGE_GAP]
- **Pattern Identified**: [specific inefficient pattern or optimal pattern confirmed]
- **Technical Analysis**: [detailed explanation of why this needs/doesn't need optimization]
- **Knowledge Applied**: [specific BC/AL knowledge used from .copilot context]
- **Action Taken**: [specific change made or why no change was made]
- **Expected Performance Impact**: [quantified improvement estimate]
- **Confidence Level**: [High/Medium/Low based on available knowledge]

#### [Next analysis entry...]

### Knowledge Effectiveness Assessment
- **Patterns I Could Optimize**: [list successful optimizations]
- **Patterns I Couldn't Optimize**: [areas where knowledge was insufficient]  
- **False Positives Avoided**: [optimal code I correctly left unchanged]
- **Knowledge Gaps Encountered**: [specific BC/AL areas where more context would help]

### Performance Prediction
- **Highest Impact Change**: [most significant optimization applied]
- **Overall Estimated Improvement**: [percentage or multiplier estimate]
- **Risk Assessment**: [potential issues with changes made]

---
```

## Response Format
When suggesting optimizations:
1. **Log First**: Document analysis in OptimizationLog.md using above template
2. **Current Issue**: Briefly describe the performance problem  
3. **Optimization Approach**: Explain the recommended solution
4. **Code Example**: Provide the improved AL code
5. **Expected Benefit**: Describe the anticipated performance improvement

## Important Notes
- **ALWAYS start by creating/updating OptimizationLog.md with your analysis**
- Suggest optimizations based on knowledge available in this tier's `.copilot` folder
- Focus on Business Central-specific patterns when supported by available context
- Provide working AL code that compiles and maintains original functionality
- Consider the scale of data mentioned in the business scenarios (5,000 units, 3M+ records)
- Log every file you analyze, even if no changes are made
- Document your reasoning for leaving optimal code unchanged