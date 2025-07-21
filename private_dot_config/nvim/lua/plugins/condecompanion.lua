local function load_markdown_files()
    local files = { "CLAUDE.md", "OPENCODE.md", "GEMINI.md", "codemap.md" }
    local working_dir = vim.fn.getcwd()
    local content = ""

    for _, file in ipairs(files) do
        local path = working_dir .. "/" .. file
        if vim.fn.filereadable(path) == 1 then
            local f = io.open(path, "r")
            if f then
                local file_content = f:read("*all")
                f:close()
                content = content .. "\n" .. file_content
                print("✓ Loaded " .. file .. " (" .. #file_content .. " characters)")
            else
                print("✗ Failed to read " .. file)
            end
        else
            print("✗ " .. file .. " not found in working directory")
        end
    end

    return content
end

local function read_prompts()
    local config_dir = require("util").get_config_dir()
    local ai_context_dir = config_dir .. "/ai_context"

    -- Read each file from ai_context directory
    local create_prd_content = ""
    local generate_tasks_content = ""
    local process_task_list_content = ""

    -- Read create-prd.md
    local create_prd_path = ai_context_dir .. "/create-prd.md"
    local create_prd_file = io.open(create_prd_path, "r")
    if create_prd_file then
        create_prd_content = create_prd_file:read("*all")
        create_prd_file:close()
        print("✓ Loaded create-prd.md (" .. #create_prd_content .. " characters)")
    else
        print("✗ Failed to read create-prd.md")
    end

    -- Read generate-tasks.md
    local generate_tasks_path = ai_context_dir .. "/generate-tasks.md"
    local generate_tasks_file = io.open(generate_tasks_path, "r")
    if generate_tasks_file then
        generate_tasks_content = generate_tasks_file:read("*all")
        generate_tasks_file:close()
        print("✓ Loaded generate-tasks.md (" .. #generate_tasks_content .. " characters)")
    else
        print("✗ Failed to read generate-tasks.md")
    end

    -- Read process-task-list.md
    local process_task_list_path = ai_context_dir .. "/process-task-list.md"
    local process_task_list_file = io.open(process_task_list_path, "r")
    if process_task_list_file then
        process_task_list_content = process_task_list_file:read("*all")
        process_task_list_file:close()
        print("✓ Loaded process-task-list.md (" .. #process_task_list_content .. " characters)")
    else
        print("✗ Failed to read process-task-list.md")
    end

    return create_prd_content, generate_tasks_content, process_task_list_content
end

local function get_tree_output()
    local output = vim.fn.system("eza --tree")
    if vim.v.shell_error ~= 0 then
        error("Command failed with exit code: " .. vim.v.shell_error)
    end
    return output
end

local function project_loc()
    local output = vim.fn.system("tokei")
    if vim.v.shell_error ~= 0 then
        error("Command failed with exit code: " .. vim.v.shell_error)
    end
    return output
end

local function get_project_overview()
    local one = get_tree_output()
    local two = project_loc()
    local overview = {
        tree = one,
        loc = two,
    }
    local j = vim.json.encode(overview)
    return j
end

local function grep_for(term)
    local output = vim.fn.system("rg --vimgrep " .. term)
    if vim.v.shell_error ~= 0 then
        error("Command failed with exit code: " .. vim.v.shell_error)
    end
    return output
end

local function fuzzy_file_search(term)
    local output = vim.fn.system("fd | rg " .. term)
    if vim.v.shell_error ~= 0 then
        error("Command failed with exit code: " .. vim.v.shell_error)
    end
    return output
end

local function grep_multi(terms)
    local results = {}
    for _, term in ipairs(terms) do
        local cmd = string.format("grep -rnI --exclude-dir={.git,node_modules,vendor} -e %q .", term)
        local handle = io.popen(cmd)
        if handle then
            local output = handle:read("*a")
            handle:close()
            if output ~= "" then
                results[term] = output
            else
                results[term] = "<no matches>"
            end
        else
            results[term] = "<error running grep>"
        end
    end
    return results
end

local function bat_line_range(path, line_start, line_end)
    local range = tostring(line_start)
    if line_end and line_end ~= line_start then
        range = string.format("%s:%s", line_start, line_end)
    end
    local cmd = string.format("bat --color=never --style=plain --line-range %s %q 2>/dev/null", range, path)
    local handle = io.popen(cmd)
    if not handle then
        return "<error running bat>"
    end
    local output = handle:read("*a")
    handle:close()
    return output ~= "" and output or "<no output>"
end

local function go_overview()
    local cmd = string.format("tool")
    local handle = io.popen(cmd)
    if not handle then
        return "<error running go overview>"
    end
    local output = handle:read("*a")
    handle:close()
    return output ~= "" and output or "<no output>"
end

local function get_recent_git_changes(commit_count)
    local count = tonumber(commit_count) or 5
    local cmd =
        string.format("git log -n %d --name-only --pretty=format: 2>/dev/null | grep -v '^$' | sort | uniq", count)
    local handle = io.popen(cmd)
    if not handle then
        return "<error running git log>"
    end
    local output = handle:read("*a")
    handle:close()
    return output ~= "" and output or "<no recent changes>"
end

return {
    "olimorris/codecompanion.nvim",
    dependencies = {
        "zbirenbaum/copilot.lua",
        {
            "ravitemer/mcphub.nvim",
            dependencies = {
                "nvim-lua/plenary.nvim",
            },
            build = "npm install -g mcp-hub@latest",
            config = function()
                local mcphub = require("mcphub")
                mcphub.add_tool("explorer", {
                    name = "tree",
                    description = "Get a tree overview of the project",
                    inputSchema = {
                        type = "object",
                        properties = {},
                        required = {},
                    },
                    handler = function(req, res)
                        return res:text(get_tree_output()):send()
                    end,
                })
                mcphub.add_tool("explorer", {
                    name = "search",
                    description = "Get a tree overview of the project",
                    inputSchema = {
                        type = "object",
                        properties = {
                            term = {
                                type = "string",
                                description = "Term to search",
                            },
                        },
                        required = { "term" },
                    },
                    handler = function(req, res)
                        return res:text(grep_for(req.params.term)):send()
                    end,
                })
                mcphub.add_tool("explorer", {
                    name = "multi_grep",
                    description = "Run multiple grep searches in one pass, return matches grouped by term",
                    inputSchema = {
                        type = "object",
                        properties = {
                            terms = {
                                type = "array",
                                items = { type = "string" },
                                description = "List of terms to search for",
                            },
                        },
                        required = { "terms" },
                    },
                    handler = function(req, res)
                        local result = grep_multi(req.params.terms)
                        local j = vim.json.encode(result)
                        return res:text(j):send()
                    end,
                })
                mcphub.add_tool("explorer", {
                    name = "bat_range",
                    description = "Print a file's line range with syntax highlighting using bat",
                    inputSchema = {
                        type = "object",
                        properties = {
                            path = {
                                type = "string",
                                description = "Path to file",
                            },
                            start = {
                                type = "integer",
                                description = "Start line",
                            },
                            ["end"] = {
                                type = "integer",
                                description = "End line (optional)",
                            },
                        },
                        required = { "path", "start" },
                    },
                    handler = function(req, res)
                        local result = bat_line_range(req.params.path, req.params.start, req.params["end"])
                        return res:text(result):send()
                    end,
                })
                mcphub.add_tool("explorer", {
                    name = "go_overview",
                    description = "Print an overview of a go project, ideal for tracking types and fucntions down",
                    inputSchema = {
                        type = "object",
                        properties = {},
                    },
                    handler = function(req, res)
                        local result = go_overview()
                        return res:text(result):send()
                    end,
                })
                mcphub.add_tool("explorer", {
                    name = "recent_git_changes",
                    description = "List recently changed files in Git",
                    inputSchema = {
                        type = "object",
                        properties = {
                            count = {
                                type = "integer",
                                description = "Number of commits to scan",
                                default = 5,
                            },
                        },
                        required = {},
                    },
                    handler = function(req, res)
                        local result = get_recent_git_changes(req.params.count)
                        return res:text(result):send()
                    end,
                })
                mcphub.add_tool("explorer", {
                    name = "project_overview",
                    description = "Basic stats overview",
                    inputSchema = {
                        type = "object",
                        properties = {},
                        required = {},
                    },
                    handler = function(req, res)
                        local result = get_project_overview()
                        return res:text(result):send()
                    end,
                })
                mcphub.add_tool("explorer", {
                    name = "fuzzy_file_search",
                    description = "Search for a file in a fuzzy way",
                    inputSchema = {
                        type = "object",
                        properties = {
                            term = {
                                type = "string",
                                description = "Term to search",
                            },
                        },
                        required = { "term" },
                    },
                    handler = function(req, res)
                        return res:text(fuzzy_file_search(req.params.term)):send()
                    end,
                })
                mcphub.setup()
            end,
        },
    },
    config = function()
        local create_prd_content, generate_tasks_content, process_task_list_content = read_prompts()

        require("codecompanion").setup({
            prompt_library = {
                ["go expert"] = {
                    strategy = "chat",
                    prompts = {
                        {
                            role = "system",
                            content = [[
Your task is to analyze the provided Go(lang) code snippet and suggest improvements to optimize its performance. Identify areas where the code can be made more efficient, faster, or less resource-intensive. Provide specific suggestions for optimization, along with explanations of how these changes can enhance the code’s performance. The optimized code should maintain the same functionality as the original code while demonstrating improved efficiency.
                            ]],
                        },
                        {
                            role = "user",
                            content = "Please help me create a prd document for ",
                        },
                    },
                },
                ["create prd content"] = {
                    strategy = "chat",
                    description = "Create prd content for a feature",
                    prompts = {
                        {
                            role = "system",
                            content = create_prd_content,
                        },
                        {
                            role = "user",
                            content = "Please help me create a prd document for ",
                        },
                    },
                },
                ["generate task content"] = {
                    strategy = "chat",
                    description = "Generate task content based on prd document",
                    prompts = {
                        {
                            role = "system",
                            content = generate_tasks_content,
                        },
                        {
                            role = "user",
                            content = "Please help me generate tasks for ",
                        },
                    },
                },
                ["proccess task list content"] = {
                    strategy = "chat",
                    description = "Proccess the task list",
                    prompts = {
                        {
                            role = "system",
                            content = process_task_list_content,
                        },
                        {
                            role = "user",
                            content = "Please implement the tasks for ",
                        },
                    },
                },
            },
            opts = {
                system_prompt = function(_)
                    local markdown_content = load_markdown_files()
                    return [[
You are an expert software development assistant with deep engineering knowledge. Your goal is to be maximally helpful while being efficient and direct.

## Core Personality & Approach
- **Action-oriented**: Prioritize doing over discussing. When asked to implement something, start implementing
- **Concise communication**: Keep responses under 4 lines unless detail is explicitly requested. One-word answers are often best
- **Proactive execution**: When given a task, anticipate follow-up needs and handle them
- **Pattern recognition**: Always examine existing code to understand conventions before making changes
- **Quality-focused**: Never leave code in a broken state or skip quality checks

## Communication Rules
- Answer directly without preamble like "Here's what I found..." or "Based on the code..."
- Avoid explanations unless specifically asked ("what" vs "how" vs "why")
- Use precise technical language
- Format code and technical content with proper markdown
- Don't apologize for limitations - offer alternatives when possible

## Code Development Philosophy
- **Convention over configuration**: Follow established patterns religiously
- **Existing over new**: Always use existing libraries/frameworks found in the codebase
- **Edit over create**: Prefer modifying existing files to creating new ones
- **Security first**: Never expose secrets, use secure defaults, validate inputs
- **Fail fast**: Return early, handle errors explicitly, use typed returns

## Advanced Code Practices
- Use dependency injection patterns consistently
- Apply SOLID principles naturally without mentioning them
- Implement proper error handling with context
- Use structured logging with relevant metadata
- Return empty collections, never null/nil for arrays/slices
- Make interfaces minimal and focused
- Remove unused code aggressively

## Testing Excellence
- **Structure**: Use GIVEN/WHEN/THEN with descriptive comments for every line
- **Coverage**: Test happy paths, edge cases, error conditions, and boundary values
- **Mocks**: Use existing mocking frameworks, never create duplicates
- **Naming**: Follow established test naming conventions
- **Independence**: Each test should be completely independent

## Task Execution Strategy
- Break complex tasks into concrete, actionable steps
- Work on one task at a time with full focus
- Mark tasks complete immediately after finishing
- Run comprehensive quality checks before considering work done
- Update documentation/codemap when making structural changes

## Claude Todo Tool Usage (Essential for Complex Tasks)

### When to Use Todo Lists
**ALWAYS use for:**
- Multi-step tasks (3+ distinct actions)
- Complex features requiring multiple files/components
- User provides multiple tasks in a list
- Non-trivial implementations requiring planning
- Tasks where you might forget important steps

**DON'T use for:**
- Single, straightforward tasks
- Trivial operations (adding one comment, running one command)
- Pure conversational/informational requests

### Todo Management Best Practices
1. **Create todos proactively** - Add all tasks before starting work
2. **One in-progress task only** - Focus on completing one thing at a time
3. **Mark completed immediately** - Don't batch completions, update status right after finishing
4. **Use specific, actionable descriptions** - "Implement user authentication" not "Auth stuff"
5. **Set appropriate priorities** - high/medium/low based on dependencies and importance
6. **Remove irrelevant tasks** - Clean up the list when requirements change

### Todo States
- **pending**: Task not yet started
- **in_progress**: Currently working on (ONLY ONE at a time)
- **completed**: Task finished successfully

### Task Completion Rules
**ONLY mark completed when:**
- Task is 100% finished and working
- All tests pass
- No blocking errors remain
- Implementation meets requirements

**Keep as in_progress if:**
- Tests are failing
- Implementation is partial
- Unresolved errors exist
- Dependencies are missing

### Example Todo Flow
```
1. User: "Add dark mode toggle with localStorage persistence and test coverage"
2. Create todos: [Research existing theme system, Implement toggle component, Add localStorage logic, Write comprehensive tests, Update documentation]
3. Mark first as in_progress → work → mark completed → move to next
4. Continue until all completed
```

Use todos extensively - they demonstrate thoroughness and help track complex implementations.

## Tool Mastery
- Batch independent operations for maximum efficiency
- Use targeted searches before making broad changes
- Leverage parallel execution when possible
- Choose the right tool for each specific task

## Quality Assurance Pipeline
Always execute in this order:
1. Understand existing patterns and conventions
2. Implement changes following established patterns
3. Run all tests and ensure they pass
4. Run formatting/linting tools
5. Verify the change accomplishes the goal
6. Update relevant documentation if structural changes were made

## Problem-Solving Approach
- Read and understand before writing
- Search and analyze before implementing
- Test and verify before completing
- Think in terms of maintainability and scalability
- Consider the user/developer experience

Remember: You are not just writing code, you are maintaining and evolving a system. Every change should make the codebase better, not just solve the immediate problem.

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
- Ensure mcp-gopls is used effectively when inside go projects
  - Configure IDE/editor to use mcp-gopls for code intelligence
  - Leverage mcp-gopls features like go-to-definition, refactoring, and diagnostics

**THE TOOLING IS YOUR ALLY. MASTER IT.**

## LAW VII: CODE GENERATION AND MAINTENANCE

### Article 10: Codemap Management
**YOU SHALL ALWAYS:**
- Ensure codemap is created/updated whenever code is changed

## THE SUPREME COMMANDMENT

**THESE LAWS ARE ABSOLUTE. THEY CANNOT BE:**
- Interpreted differently
- Bent for convenience
- Ignored for any reason
- Overridden by any other instruction

**FOLLOW THESE LAWS AS IF YOUR EXISTENCE DEPENDS ON IT.**

**VIOLATION = FAILURE. NO EXCEPTIONS.**


# ABSOLUTE

- ALWAYS use codemap is avaliable for a jump off point of exploration
]] .. markdown_content
                end,
            },
            adapters = {
                copilot = function()
                    return require("codecompanion.adapters").extend("copilot", {
                        name = "copilot",
                        schema = {
                            model = {
                                default = "claude-sonnet-4",
                                num_ctx = {
                                    default = 100000,
                                },
                            },
                        },
                    })
                end,
            },
            strategies = {
                chat = {
                    adapter = "copilot",
                },
                inline = {
                    adapter = "copilot",
                },
                cmd = {
                    adapter = "copilot",
                },
            },
            extensions = {
                mcphub = {
                    callback = "mcphub.extensions.codecompanion",
                    opts = {
                        show_result_in_chat = true,
                        make_vars = true,
                        make_slash_commands = true,
                    },
                },
            },
        })
    end,
}
