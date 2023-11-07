-- Open alternative files for the current buffer
return {
  'rgroli/other.nvim',
  name = 'other-nvim',
  keys = {
    { '<leader>foo', '<Cmd>Other<CR>' },
    { '<leader>fos', '<Cmd>OtherSplit<CR>' },
    { '<leader>fov', '<Cmd>OtherVSplit<CR>' },
  },
  cmd = {
    'Other', 'OtherTabNew', 'OtherSplit', 'OtherVSplit'
  },
  opts = {
    mappings = {

      'golang',
      {
        pattern = '/src/(.+)%.(.+)$',
        target = '/test/%1%.test%.%2',
        context = 'test'
      }
    }
  }
}
