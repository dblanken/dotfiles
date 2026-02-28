return {
	{
		"skywind3000/vim-gpt-commit",
		config = function()
			-- if you don't want to set your api key directly, add to your .zshrc:
			-- export OPENAI_API_KEY='sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
			--vim.g.gpt_commit_key = os.getenv("OPENAI_API_KEY")
			-- uncomment this line below to enable proxy
			-- vim.g.gpt_commit_proxy = 'socks5://127.0.0.1:1080'

			-- uncomment the following lines if you want to use Ollama:
			vim.g.gpt_commit_engine = "ollama"
			vim.g.gpt_commit_ollama_url = "http://127.0.0.1:11434/api/chat"
			vim.g.gpt_commit_ollama_model = "llama3"
		end,
	},
}
