return {
	python = {
		venv = {
			marker = "venv/",
			source_command = "source %root_path/venv/bin/activate.fish",
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
			"python3 %abs_file_path",
		},
	},
	javascript = {
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
			"node %abs_file_path",
		},
	},
	go = {
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
				"go run %abs_file_path",
			},
			project = {
				"go run .",
			},
		},
	},
	rust = {
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
				"rustc %abs_file_path",
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
		commands = {
			file = {
				"mmdc --theme forest --input %abs_file_path --output %file_name.svg",
				"xdg-open %file_name.svg",
			},
		},
	},
	project_commands = {},
}
