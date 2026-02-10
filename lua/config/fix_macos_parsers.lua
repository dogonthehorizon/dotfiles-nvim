-- Workaround for tree-sitter-cli compiling parsers as Mach-O dylibs on macOS
-- instead of Mach-O bundles. The dylibs get an install_name pointing to a
-- cache path that no longer exists, which crashes neovim on dlopen.
--
-- This runs install_name_tool on each compiled parser .so to replace the bogus
-- install_name with a harmless @rpath-relative one. It's a no-op on non-macOS
-- and on parsers that don't need fixing.
--
-- See: https://github.com/nvim-treesitter/nvim-treesitter/issues/8279
--      https://github.com/tree-sitter/tree-sitter (crates/loader/src/loader.rs)

local function fix_macos_parsers()
	if vim.fn.has("mac") ~= 1 then
		return
	end

	local parser_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "site", "parser")
	if vim.fn.isdirectory(parser_dir) ~= 1 then
		return
	end

	for name, type in vim.fs.dir(parser_dir) do
		if type == "file" and name:match("%.so$") then
			local path = vim.fs.joinpath(parser_dir, name)

			-- Only patch files that have a bogus install_name (pointing to .cache)
			local result = vim.system({ "otool", "-L", path }):wait()
			if result.code == 0 and result.stdout:find(".cache/nvim/tree%-sitter%-") then
				vim.system({ "install_name_tool", "-id", "@rpath/" .. name, path }):wait()
			end
		end
	end
end

return fix_macos_parsers
