return {
	"jeangiraldoo/codedocs.nvim",
	config = function()
		require("codedocs").setup({
			default_styles = {
				python = "reST",
			},
			styles = {
				-- typescript = {
				-- 	TSDoc = {
				-- 		class = {
				-- 			general = {
				-- 				include_class_attrs = true,
				-- 				include_instance_attrs = true,
				-- 				include_only_construct_instance_attrs = true,
				-- 			},
				-- 		},
				-- 	},
				-- },
				java = {
					JavaDoc = {
						class = {
							general = {
								include_class_attrs = true,
								include_instance_attrs = true,
								-- include_only_construct_instance_attrs = true,
							},
							attrs = {
								include_type = true,
							},
						},
						func = {
							params = {
								include_type = true,
							},
						},
					},
				},
				kotlin = {
					KDoc = {
						class = {
							general = {
								include_class_attrs = true,
								include_instance_attrs = true,
								-- include_only_construct_instance_attrs = true,
							},
							attrs = {
								include_type = true,
							},
						},
						func = {
							params = {
								include_type = true,
							},
						},
					},
				},
				-- python = {
				-- 	reST = {
				-- 		func = {
				-- 			general = {
				-- 				item_gap = true,
				-- 				section_gap = true,
				-- 			},
				-- 			params = {
				-- 				-- include_type = false,
				-- 			},
				-- 		},
				-- 		class = {
				-- 			general = {
				-- 				item_gap = true,
				-- 				include_class_attrs = false,
				-- 				include_instance_attrs = false,
				-- 				include_only_construct_instance_attrs = true,
				-- 			},
				-- 		},
				-- 	},
				-- },
				-- go = {
				-- 	Godoc = {
				-- 		func = {
				-- 			general = {
				-- 				item_gap = true,
				-- 				section_gap = true,
				-- 			},
				-- 			params = {
				-- 				include_type = true,
				-- 			},
				-- 		},
				-- 	},
				-- },
			},
		})
	end,
}
