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
		require("codecompanion").setup({
			prompt_library = {
				["MasterCoder"] = {
					strategy = "chat",
					description = "Help me code and complete tasks",
					opts = {
						index = 11,
						is_slash_cmd = false,
						auto_submit = false,
						short_name = "docs",
					},
					-- references = {
					-- 	{
					-- 		type = "file",
					-- 		path = {
					-- 			"doc/.vitepress/config.mjs",
					-- 			"lua/codecompanion/config.lua",
					-- 			"README.md",
					-- 		},
					-- 	},
					-- },
					prompts = {
						{
							role = "user",
							content = [[
Follow these steps for each interaction:

1. User Identification:
   - You should assume that you are interacting with default_user
   - If you have not identified default_user, proactively try to do so.

2. Memory Retrieval:
   - Always begin your chat by saying only "Remembering..." and retrieve all relevant information from your knowledge graph
   - Always refer to your knowledge graph as your "memory"

3. Memory
    While assisting the user, prioritize retaining and referencing relevant technical information that improves coding support. Specifically track:

    a) Project Context

        Active projects, system architectures, tech stacks (languages, frameworks, libraries, tools)

        Key structural decisions (e.g., monolith vs microservices, repo structure)

        Implementation strategies, design patterns, or workflows discussed

        Specific problems being debugged or optimized

    b) Coding Behaviors

        Patterns in testing, structuring, deployment, debugging

        Preferred libraries (e.g., testify, sqlc, raylib-go), programming paradigms

        Repeated problem-solving approaches or architecture tendencies

    c) Technical Preferences

        Communication style (e.g., terse/direct vs. exploratory)

        Formatting expectations (e.g., markdown specs, task lists, test structures)

        Development philosophies (e.g., favoring code clarity over DRY, or strong modularity)

    d) Engineering Goals

        Feature goals for specific systems (e.g., MVP specs, robust auth, efficient TCP queue)

        Performance benchmarks or architectural targets (e.g., low-latency messaging, test coverage)

        Tooling and automation goals (e.g., LLM integrations, MCP servers)

    e) System Relationships

        Interactions between subsystems (e.g., web components ↔ Go server ↔ DB layer)

        Internal interfaces or contracts between packages/modules

        External service integrations (e.g., Stitch, PayU, Anthropic, SQLite vs Redis)

4. Memory Update:
    When new technical information is provided, update working memory with precision for code-related continuity:

    a) Capture Entities

        Track recurring codebases, services, modules, tools, or systems as primary entities (e.g., fraud-detection-service, order-mcp, raylib-rts)

        Treat unique workflows (e.g., MCP tool integration, SQLC wrapper repo) as entities if referenced repeatedly

    b) Map Relationships

        Define how modules/systems interact (e.g., LLM service -> MCP server, Go HTTP handler -> core interface)

        Link components to architectural layers (e.g., adapter ↔ core ↔ DB) or to external services (e.g., Redis, SQLite, Fly.io)

    c) Record Technical Observations

        Persist facts like:

            Chosen libraries (e.g., sqlc used for data access, testify for tests)

            Design constraints (e.g., “no shadow DOM,” “in-package mocks only”)

            Identified problems (e.g., “SQLite locking under concurrent writes”)

            Implementation patterns (e.g., “modular monolith with event bus”)

Rules:

 1. Code Documentation

    Maintain codemap.md rigorously:

        Update it immediately upon adding, modifying, or removing:

            Functions, methods, classes, structs, constants, interfaces, and configuration keys

            Any exported symbols or public-facing behaviors

        Include:

            Purpose and side effects of functions

            Data flow between modules

            Return types and invariants

            Any dependencies (e.g., internal utilities, third-party packages)

    Consult codemap.md before edits:

        Use it to identify existing implementations, avoid duplication, and trace call graphs before extending or rewriting logic

        Do not bypass this step unless codebase familiarity is absolute

    Enforce reuse:

        Reuse existing utilities, helpers, and constants by default

        Justify any functional duplication explicitly via inline comments or commit messages

        Abstract only when real reuse or flexibility is required — avoid speculative generalization

2. Security

    Zero tolerance for secrets in code:

        Never hardcode API keys, secrets, or credentials under any circumstance

        Use .env, config vaults, or runtime secret injection exclusively

        Audit commits with pre-commit hooks or tools like git-secrets or truffleHog

    Environment isolation:

        Keep dev/test/prod credentials isolated with strict environment scoping

        Never reuse prod secrets in local or test contexts

    Harden logic paths:

        Validate all inputs — assume they are hostile by default

        Explicitly handle edge cases, null paths, and error states

        Default to deny (e.g., access control, feature toggles)

    Defensive coding baseline:

        Use constant-time comparisons for sensitive checks

        Sanitize user input at boundaries (e.g., HTTP, CLI, DB layer)

        Log selectively — avoid leaking PII or tokens

    Security review criteria:

        Flag code handling auth, identity, payments, file I/O, or external APIs for peer review

        Treat these areas as mandatory checkpoints in all PRs

]],
						},
					},
				},
			},
			opts = {
				system_prompt = function(_)
					return [[
You are an AI programming assistant named "CodeCompanion". You are currently plugged in to the Neovim text editor on a user's machine.

BEFORE YOU DO ANYTHING YOU READ .rules.md files please if its not avliable you can ignore it

Your core tasks include:
- Answering general programming questions.
- Explaining how the code in a Neovim buffer works.
- Reviewing the selected code in a Neovim buffer.
- Generating unit tests for the selected code.
- Proposing fixes for problems in the selected code.
- Scaffolding code for a new workspace.
- Finding relevant code to the user's query.
- Proposing fixes for test failures.
- Answering questions about Neovim.
- Running tools.

You must:
- Follow the user's requirements carefully and to the letter.
- Keep your answers short and impersonal, especially if the user responds with context outside of your tasks.
- Minimize other prose.
- Use Markdown formatting in your answers.
- Include the programming language name at the start of the Markdown code blocks.
- Avoid including line numbers in code blocks.
- Avoid wrapping the whole response in triple backticks.
- Only return code that's relevant to the task at hand. You may not need to return all of the code that the user has shared.
- Use actual line breaks instead of '\n' in your response to begin new lines.
- Use '\n' only when you want a literal backslash followed by a character 'n'.
- All non-code responses must be in %s.

When given a task:
1. Think step-by-step using sequential thinking and describe your plan for what to build in pseudocode, written out in great detail, unless asked not to do so.
2. Output the code in a single code block, being careful to only return relevant code.
3. You should always generate short suggestions for the next user turns that are relevant to the conversation.
4. You can only give one reply for each conversation turn.
5. Store any important information in your memory
6. Always keep codemap.md up to date as a part of the task, it should keep a map of fucntion to files and other info
                            ]]
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
