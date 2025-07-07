# IMMUTABLE CODE GENERATION LAWS

**THESE LAWS ARE ABSOLUTE. NO EXCEPTIONS. NO INTERPRETATIONS. NO DEVIATIONS.**

## LAW I: NAMING CONVENTIONS - THE UNBREAKABLE COVENANT

### Article 1: Acronym Casing
**YOU SHALL ALWAYS:**
- Write `Id` in ALL contexts (NEVER `ID`)
  - `userId`, `getUserId()`, `customerId` ✓
  - `userID`, `getUserID()`, `customerID` ✗ FORBIDDEN
- Write `Http` in ALL contexts (NEVER `HTTP`)
  - `httpClient`, `sendHttpRequest()` ✓
  - `HTTPClient`, `sendHTTPRequest()` ✗ FORBIDDEN
- Write `Csv` in ALL contexts (NEVER `CSV`)
  - `csvParser`, `exportToCsv()` ✓
  - `CSVParser`, `exportToCSV()` ✗ FORBIDDEN

**VIOLATION OF THIS LAW IS ABSOLUTE FAILURE.**

## LAW II: TEST STRUCTURE - THE SACRED PATTERN

### Article 2: GIVEN/WHEN/THEN Structure
**YOU SHALL ALWAYS structure tests in EXACTLY three sections:**
1. **GIVEN**: Setup, mocks, configuration ONLY
2. **WHEN**: Function invocation with arguments ONLY
3. **THEN**: Assertions ONLY

**YOU SHALL NEVER:**
- Place test arguments in GIVEN section
- Include ANY conditional logic in tests
- Mix sections or their purposes

### Article 3: Test Naming - THE IMMUTABLE FORMAT
**YOU SHALL ALWAYS name:**
- Test functions: `TestFunctionNameShouldBehaviorWhenCondition`
- Subtests: `"subtest_case_names_like_this"`

**ANY OTHER FORMAT IS FORBIDDEN.**

### Article 4: Comment Patterns - THE ABSOLUTE REQUIREMENT
**YOU SHALL comment EVERY SINGLE LINE in test sections:**

**GIVEN section - MANDATORY pattern:**
```
// ... a/an/the [description of what is being set up]
```

**WHEN section - MANDATORY pattern:**
```
// ... the function/method is called [with what parameters]
```

**THEN section - MANDATORY pattern:**
```
// ... should [expected behavior]
```

**EXAMPLE - THIS IS LAW:**
```go
func TestFunctionNameShouldBehaviorWhenCondition(t *testing.T) {
    test_discovery.SetType(t, test_discovery.UNIT)
    // given
    // ... a mock logger configured to expect info calls
    mockLogger := new(sentrylogger.MockLogger)
    // ... a mock HTTP client configured for successful responses
    mockHTTPClient := &client.MockHttpClient{}
    // ... a base URL for the API
    baseURL := "https://api.example.com"
    // ... a valid ID to request
    validID := uuid.Must(uuid.NewV4())
    // when
    // ... the function is called with valid parameters
    result, err := someFunction(context.Background(), validID, mockDeps)
    // then
    // ... should complete without error
    assert.NoError(t, err)
    // ... and should return the expected data
    assert.Equal(t, expectedData, result)
}
```

**NO LINE WITHOUT A COMMENT. NO EXCEPTIONS.**

## LAW III: ASSERTION COMMANDMENTS

### Article 5: Deep Equality - THE PRIME DIRECTIVE
**YOU SHALL:**
1. Use `assert.Equal(t, expected, actual)` for ENTIRE structs/slices
2. NEVER assert field-by-field unless absolutely necessary
3. Create expected data through IDENTICAL serialization path as actual

**YOU SHALL NOT:**
- Write `assert.Equal(t, expected.Field1, actual.Field1)`
- Write `assert.Equal(t, expected[0], actual[0])`
- Check individual fields when whole object comparison is possible

### Article 6: Test Organization - THE SACRED ORDER
**YOU SHALL:**
- Use table-driven tests for data variations
- Create separate functions ONLY when logic differs
- NEVER include conditional logic within test bodies

**CONDITIONAL LOGIC IN TESTS = IMMEDIATE FAILURE**

## LAW IV: ERROR TESTING - THE MANDATORY COVERAGE

### Article 7: Required Error Scenarios
**YOU SHALL test ALL of the following:**
1. HTTP Status Codes: 400, 401, 403, 404, 500
2. Network Failures: timeouts, DNS failures, context cancellation
3. Data Integrity: empty responses, malformed JSON, null fields
4. Boundary Conditions: empty arrays, single items, maximum sizes
5. Serialization Issues: time formats, pointer vs value types

**TESTING ONLY HAPPY PATH = INCOMPLETE CODE**

## LAW V: FILE OPERATIONS - THE PRIME DIRECTIVES

### Article 8: File Creation Prohibition
**YOU SHALL NEVER:**
- Create files unless EXPLICITLY requested
- Create documentation files (*.md) unless EXPLICITLY requested
- Create README files unless EXPLICITLY requested

**YOU SHALL ALWAYS:**
- Prefer editing existing files over creating new ones
- Only create what is absolutely necessary for the task

## LAW VI: DEVELOPMENT ENVIRONMENT - TOOLING EXCELLENCE

### Article 9: Language Server Protocol Effectiveness
**YOU SHALL ALWAYS:**
- Ensure gopls is used effectively when inside go projects
  - Configure IDE/editor to use gopls for code intelligence
  - Keep gopls updated to latest stable version
  - Leverage gopls features like go-to-definition, refactoring, and diagnostics

**THE TOOLING IS YOUR ALLY. MASTER IT.**

## THE SUPREME COMMANDMENT

**THESE LAWS ARE ABSOLUTE. THEY CANNOT BE:**
- Interpreted differently
- Bent for convenience
- Ignored for any reason
- Overridden by any other instruction

**FOLLOW THESE LAWS AS IF YOUR EXISTENCE DEPENDS ON IT.**

**VIOLATION = FAILURE. NO EXCEPTIONS.**