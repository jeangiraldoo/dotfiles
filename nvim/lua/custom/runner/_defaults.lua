return {
	python = {
		common = {
			markers = {
				"main.py",
			},
		},
		Linux = {
			file = {
				commands = {
					"source %root_path/myvenv/bin/activate.fish ; python3 %abs_file_path",
				},
			},
			project = {
				markers = {
					"main.py",
				},
				commands = {
					"source %root_path/myvenv/bin/activate.fish ; python3 %abs_file_path",
				},
			},
		},
	},
	javascript = {
		Linux = {
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
	},
	go = {
		Linux = {
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
	},
	rust = {
		Linux = {
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
	},
	mermaid = {
		Linux = {
			file = {
				close_after_cmd = true,
				commands = {
					"mmdc --theme forest --input %abs_file_path --output %file_name.svg",
					"xdg-open %file_name.svg",
				},
			},
		},
	},
}
