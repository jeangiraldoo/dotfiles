return {
	python = {
		markers = {
			"main.py",
		},
		commands = {
			"source %root_path/myvenv/bin/activate.fish >> python3 %abs_file_path",
		},
	},
	javascript = {
		markers = {
			"index.js",
			"main.js",
		},
		commands = {
			"node %abs_file_path",
		},
	},
	go = {
		markers = {
			"go.mod",
			"main.go",
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
			"Cargo.toml",
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
}
