return {
	python = {
		executable = {
			Windows = "python",
			Linux = "python3",
		},
		venv = {
			markers = {
				"venv",
				".venv",
			},
			source_command = "source %root_path/%venv_marker/bin/activate",
		},
		project = {
			markers = {
				static = {
					"venv",
				},
				code = {
					"main.py",
				},
			},
		},
		commands = {
			"%executable %abs_file_path",
		},
	},
	javascript = {
		executable = "node",
		project = {
			markers = {
				static = {},
				code = {
					"index.js",
					"main.js",
				},
			},
		},
		commands = {
			"%executable %abs_file_path",
		},
	},
	go = {
		executable = "go",
		project = {
			markers = {
				static = {
					"go.mod",
				},
				code = {
					"main.go",
				},
			},
			commands = {
				"%executable run .",
			},
		},
		file = {
			commands = {
				"%executable run %abs_file_path",
			},
		},
	},
	rust = {
		executable = "rustc",
		project = {
			markers = {
				static = {
					"Cargo.toml",
				},
				code = {
					"src/main.rs",
				},
			},
			commands = {
				"cargo run",
			},
		},
		file = {
			commands = {
				"%executable %abs_file_path",
				"chmod +x %file_name",
				"./%file_name",
			},
		},
	},
	mermaid = {
		close_after_cmd = true,
		executable = "mmdc",
		file = {
			commands = {
				"%executable --theme forest --input %abs_file_path --output %file_name.svg",
				"xdg-open %file_name.svg",
			},
		},
	},
	project_commands = {},
}
