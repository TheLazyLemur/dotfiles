# LLM Task: Comprehensive PR Review Using GitHub CLI

## Your Mission
You are tasked with conducting a thorough, in-depth review of a Pull Request using GitHub CLI tools and **outputting a comprehensive written review**. **Being slightly nitpicky is a good thing** - catch issues early to prevent technical debt and maintain code quality.

**CRITICAL**: You must NOT approve, request changes, or merge the PR. Your role is to analyze and document findings in a detailed review report only.

## Task Checklist
Use this checklist to track your progress through the review:

- [ ] **Step 1**: Find and identify the target PR
- [ ] **Step 2**: Gather PR overview and context
- [ ] **Step 3**: Verify CI/CD pipeline status
- [ ] **Step 4**: Catalog all changed files
- [ ] **Step 5**: Perform detailed code review
- [ ] **Step 6**: Set up local testing environment
- [ ] **Step 7**: Execute automated tests and builds
- [ ] **Step 8**: Conduct manual feature testing
- [ ] **Step 9**: Analyze commit structure and messages
- [ ] **Step 10**: Compile comprehensive review findings
- [ ] **Step 11**: Document specific technical observations
- [ ] **Step 12**: Generate final review report
- [ ] **Step 13**: Clean up local environment

**Note**: Steps 10-12 focus on documentation and analysis only - no PR actions are taken.

## Detailed Review Protocol

## Step 1: Find the PR to Review
```bash
gh pr list
```
- Look through the list of open PRs
- Note the PR number you want to review

## Step 2: Get PR Overview
```bash
gh pr view 123
```
- Replace `123` with your PR number
- Read the title, description, and basic details
- Note the author and branch names

## Step 3: Check CI/CD Status
```bash
gh pr checks 123
```
- Verify all checks are passing
- If any checks failed, investigate why before proceeding

## Step 4: See What Files Changed
```bash
gh pr diff 123 --name-only
```
- Get a list of all modified files
- This helps you understand the scope of changes

### Step 5: Perform Detailed Code Review
**Review Focus**: Scrutinize for logic, style, security, and maintainability issues.

```bash
gh pr diff 123
```
- Read through all the code changes carefully
- Look for logic errors, style inconsistencies, security concerns
- Check for proper error handling and edge cases
- Verify naming conventions and code organization
- For large diffs, you can also use: `gh pr view 123 --web` to open in browser
- **Remember**: Being detail-oriented here saves debugging time later

## Step 6: Check Out the PR Branch Locally
```bash
gh pr checkout 123
```
- This switches your local repository to the PR branch
- Now you can test the changes locally

## Step 7: Run Tests and Build
```bash
# Run whatever commands your project uses:
npm test
npm run lint
npm run build
# or
make test
pytest
# etc.
```
- Verify the code works as expected
- Check that tests pass and builds succeed

## Step 8: Test the Feature Manually
- Run the application locally
- Test the new feature or bug fix
- Try edge cases and error scenarios

## Step 9: Check Commit History
```bash
git log --oneline main..HEAD
```
- Review the commit messages
- Ensure commits are logical and well-organized

### Step 10: Compile Comprehensive Review Findings
**Documentation Focus**: Gather all observations into structured findings.

**DO NOT use these GitHub CLI review commands:**
- ~~`gh pr review 123 --approve`~~ (FORBIDDEN)
- ~~`gh pr review 123 --request-changes`~~ (FORBIDDEN)
- ~~`gh pr review 123 --comment`~~ (FORBIDDEN)

Instead, document your findings in the following categories:
- **Code Quality Issues**
- **Security Concerns**
- **Performance Implications**
- **Testing Gaps**
- **Documentation Needs**
- **Architecture Observations**
- **Style/Convention Issues**

### Step 11: Document Specific Technical Observations
**Guidance**: Don't hesitate to note minor issues - they compound over time.

**DO NOT post comments to GitHub:**
- ~~`gh pr comment 123 --body "..."`~~ (FORBIDDEN)

Instead, catalog specific observations for your review report:
- Line-by-line code issues and suggestions
- Missing error handling patterns
- Performance bottlenecks or inefficiencies
- Security vulnerabilities or data validation gaps
- Inconsistent coding styles or naming conventions
- Missing or inadequate test coverage
- Documentation gaps or unclear comments
- Potential race conditions or concurrency issues

Use `gh pr view 123 --web` only for reference, not for posting comments.

### Step 12: Generate Final Review Report
**Output Requirement**: Create a comprehensive written review document.

Structure your final review report with these sections:

```markdown
# PR Review Report: [PR Title] (#123)

## Executive Summary
- Overall assessment of the PR
- Key findings and recommendations
- Risk level assessment

## Technical Analysis
### Code Quality
- [Detailed findings about code structure, readability, maintainability]

### Security Assessment
- [Security vulnerabilities, data handling issues, authentication concerns]

### Performance Impact
- [Performance implications, potential bottlenecks, optimization opportunities]

### Testing Coverage
- [Test adequacy, missing test cases, test quality assessment]

## Detailed Findings
### Critical Issues
- [High-priority items that must be addressed]

### Moderate Issues
- [Medium-priority improvements]

### Minor Issues & Suggestions
- [Low-priority style, documentation, or optimization suggestions]

## Architectural Considerations
- [Design patterns, code organization, future maintainability]

## Recommendations
- [Prioritized list of actions to take]

## Conclusion
- [Final assessment and next steps]
```

**Remember**: This is your deliverable - a thorough, written analysis without any GitHub actions.

## Step 13: Clean Up
```bash
git checkout main
git pull origin main
```
- Switch back to main branch
- Pull latest changes

## Quick Reference Commands (Information Gathering Only)
- `gh pr view 123` - See PR details
- `gh pr diff 123` - See code changes
- `gh pr checkout 123` - Test locally
- `gh pr checks 123` - Check CI status
- `gh pr view 123 --web` - View in browser (for reference only)

**FORBIDDEN COMMANDS** (Do not use):
- ~~`gh pr review 123 --approve`~~
- ~~`gh pr review 123 --request-changes`~~
- ~~`gh pr review 123 --comment`~~
- ~~`gh pr comment 123 --body "..."`~~
- ~~`gh pr merge 123`~~

## Additional Useful Commands

**View specific file changes:**
```bash
gh pr diff 123 -- path/to/file.js
```

**Get detailed PR information as JSON:**
```bash
gh pr view 123 --json title,body,author,createdAt,updatedAt,headRefName,baseRefName
```

**Check if PR is mergeable:**
```bash
gh pr view 123 --json mergeable,mergeStateStatus
```

**View existing comments and reviews:**
```bash
gh pr view 123 --comments
```

**Compare changes with base branch:**
```bash
git diff main..HEAD --stat
```

## Review Quality Standards

**Mindset**: Embrace being slightly nitpicky - small issues compound into technical debt. Your thorough review:
- Prevents bugs from reaching production
- Maintains code quality standards
- Teaches best practices to team members
- Reduces long-term maintenance costs

**What to scrutinize:**
- Code style and formatting consistency
- Proper error handling and logging
- Security vulnerabilities and data validation
- Performance implications
- Test coverage and quality
- Documentation completeness
- Naming conventions and readability
- Architecture and design patterns

**Your Deliverable**: A comprehensive written review report that documents all findings, observations, and recommendations. This analysis helps stakeholders make informed decisions about the PR without you taking any direct actions on it.

Remember: It's easier to identify issues now through thorough analysis than to fix them later in production!
