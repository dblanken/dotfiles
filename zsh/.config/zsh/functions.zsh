function git-new-remote-tracking {
  git checkout -b $1 && git push -u origin $1
}

function git_branch_name {
  val=`git branch 2>/dev/null | grep '^*' | colrm 1 2`
  echo "$val"
}

function git-done {
  branch=`git_branch_name`
  git checkout master && git merge $branch --ff-only && bundle install && prepdb && bin/rspec && git push && git-nuke $branch
}

function git-nuke {
  git branch -D $1 && git push origin :$1
}
compdef _git git-nuke=git-checkout

function git-on-master {
  branch=`git_branch_name`
  git checkout master && git pull --rebase 
  git checkout $branch
  git rebase master && git push -f
}

function g {
  if [[ $# > 0 ]]; then
    git $@
  else
    git status
  fi
}

function rrg {
  bin/rake routes | grep $1
}

function take {
  mkdir $1
  cd $1
}

# Allows commit message without typing quotes (can't have quotes in the commit msg though).
function gc {
  git commit -m "$*"
}
