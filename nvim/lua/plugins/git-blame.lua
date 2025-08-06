return {
	"f-person/git-blame.nvim",
	event = "VeryLazy",
	opts = {
		enabled = false,
		message_template = " <author> -> <summary> • <date> <<sha>>",
		message_when_not_committed = " Not commited yet",
		date_format = "%d-%b-%Y",
		delay = 0,
	},
}
