Plug 'tpope/vim-rails'

" Since you cannot create an alternate file, we will try to make our own.
command! Coverage :Dispatch COVERAGE=true bundle exec rails test
command! Rubycritic :Dispatch! bundle exec rubycritic
command! Critic :Dispatch! critic
