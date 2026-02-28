return {
  "robitx/gp.nvim",
  name = "gp",
  event = "BufEnter",
  config = function()
    require("gp").setup({
      -- openai_api_key = os.getenv("OPENAI_API_KEY"),
      providers = {
        ollama = {
          disable = false,
          endpoint = "http://localhost:11434/v1/chat/completions",
        },
        openai = {
          disable = true,
        },
        copilot = {
          disable = false,
          endpoint = "https://api.githubcopilot.com/chat/completions",
          secret = {
            "bash",
            "-c",
            "cat ~/.config/github-copilot/hosts.json | sed -e 's/.*oauth_token...//;s/\".*//'",
          },
        },
      },
      whisper = {
        disable = true,
      },
      agents = {
        {
          name = "Qwen2.5-coder:7b",
          chat = true,
          command = true,
          provider = "ollama",
          model = { model = "qwen2.5-coder" },
          system_prompt = "I am an AI meticulously crafted to provide programming guidance and code assistance. "
            .. "To best serve you as a computer programmer, please provide detailed inquiries and code snippets when necessary, "
            .. "and expect precise, technical responses tailored to your development needs.\n",
        },
        {
          name = "Codellama",
          chat = true,
          command = true,
          provider = "ollama",
          model = { model = "codellama" },
          system_prompt = "I am an AI meticulously crafted to provide programming guidance and code assistance. "
            .. "To best serve you as a computer programmer, please provide detailed inquiries and code snippets when necessary, "
            .. "and expect precise, technical responses tailored to your development needs.\n",
        },
        {
          name = "Llama3",
          chat = true,
          command = true,
          provider = "ollama",
          model = { model = "llama3" },
          system_prompt = "I am an AI meticulously crafted to provide programming guidance and code assistance. "
            .. "To best serve you as a computer programmer, please provide detailed inquiries and code snippets when necessary, "
            .. "and expect precise, technical responses tailored to your development needs.\n",
        },
        {
          name = "Copilot",
          chat = true,
          command = true,
          provider = "copilot",
          model = { model = "ChatCopilot" },
          system_prompt = "I am an AI meticulously crafted to provide programming guidance and code assistance. "
            .. "To best serve you as a computer programmer, please provide detailed inquiries and code snippets when necessary, "
            .. "and expect precise, technical responses tailored to your development needs.\n",
        },
      },
      hooks = {
        -- example of usig enew as a function specifying type for the new buffer
        CodeReview = function(gp, params)
          local template = "I have the following code from {{filename}}:\n\n"
            .. "```{{filetype}}\n{{selection}}\n```\n\n"
            .. "Please analyze for code smells and suggest improvements."
          local agent = gp.get_chat_agent()
          gp.Prompt(params, gp.Target.enew("markdown"), agent, template)
        end,
        -- example of making :%GpChatNew a dedicated command which
        -- opens new chat with the entire current buffer as a context
        BufferChatNew = function(gp, _)
          -- call GpChatNew command in range mode on whole buffer
          vim.api.nvim_command("%" .. gp.config.cmd_prefix .. "ChatNew")
        end,
      },
    })
  end,

  keys = function()
    require("which-key").add({
      -- VISUAL mode mappings
      -- s, x, v modes are handled the same way by which_key
      {
        mode = { "v" },
        nowait = true,
        remap = false,
        { "<C-g><C-t>", ":<C-u>'<,'>GpChatNew tabnew<cr>", desc = "ChatNew tabnew", icon = "󰗋" },
        { "<C-g><C-v>", ":<C-u>'<,'>GpChatNew vsplit<cr>", desc = "ChatNew vsplit", icon = "󰗋" },
        { "<C-g><C-x>", ":<C-u>'<,'>GpChatNew split<cr>", desc = "ChatNew split", icon = "󰗋" },
        { "<C-g>a", ":<C-u>'<,'>GpAppend<cr>", desc = "Visual Append (after)", icon = "󰗋" },
        { "<C-g>b", ":<C-u>'<,'>GpPrepend<cr>", desc = "Visual Prepend (before)", icon = "󰗋" },
        { "<C-g>c", ":<C-u>'<,'>GpChatNew<cr>", desc = "Visual Chat New", icon = "󰗋" },
        { "<C-g>g", group = "generate into new ..", icon = "󰗋" },
        { "<C-g>ge", ":<C-u>'<,'>GpEnew<cr>", desc = "Visual GpEnew", icon = "󰗋" },
        { "<C-g>gn", ":<C-u>'<,'>GpNew<cr>", desc = "Visual GpNew", icon = "󰗋" },
        { "<C-g>gp", ":<C-u>'<,'>GpPopup<cr>", desc = "Visual Popup", icon = "󰗋" },
        { "<C-g>gt", ":<C-u>'<,'>GpTabnew<cr>", desc = "Visual GpTabnew", icon = "󰗋" },
        { "<C-g>gv", ":<C-u>'<,'>GpVnew<cr>", desc = "Visual GpVnew", icon = "󰗋" },
        { "<C-g>i", ":<C-u>'<,'>GpImplement<cr>", desc = "Implement selection", icon = "󰗋" },
        { "<C-g>n", "<cmd>GpNextAgent<cr>", desc = "Next Agent", icon = "󰗋" },
        { "<C-g>p", ":<C-u>'<,'>GpChatPaste<cr>", desc = "Visual Chat Paste", icon = "󰗋" },
        { "<C-g>r", ":<C-u>'<,'>GpRewrite<cr>", desc = "Visual Rewrite", icon = "󰗋" },
        { "<C-g>s", "<cmd>GpStop<cr>", desc = "GpStop", icon = "󰗋" },
        { "<C-g>t", ":<C-u>'<,'>GpChatToggle<cr>", desc = "Visual Toggle Chat", icon = "󰗋" },
        -- { "<C-g>w", group = "Whisper", icon = "󰗋" },
        -- { "<C-g>wa", ":<C-u>'<,'>GpWhisperAppend<cr>", desc = "Whisper Append", icon = "󰗋" },
        -- { "<C-g>wb", ":<C-u>'<,'>GpWhisperPrepend<cr>", desc = "Whisper Prepend", icon = "󰗋" },
        -- { "<C-g>we", ":<C-u>'<,'>GpWhisperEnew<cr>", desc = "Whisper Enew", icon = "󰗋" },
        -- { "<C-g>wn", ":<C-u>'<,'>GpWhisperNew<cr>", desc = "Whisper New", icon = "󰗋" },
        -- { "<C-g>wp", ":<C-u>'<,'>GpWhisperPopup<cr>", desc = "Whisper Popup", icon = "󰗋" },
        -- { "<C-g>wr", ":<C-u>'<,'>GpWhisperRewrite<cr>", desc = "Whisper Rewrite", icon = "󰗋" },
        -- { "<C-g>wt", ":<C-u>'<,'>GpWhisperTabnew<cr>", desc = "Whisper Tabnew", icon = "󰗋" },
        -- { "<C-g>wv", ":<C-u>'<,'>GpWhisperVnew<cr>", desc = "Whisper Vnew", icon = "󰗋" },
        -- { "<C-g>ww", ":<C-u>'<,'>GpWhisper<cr>", desc = "Whisper", icon = "󰗋" },
        { "<C-g>x", ":<C-u>'<,'>GpContext<cr>", desc = "Visual GpContext", icon = "󰗋" },
      },

      -- NORMAL mode mappings
      {
        mode = { "n" },
        nowait = true,
        remap = false,
        { "<C-g><C-t>", "<cmd>GpChatNew tabnew<cr>", desc = "New Chat tabnew" },
        { "<C-g><C-v>", "<cmd>GpChatNew vsplit<cr>", desc = "New Chat vsplit" },
        { "<C-g><C-x>", "<cmd>GpChatNew split<cr>", desc = "New Chat split" },
        { "<C-g>a", "<cmd>GpAppend<cr>", desc = "Append (after)" },
        { "<C-g>b", "<cmd>GpPrepend<cr>", desc = "Prepend (before)" },
        { "<C-g>c", "<cmd>GpChatNew<cr>", desc = "New Chat" },
        { "<C-g>f", "<cmd>GpChatFinder<cr>", desc = "Chat Finder" },
        { "<C-g>g", group = "generate into new .." },
        { "<C-g>ge", "<cmd>GpEnew<cr>", desc = "GpEnew" },
        { "<C-g>gn", "<cmd>GpNew<cr>", desc = "GpNew" },
        { "<C-g>gp", "<cmd>GpPopup<cr>", desc = "Popup" },
        { "<C-g>gt", "<cmd>GpTabnew<cr>", desc = "GpTabnew" },
        { "<C-g>gv", "<cmd>GpVnew<cr>", desc = "GpVnew" },
        { "<C-g>n", "<cmd>GpNextAgent<cr>", desc = "Next Agent" },
        { "<C-g>r", "<cmd>GpRewrite<cr>", desc = "Inline Rewrite" },
        { "<C-g>s", "<cmd>GpStop<cr>", desc = "GpStop" },
        { "<C-g>t", "<cmd>GpChatToggle<cr>", desc = "Toggle Chat" },
        -- { "<C-g>w", group = "Whisper", icon = "󰗋" },
        -- { "<C-g>wa", "<cmd>GpWhisperAppend<cr>", desc = "[W]hisper [A]ppend" },
        -- { "<C-g>wb", "<cmd>GpWhisperPrepend<cr>", desc = "[W]hisper [P]repend" },
        -- { "<C-g>we", "<cmd>GpWhisperEnew<cr>", desc = "[W]hisper Enew" },
        -- { "<C-g>wn", "<cmd>GpWhisperNew<cr>", desc = "[W]hisper New" },
        -- { "<C-g>wp", "<cmd>GpWhisperPopup<cr>", desc = "[W]hisper Popup" },
        -- { "<C-g>wr", "<cmd>GpWhisperRewrite<cr>", desc = "[W]hisper Inline Rewrite" },
        -- { "<C-g>wt", "<cmd>GpWhisperTabnew<cr>", desc = "[W]hisper Tabnew" },
        -- { "<C-g>wv", "<cmd>GpWhisperVnew<cr>", desc = "[W]hisper Vnew" },
        -- { "<C-g>ww", "<cmd>GpWhisper<cr>", desc = "[W]hisper" },
        { "<C-g>x", "<cmd>GpContext<cr>", desc = "Toggle GpContext" },
      },

      -- INSERT mode mappings
      {
        mode = { "i" },
        nowait = true,
        remap = false,
        { "<C-g><C-t>", "<cmd>GpChatNew tabnew<cr>", desc = "New Chat tabnew" },
        { "<C-g><C-v>", "<cmd>GpChatNew vsplit<cr>", desc = "New Chat vsplit" },
        { "<C-g><C-x>", "<cmd>GpChatNew split<cr>", desc = "New Chat split" },
        { "<C-g>a", "<cmd>GpAppend<cr>", desc = "Append (after)" },
        { "<C-g>b", "<cmd>GpPrepend<cr>", desc = "Prepend (before)" },
        { "<C-g>c", "<cmd>GpChatNew<cr>", desc = "New Chat" },
        { "<C-g>f", "<cmd>GpChatFinder<cr>", desc = "Chat Finder" },
        { "<C-g>g", group = "generate into new .." },
        { "<C-g>ge", "<cmd>GpEnew<cr>", desc = "GpEnew" },
        { "<C-g>gn", "<cmd>GpNew<cr>", desc = "GpNew" },
        { "<C-g>gp", "<cmd>GpPopup<cr>", desc = "Popup" },
        { "<C-g>gt", "<cmd>GpTabnew<cr>", desc = "GpTabnew" },
        { "<C-g>gv", "<cmd>GpVnew<cr>", desc = "GpVnew" },
        { "<C-g>n", "<cmd>GpNextAgent<cr>", desc = "Next Agent" },
        { "<C-g>r", "<cmd>GpRewrite<cr>", desc = "Inline Rewrite" },
        { "<C-g>s", "<cmd>GpStop<cr>", desc = "GpStop" },
        { "<C-g>t", "<cmd>GpChatToggle<cr>", desc = "Toggle Chat" },
        -- { "<C-g>w", group = "Whisper" },
        -- { "<C-g>wa", "<cmd>GpWhisperAppend<cr>", desc = "Whisper Append (after)" },
        -- { "<C-g>wb", "<cmd>GpWhisperPrepend<cr>", desc = "Whisper Prepend (before)" },
        -- { "<C-g>we", "<cmd>GpWhisperEnew<cr>", desc = "Whisper Enew" },
        -- { "<C-g>wn", "<cmd>GpWhisperNew<cr>", desc = "Whisper New" },
        -- { "<C-g>wp", "<cmd>GpWhisperPopup<cr>", desc = "Whisper Popup" },
        -- { "<C-g>wr", "<cmd>GpWhisperRewrite<cr>", desc = "Whisper Inline Rewrite" },
        -- { "<C-g>wt", "<cmd>GpWhisperTabnew<cr>", desc = "Whisper Tabnew" },
        -- { "<C-g>wv", "<cmd>GpWhisperVnew<cr>", desc = "Whisper Vnew" },
        -- { "<C-g>ww", "<cmd>GpWhisper<cr>", desc = "Whisper" },
        { "<C-g>x", "<cmd>GpContext<cr>", desc = "Toggle GpContext" },
      },
    })
  end,
}
