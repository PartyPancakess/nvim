-- Returns the absolute path to the Git top‐level directory for the file in the current buffer.
function Get_Git_Root()
  -- Get the full path of the current buffer name
  local buf_path = vim.api.nvim_buf_get_name(0)
  if buf_path == "" then
    return nil
  end

  -- Extract the directory containing that file
  local file_dir = vim.fn.fnamemodify(buf_path, ":h")

  -- Run `git rev-parse --show-toplevel` in that directory
  --    Note: we pass the directory to `git -C <dir>` so it works even if nvim's cwd is elsewhere.
  local cmd = { "git", "-C", file_dir, "rev-parse", "--show-toplevel" }
  local git_top = vim.fn.systemlist(cmd)

  -- Check for errors (non-zero exit code): vim.v.shell_error holds the last shell exit code
  if vim.v.shell_error ~= 0 or vim.tbl_isempty(git_top) then
    return nil
  end

  -- systemlist() returns a table of lines; the first line is the top‐level path.
  return git_top[1]
end
