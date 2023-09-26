return {
  {
    'Bryley/neoai.nvim',
    dependencies = {
      'MunifTanjim/nui.nvim',
    },
    cmd = {
      'NeoAI',
      'NeoAIOpen', 'NeoAIClose', 'NeoAIToggle',
      'NeoAIContext', 'NeoAIContextOpen', 'NeoAIContextClose',
      'NeoAIInject', 'NeoAIInjectCode', 'NeoAIInjectContext', 'NeoAIInjectContextCode',
    },
    keys = {
      { '<leader>aa',   '<cmd>NeoAIToggle<cr>',             desc = 'NeoAI' },
      { '<leader>ac',   '<cmd>NeoAIContext<cr>',            desc = 'NeoAI using Context', mode = { 'n', 'v' } },
      { '<leader>ag',   '<cmd>NeoAIShortcut gitcommit<cr>', desc = 'Generate git commit' },
      { '<leader>as',   '<cmd>NeoAIShortcut textify<cr>',   desc = 'Summarize text',      mode = 'v' },
      { '<leader>ai',   '<c-u>:NeoAIInject ',               desc = 'Inject', },
      { '<leader>aic',  '<c-u>:NeoAIInjectCode ',           desc = 'Code', },
      { '<leader>aivv', '<c-u>:NeoAIInjectContext ',        desc = 'Context',             mode = { 'n', 'v' } },
      { '<leader>aivc', '<c-u>:NeoAIInjectContextCode ',    desc = 'Context Code',        mode = { 'n', 'v' } },
    },
    init = function()
      require('which-key').register({ ['<leader>a'] = { name = 'ai' } })
      require('which-key').register({ ['<leader>ai'] = { name = 'inject' } }, { mode = 'v' })
      require('which-key').register({ ['<leader>aiv'] = { name = 'context' } }, { mode = 'v' })
    end,
    config = function()
      require('neoai').setup {
        shortcuts = {
          name = 'textify',
          desc = 'NeoAI fix text with AI',
          use_context = true,
          prompt = [[
                    Please rewrite the text to make it more readable, clear,
                    concise, and fix any grammatical, punctuation, or spelling
                    errors
                ]],
          modes = { 'v' },
          strip_function = nil,
        },
        {
          name = 'gitcommit',
          desc = 'NeoAI generate git commit message',
          use_context = false,
          prompt = function()
            return [[
                        Using the following git diff generate a consise and
                        clear git commit message, with a short title summary
                        that is 75 characters or less:
                    ]] .. vim.fn.system 'git diff --cached'
          end,
          modes = { 'n' },
          strip_function = nil,
        },
      }
    end,
  },

  {
    'jackMort/ChatGPT.nvim',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'nvim-telescope/telescope.nvim',
    },
    cmd = {
      'ChatGPT',
      'ChatGPTActAs',
      'ChatGPTEditWithInstructions',
      'ChatGPTRun',
    },
    keys = {
      { '<leader>acc', '<cmd>ChatGPT<cr>',                     desc = 'ChatGPT' },
      { '<leader>aca', '<cmd>ChatGPTActAs<cr>',                desc = 'ChatGPT Act-As' },
      { '<leader>ace', '<cmd>ChatGPTEditWithInstructions<cr>', desc = 'ChatGPT Edit' },
      {
        '<leader>acrg',
        "<cmd>ChatGPTRun grammar_correction<CR>",
        desc = "Grammar Correction",
        mode = { "n", "v" }
      },
      {
        '<leader>acrt',
        "<cmd>ChatGPTRun translate<CR>",
        desc = "Translate",
        mode = { "n", "v" }
      },
      {
        '<leader>acrk',
        "<cmd>ChatGPTRun keywords<CR>",
        desc = "Keywords",
        mode = { "n", "v" }
      },
      {
        '<leader>acrd',
        "<cmd>ChatGPTRun docstring<CR>",
        desc = "Docstring",
        mode = { "n", "v" }
      },
      {
        '<leader>acra',
        "<cmd>ChatGPTRun add_tests<CR>",
        desc = "Add Tests",
        mode = { "n", "v" }
      },
      {
        '<leader>acro',
        "<cmd>ChatGPTRun optimize_code<CR>",
        desc = "Optimize Code",
        mode = { "n", "v" }
      },
      {
        '<leader>acrs',
        "<cmd>ChatGPTRun summarize<CR>",
        desc = "Summarize",
        mode = { "n", "v" }
      },
      {
        '<leader>acrf',
        "<cmd>ChatGPTRun fix_bugs<CR>",
        desc = "Fix Bugs",
        mode = { "n", "v" }
      },
      {
        '<leader>acrx',
        "<cmd>ChatGPTRun explain_code<CR>",
        desc = "Explain Code",
        mode = { "n", "v" }
      },
      {
        '<leader>acrr',
        "<cmd>ChatGPTRun roxygen_edit<CR>",
        desc = "Roxygen Edit",
        mode = { "n", "v" }
      },
      {
        '<leader>acrl',
        "<cmd>ChatGPTRun code_readability_analysis<CR>",
        desc = "Code Readability Analysis",
        mode = { "n", "v" }
      },
    },
    init = function()
      require('which-key').register({ ['<leader>ac'] = { name = 'chatgpt' } })
      require('which-key').register({ ['<leader>acr'] = { name = 'run' } })
    end,
    main = 'chatgpt',
    opts = {
      popup_input = {
        submit = "<CR>"
      }
    }
  },
}
