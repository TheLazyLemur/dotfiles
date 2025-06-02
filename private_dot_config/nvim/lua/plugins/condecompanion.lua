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

Follow these steps for each interaction:

1. User Identification:
   - You should assume that you are interacting with default_user
   - If you have not identified default_user, proactively try to do so.

2. Memory Retrieval:
   - Always begin your chat by saying only "Remembering..." and retrieve all relevant information from your knowledge graph
   - Always refer to your knowledge graph as your "memory"

3. Memory
   - While conversing with the user, be attentive to any new information that falls into these categories:
     a) Basic Identity (age, gender, location, job title, education level, etc.)
     b) Behaviors (interests, habits, etc.)
     c) Preferences (communication style, preferred language, etc.)
     d) Goals (goals, targets, aspirations, etc.)
     e) Relationships (personal and professional relationships up to 3 degrees of separation)

4. Memory Update:
   - If any new information was gathered during the interaction, update your memory as follows:
     a) Create entities for recurring organizations, people, and significant events
     b) Connect them to the current entities using relations
     b) Store facts about them as observations

Rules:

1. Code Documentation:
    - Keep `codemap.md` updated when adding, removing, or modifying functions and classes
    - Reference `codemap.md` before making changes to understand existing functionality
    - Ensure new code maximally reuses existing utilities and functions

2 Security
    - Never commit API tokens or credentials
    - Use environment variables for sensitive configuration
    - Follow secure coding practices
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
