return {
	python = {
		type = "interpreted",
		cmd = "python %s",
		project_markers = {
			"main.py",
		},
	},
	javascript = {
		type = "interpreted",
		cmd = "node %s",
		project_markers = {
			"index.js",
			"main.js",
		},
	},
	go = {
		type = "compiled",
		cmd = "go run .",
		project_markers = {
			"go.mod",
			"main.go",
		},
	},
	rust = {
		type = "compiled",
		cmd = "cargo run",
		project_markers = {
			"Cargo.toml",
		},
	},
}
