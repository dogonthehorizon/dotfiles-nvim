-- Function to execute Lecker command with a URL
local function execute_lecker(url)
-- Construct the command as an array of arguments
local cmd = {
    "lecker",
    "fetch",
    url
}

-- Execute the command and capture output
vim.system(cmd, { text = true }, function(obj)
    vim.schedule(function()
        -- Create a new buffer
        local buf = vim.api.nvim_create_buf(true, true)

        -- Open the buffer in a new window
        vim.api.nvim_command('vsplit')
        local win = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_buf(win, buf)

        -- Split the output into lines
        local lines = vim.split(obj.stdout, '\n', { plain = true })

        -- Write the output to the buffer
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

        -- If there was an error, show it
        if obj.code ~= 0 then
            local error_msg = "Lecker command failed:\n" ..
                            "Exit code: " .. obj.code .. "\n" ..
                            "Error: " .. (obj.stderr or "No error message")
            vim.notify(error_msg, vim.log.levels.ERROR)
            
            -- Also write error output to the buffer
            local error_lines = vim.split(obj.stderr or "", '\n', { plain = true })
            vim.api.nvim_buf_set_lines(buf, -1, -1, false, {"", "Error Output:", ""})
            vim.api.nvim_buf_set_lines(buf, -1, -1, false, error_lines)
        end
    end)
end)
end

-- Create the Lecker command that accepts a URL argument
vim.api.nvim_create_user_command(
    'Lecker',
    function(opts)
        -- Check if a URL was provided
        if opts.args == "" then
            vim.notify("Please provide a URL", vim.log.levels.ERROR)
            return
        end
        execute_lecker(opts.args)
    end,
    {
        nargs = 1,
        desc = "Fetch URL content using Lecker"
    }
)

-- Create the GitOpenPR command
vim.api.nvim_create_user_command(
    'GitOpenPR',
    function()
        vim.system({ "open-pr" }, { text = true }, function(obj)
            if obj.code ~= 0 then
                vim.notify("Failed to open PR: " .. obj.stderr, vim.log.levels.ERROR)
            end
        end)
    end,
    {
        nargs = 0,
        desc = "Open the PR for the current branch"
    }
)

-- Bind GitOpenPR to <leader>gP
vim.keymap.set('n', '<leader>gP', ':GitOpenPR<CR>', { 
    silent = true,
    noremap = true,
    desc = "Open PR for current branch"
})
