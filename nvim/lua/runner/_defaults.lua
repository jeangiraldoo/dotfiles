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
		markers = {
			static = {
				"venv",
				".git",
			},
			code = {
				"main.py",
			},
		},
		commands = {
			"%executable %abs_file_path",
		},
	},
	javascript = {
		executable = "node",
		markers = {
			static = {
				".git",
			},
			code = {
				"index.js",
				"main.js",
			},
		},
		commands = {
			"%executable %abs_file_path",
		},
	},
	go = {
		executable = "go",
		markers = {
			static = {
				".git",
				"go.mod",
			},
			code = {
				"main.go",
			},
		},
		commands = {
			file = {
				"%executable run %abs_file_path",
			},
			project = {
				"%executable run .",
			},
		},
	},
	rust = {
		executable = "rustc",
		markers = {
			static = {
				".git",
				"Cargo.toml",
			},
			code = {
				"src/main.rs",
			},
		},
		commands = {
			file = {
				"%executable %abs_file_path",
				"chmod +x %file_name",
				"./%file_name",
			},
			project = {
				"cargo run",
			},
		},
	},
	mermaid = {
		close_after_cmd = true,
		executable = "mmdc",
		commands = {
			file = {
				"%executable --theme forest --input %abs_file_path --output %file_name.svg",
				"xdg-open %file_name.svg",
			},
		},
	},
	project_commands = {},
}
