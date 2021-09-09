-- I like using Bang creation like vim-rails does
vim.g.CorpusBangCreation = 1
-- My default directory
CorpusDirectories = {
  ['~/Documents/Corpus'] = {
    autocommit = true,
    autreferences = 1,
    autotitle = 1,
    base = './',
    transform = 'local',
  }
}
