return {
	python = {
		file = {
			commands = {
				"python3 %abs_file_path",
			},
		},
		project = {
			markers = {
				"main.py",
			},
			commands = {
				"python3 %abs_file_path",
			},
		},
	},
	javascript = {
		file = {
			commands = {
				"node %abs_file_path",
			},
		},
		project = {
			markers = {
				"index.js",
				"main.js",
			},
			commands = {
				"node %abs_file_path",
			},
		},
	},
	go = {
		file = {
			commands = {
				"go run %abs_file_path",
			},
		},
		project = {
			markers = {
				"go.mod",
				"main.go",
			},
			commands = {
				"go run .",
			},
		},
	},
	rust = {
		file = {
			commands = {
				"rustc %abs_file_path",
				"chmod +x %file_name",
				"./%file_name",
			},
		},
		project = {
			markers = {
				"Cargo.toml",
			},
			commands = {
				"cargo run",
			},
		},
	},
	mermaid = {
		file = {
			close_after_cmd = true,
			commands = {
				"mmdc --theme forest --input %abs_file_path --output %file_name.svg",
				"xdg-open %file_name.svg",
			},
		},
	},
}
