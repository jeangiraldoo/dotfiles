return {
	name = "smear-cursor",
	author = "sphamba",
	require_name = "smear_cursor",
	opts = {
		cursor_color = "#ff1f9d",
		stiffness = 0.3,     -- How fast the smear's head moves towards the target
		trailing_stiffness = 0.15, -- How fast the smear's tail moves towards the target
		trailing_exponent = 5, -- Controls if middle points are closer to the head or the tail
		hide_target_hack = true, -- Attempt to hide the real cursor by drawing a character below it
		gamma = 1,
	},
}
