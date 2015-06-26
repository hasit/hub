# Fish shell completion script for hub
# Inspired by git.fish
# ('git' + 'hub') commands added

# TODO
# Snippet type thing. 'hub create [name]' where [name] should be in grey and suppress the smart suggesstions from fish.
# 'hub help <tab>' should show a list of commands that help is available for.

##################
# helper functions
##################

function __fish_hub_branches
  command git branch --no-color -a ^/dev/null | sgrep -v ' -> ' | sed -e 's/^..//' -e 's/^remotes\///'
end

function __fish_hub_tags
  command git tag
end

function __fish_hub_heads
  __fish_hub_branches
  __fish_hub_tags
end

function __fish_hub_remotes
  command git remote
end

function __fish_hub_modified_files
    command git status -s | grep -e "^ M" | sed "s/^ M //"
end

function __fish_hub_ranges
  set -l from (commandline -ot | perl -ne 'if (index($_, "..") > 0) { my @parts = split(/\.\./); print $parts[0]; }')
  if test -z "$from"
    __fish_hub_branches
    return 0
  end

  set -l to (commandline -ot | perl -ne 'if (index($_, "..") > 0) { my @parts = split(/\.\./); print $parts[1]; }')
  for from_ref in (__fish_hub_heads | sgrep -e "$from")
    for to_ref in (__fish_hub_heads | sgrep -e "$to")
      printf "%s..%s\n" $from_ref $to_ref
    end
  end
end

# statement starting with 'hub'
function __fish_hub_needs_command
    set cmd (commandline -opc)
    if [ (count $cmd) -eq 1 -a $cmd[1] = 'hub' ]
        return 0
    end
    return 1
end

# statement starting with 'hub COMMAND'
function __fish_hub_using_command
    set cmd (commandline -opc)
    if [ (count $cmd) -gt 1 ]
        if [ $argv[1] = $cmd[2] ]
            return 0
        end
    end
    return 1
end


##############
# git commands
##############

# init
complete -f -c hub -n '__fish_hub_needs_command' -a init -d 'Create a git repository as with git-init(1)'
complete -f -c hub -n '__fish_hub_using_command init' -s g -d 'Add remote origin at "git@github.com:USER/REPOSITORY.git"'
complete -f -c hub -n '__fish_hub_using_command init' -s q -l quiet -d 'Only print error and warning messages'
complete -f -c hub -n '__fish_hub_using_command init' -l bare -d 'Create a bare repository'
complete -c hub -n '__fish_hub_using_command init' -l template= -d 'Specify the directory from which templates will be used'
complete -c hub -n '__fish_hub_using_command init' -l separate-git-dir= -d 'Create a text file containing the path to the actual repository'
complete -f -c hub -n '__fish_hub_using_command init' -l shared -d 'Specify that the Git repository is to be shared amongst several users'

# clone
complete -f -c hub -n '__fish_hub_needs_command' -a clone -d 'Clone a repository into a new directory'
complete -f -c hub -n '__fish_hub_using_command clone' -s p -d 'Select the ssh protocol unconditionally'
complete -f -c hub -n '__fish_hub_using_command clone' -s l -l local -d 'Clone repository from local machine'
complete -f -c hub -n '__fish_hub_using_command clone' -l no-hardlinks -d 'Use .git/objects directory instead of hardlinks'
complete -f -c hub -n '__fish_hub_using_command clone' -s s -l shared -d 'Setup .git/objects/info/alternates to share the objects with the source repository'
complete -c hub -n '__fish_hub_using_command clone' -l reference -d 'Obtain objects from the reference repository'
complete -f -c hub -n '__fish_hub_using_command clone' -l dissociate -d 'Borrow the objects from reference repositories specified with the --reference options'
complete -f -c hub -n '__fish_hub_using_command clone' -s q -l quiet -d 'Operate quietly'
complete -f -c hub -n '__fish_hub_using_command clone' -s v -l verbose -d 'Run verbosely'
complete -f -c hub -n '__fish_hub_using_command clone' -l progress -d 'Progress status is reported on the standard error stream'
complete -f -c hub -n '__fish_hub_using_command clone' -s n -l no-checkout -d 'No checkout of HEAD is performed after the clone is complete'
complete -f -c hub -n '__fish_hub_using_command clone' -l bare -d 'Make a bare git repository'
complete -f -c hub -n '__fish_hub_using_command clone' -l mirror -d 'Set up a mirror of the source repository'
complete -f -c hub -n '__fish_hub_using_command clone' -s o -l origin -d 'Provide remote origing name to track upstream repository'
complete -f -c hub -n '__fish_hub_using_command clone' -s b -l branch -d 'Point to the provided branch name'
complete -f -c hub -n '__fish_hub_using_command clone' -s u -l upload-pack
complete -f -c hub -n '__fish_hub_using_command clone' -l template= -d 'Specify the directory from which templates will be used'
complete -f -c hub -n '__fish_hub_using_command clone' -s c -l config -d 'Set a configuration variable in the newly-created repository'
complete -f -c hub -n '__fish_hub_using_command clone' -l depth -d 'Create a shallow clone with a history truncated to the specified number of revisions'
complete -f -c hub -n '__fish_hub_using_command clone' -l single-branch -d 'Clone only the history leading to the tip of a single branch'
complete -f -c hub -n '__fish_hub_using_command clone' -l no-single-branch
complete -f -c hub -n '__fish_hub_using_command clone' -l recursive -d 'Initialize all submodules within clone using their default settings'
complete -f -c hub -n '__fish_hub_using_command clone' -l separate-git-dir= -d 'Place the cloned repository at the specified directory'

# fetch
complete -f -c hub -n '__fish_hub_needs_command' -a fetch -d 'Download objects and refs from another repository'
complete -f -c hub -n '__fish_hub_using_command fetch' -a '(__fish_hub_remotes)' -d 'Remote'
complete -f -c hub -n '__fish_hub_using_command fetch' -s q -l quiet -d 'Be quiet'
complete -f -c hub -n '__fish_hub_using_command fetch' -s v -l verbose -d 'Be verbose'
complete -f -c hub -n '__fish_hub_using_command fetch' -s a -l append -d 'Append ref names and object names'
complete -f -c hub -n '__fish_hub_using_command fetch' -s f -l force -d 'Force update of local branches'
# TODO other options

# remote
complete -f -c hub -n '__fish_hub_needs_command' -a remote -d 'Manage set of tracked repositories'
complete -f -c hub -n '__fish_hub_using_command remote' -a '(__fish_hub_remotes)'
complete -f -c hub -n '__fish_hub_using_command remote' -s v -l verbose -d 'Be verbose'
complete -f -c hub -n '__fish_hub_using_command remote' -a add -d 'Adds a new remote'
complete -f -c hub -n '__fish_hub_using_command remote' -a rm -d 'Removes a remote'
complete -f -c hub -n '__fish_hub_using_command remote' -a show -d 'Shows a remote'
complete -f -c hub -n '__fish_hub_using_command remote' -a prune -d 'Deletes all stale tracking branches'
complete -f -c hub -n '__fish_hub_using_command remote' -a update -d 'Fetches updates'
# TODO options

# show
complete -f -c hub -n '__fish_hub_needs_command' -a show -d 'Shows the last commit of a branch'
complete -f -c hub -n '__fish_hub_using_command show' -a '(__fish_hub_branches)' -d 'Branch'
# TODO options

# show-branch
complete -f -c hub -n '__fish_hub_needs_command' -a show-branch -d 'Shows the commits on branches'
complete -f -c hub -n '__fish_hub_using_command show-branch' -a '(__fish_hub_heads)' --description 'Branch'
# TODO options

# add
complete -c hub -n '__fish_hub_needs_command'    -a add -d 'Add file contents to the index'
complete -c hub -n '__fish_hub_using_command add' -s n -l dry-run -d "Don't actually add the file(s)"
complete -c hub -n '__fish_hub_using_command add' -s v -l verbose -d 'Be verbose'
complete -c hub -n '__fish_hub_using_command add' -s f -l force -d 'Allow adding otherwise ignored files'
complete -c hub -n '__fish_hub_using_command add' -s i -l interactive -d 'Interactive mode'
complete -c hub -n '__fish_hub_using_command add' -s p -l patch -d 'Interactively choose hunks to stage'
complete -c hub -n '__fish_hub_using_command add' -s e -l edit -d 'Manually create a patch'
complete -c hub -n '__fish_hub_using_command add' -s u -l update -d 'Only match tracked files'
complete -c hub -n '__fish_hub_using_command add' -s A -l all -d 'Match files both in working tree and index'
complete -c hub -n '__fish_hub_using_command add' -s N -l intent-to-add -d 'Record only the fact that the path will be added later'
complete -c hub -n '__fish_hub_using_command add' -l refresh -d "Don't add the file(s), but only refresh their stat"
complete -c hub -n '__fish_hub_using_command add' -l ignore-errors -d 'Ignore errors'
complete -c hub -n '__fish_hub_using_command add' -l ignore-missing -d 'Check if any of the given files would be ignored'
complete -f -c hub -n '__fish_hub_using_command add; and __fish_contains_opt -s p patch' -a '(__fish_hub_modified_files)'
# TODO options

# checkout
complete -f -c hub -n '__fish_hub_needs_command'    -a checkout -d 'Checkout and switch to a branch'
complete -f -c hub -n '__fish_hub_using_command checkout'  -a '(__fish_hub_branches)' --description 'Branch'
complete -f -c hub -n '__fish_hub_using_command checkout'  -a '(__fish_hub_tags)' --description 'Tag'
complete -f -c hub -n '__fish_hub_using_command checkout' -s b -d 'Create a new branch'
complete -f -c hub -n '__fish_hub_using_command checkout' -s t -l track -d 'Track a new branch'
# TODO options

# apply
complete -f -c hub -n '__fish_hub_needs_command' -a apply -d 'Apply a patch on a git index file and a working tree'
# TODO options

# archive
complete -f -c hub -n '__fish_hub_needs_command' -a archive -d 'Create an archive of files from a named tree'
# TODO options

# bisect
complete -f -c hub -n '__fish_hub_needs_command' -a bisect -d 'Find the change that introduced a bug by binary search'
# TODO options

# branch
complete -f -c hub -n '__fish_hub_needs_command' -a branch -d 'List, create, or delete branches'
complete -f -c hub -n '__fish_hub_using_command branch' -a '(__fish_hub_branches)' -d 'Branch'
complete -f -c hub -n '__fish_hub_using_command branch' -s d -d 'Delete branch'
complete -f -c hub -n '__fish_hub_using_command branch' -s D -d 'Force deletion of branch'
complete -f -c hub -n '__fish_hub_using_command branch' -s m -d 'Rename branch'
complete -f -c hub -n '__fish_hub_using_command branch' -s M -d 'Force renaming branch'
complete -f -c hub -n '__fish_hub_using_command branch' -s a -d 'Lists both local and remote branches'
complete -f -c hub -n '__fish_hub_using_command branch' -s t -l track -d 'Track remote branch'
complete -f -c hub -n '__fish_hub_using_command branch' -l no-track -d 'Do not track remote branch'
complete -f -c hub -n '__fish_hub_using_command branch' -l set-upstream -d 'Set remote branch to track'

# cherry-pick
complete -f -c hub -n '__fish_hub_needs_command' -a cherry-pick -d 'Apply the change introduced by an existing commit'
complete -f -c hub -n '__fish_hub_using_command cherry-pick' -a '(__fish_hub_branches)' -d 'Branch'
# TODO options

# commit
complete -c hub -n '__fish_hub_needs_command'    -a commit -d 'Record changes to the repository'
complete -c hub -n '__fish_hub_using_command commit' -l amend -d 'Amend the log message of the last commit'
# TODO options

# diff
complete -c hub -n '__fish_hub_needs_command'    -a diff -d 'Show changes between commits, commit and working tree, etc'
complete -c hub -n '__fish_hub_using_command diff' -a '(__fish_hub_ranges)' -d 'Branch'
complete -c hub -n '__fish_hub_using_command diff' -l cached -d 'Show diff of changes in the index'
# TODO options

# difftool
complete -c hub -n '__fish_hub_needs_command'    -a difftool -d 'Open diffs in a visual tool'
complete -c hub -n '__fish_hub_using_command difftool' -a '(__fish_hub_ranges)' -d 'Branch'
complete -c hub -n '__fish_hub_using_command difftool' -l cached -d 'Visually show diff of changes in the index'
# TODO options

# grep
complete -c hub -n '__fish_hub_needs_command' -a grep -d 'Print lines matching a pattern'
# TODO options

# init
complete -f -c hub -n '__fish_hub_needs_command' -a init -d 'Create an empty git repository or reinitialize an existing one'
# TODO options

# log
complete -c hub -n '__fish_hub_needs_command'    -a log -d 'Show commit logs'
complete -c hub -n '__fish_hub_using_command log' -a '(__fish_hub_heads) (__fish_hub_ranges)' -d 'Branch'
complete -f -c hub -n '__fish_hub_using_command log' -l pretty -a 'oneline short medium full fuller email raw format:'
# TODO options

# merge
complete -f -c hub -n '__fish_hub_needs_command' -a merge -d 'Join two or more development histories together'
complete -f -c hub -n '__fish_hub_using_command merge' -a '(__fish_hub_branches)' -d 'Branch'
complete -f -c hub -n '__fish_hub_using_command merge' -l commit -d "Autocommit the merge"
complete -f -c hub -n '__fish_hub_using_command merge' -l no-commit -d "Don't autocommit the merge"
complete -f -c hub -n '__fish_hub_using_command merge' -l edit -d 'Edit auto-generated merge message'
complete -f -c hub -n '__fish_hub_using_command merge' -l no-edit -d "Don't edit auto-generated merge message"
complete -f -c hub -n '__fish_hub_using_command merge' -l ff -d "Don't generate a merge commit if merge is fast-forward"
complete -f -c hub -n '__fish_hub_using_command merge' -l no-ff -d "Generate a merge commit even if merge is fast-forward"
complete -f -c hub -n '__fish_hub_using_command merge' -l ff-only -d 'Refuse to merge unless fast-forward possible'
complete -f -c hub -n '__fish_hub_using_command merge' -l log -d 'Populate the log message with one-line descriptions'
complete -f -c hub -n '__fish_hub_using_command merge' -l no-log -d "Don't populate the log message with one-line descriptions"
complete -f -c hub -n '__fish_hub_using_command merge' -l stat -d "Show diffstat of the merge"
complete -f -c hub -n '__fish_hub_using_command merge' -s n -l no-stat -d "Don't show diffstat of the merge"
complete -f -c hub -n '__fish_hub_using_command merge' -l squash -d "Squash changes from other branch as a single commit"
complete -f -c hub -n '__fish_hub_using_command merge' -l no-squash -d "Don't squash changes"
complete -f -c hub -n '__fish_hub_using_command merge' -s q -l quiet -d 'Be quiet'
complete -f -c hub -n '__fish_hub_using_command merge' -s v -l verbose -d 'Be verbose'
complete -f -c hub -n '__fish_hub_using_command merge' -l progress -d 'Force progress status'
complete -f -c hub -n '__fish_hub_using_command merge' -l no-progress -d 'Force no progress status'
complete -f -c hub -n '__fish_hub_using_command merge' -s m -d 'Set the commit message'
complete -f -c hub -n '__fish_hub_using_command merge' -l abort -d 'Abort the current conflict resolution process'
# TODO options

# mv
complete -c hub -n '__fish_hub_needs_command'    -a mv -d 'Move or rename a file, a directory, or a symlink'
# TODO options

# prune
complete -f -c hub -n '__fish_hub_needs_command' -a prune -d 'Prune all unreachable objects from the object database'
# TODO options

# pull
complete -f -c hub -n '__fish_hub_needs_command' -a pull -d 'Fetch from and merge with another repository or a local branch'
complete -f -c hub -n '__fish_hub_using_command pull' -s q -l quiet -d 'Be quiet'
complete -f -c hub -n '__fish_hub_using_command pull' -s v -l verbose -d 'Be verbose'
complete -f -c hub -n '__fish_hub_using_command pull' -l all -d 'Fetch all remotes'
complete -f -c hub -n '__fish_hub_using_command pull' -s a -l append -d 'Append ref names and object names'
complete -f -c hub -n '__fish_hub_using_command pull' -s f -l force -d 'Force update of local branches'
complete -f -c hub -n '__fish_hub_using_command pull' -s k -l keep -d 'Keep downloaded pack'
complete -f -c hub -n '__fish_hub_using_command pull' -l no-tags -d 'Disable automatic tag following'
complete -f -c hub -n '__fish_hub_using_command pull' -l progress -d 'Force progress status'
complete -f -c hub -n '__fish_hub_using_command pull' -a '(git remote)' -d 'Remote alias'
complete -f -c hub -n '__fish_hub_using_command pull' -a '(__fish_hub_branches)' -d 'Branch'
# TODO other options

# push
complete -f -c hub -n '__fish_hub_needs_command' -a push -d 'Update remote refs along with associated objects'
complete -f -c hub -n '__fish_hub_using_command push' -a '(git remote)' -d 'Remote alias'
complete -f -c hub -n '__fish_hub_using_command push' -a '(__fish_hub_branches)' -d 'Branch'
complete -f -c hub -n '__fish_hub_using_command push' -l all -d 'Push all refs under refs/heads/'
complete -f -c hub -n '__fish_hub_using_command push' -l prune -d "Remove remote branches that don't have a local counterpart"
complete -f -c hub -n '__fish_hub_using_command push' -l mirror -d 'Push all refs under refs/'
complete -f -c hub -n '__fish_hub_using_command push' -l delete -d 'Delete all listed refs from the remote repository'
complete -f -c hub -n '__fish_hub_using_command push' -l tags -d 'Push all refs under refs/tags'
complete -f -c hub -n '__fish_hub_using_command push' -s n -l dry-run -d 'Do everything except actually send the updates'
complete -f -c hub -n '__fish_hub_using_command push' -l porcelain -d 'Produce machine-readable output'
complete -f -c hub -n '__fish_hub_using_command push' -s f -l force -d 'Force update of remote refs'
complete -f -c hub -n '__fish_hub_using_command push' -s u -l set-upstream -d 'Add upstream (tracking) reference'
complete -f -c hub -n '__fish_hub_using_command push' -s q -l quiet -d 'Be quiet'
complete -f -c hub -n '__fish_hub_using_command push' -s v -l verbose -d 'Be verbose'
complete -f -c hub -n '__fish_hub_using_command push' -l progress -d 'Force progress status'
# TODO --recurse-submodules=check|on-demand

# rebase
complete -f -c hub -n '__fish_hub_needs_command' -a rebase -d 'Forward-port local commits to the updated upstream head'
complete -f -c hub -n '__fish_hub_using_command rebase' -a '(git remote)' -d 'Remote alias'
complete -f -c hub -n '__fish_hub_using_command rebase' -a '(__fish_hub_branches)' -d 'Branch'
complete -f -c hub -n '__fish_hub_using_command rebase' -l continue -d 'Restart the rebasing process'
complete -f -c hub -n '__fish_hub_using_command rebase' -l abort -d 'Abort the rebase operation'
complete -f -c hub -n '__fish_hub_using_command rebase' -l keep-empty -d "Keep the commits that don't cahnge anything"
complete -f -c hub -n '__fish_hub_using_command rebase' -l skip -d 'Restart the rebasing process by skipping the current patch'
complete -f -c hub -n '__fish_hub_using_command rebase' -s m -l merge -d 'Use merging strategies to rebase'
complete -f -c hub -n '__fish_hub_using_command rebase' -s q -l quiet -d 'Be quiet'
complete -f -c hub -n '__fish_hub_using_command rebase' -s v -l verbose -d 'Be verbose'
complete -f -c hub -n '__fish_hub_using_command rebase' -l stat -d "Show diffstat of the rebase"
complete -f -c hub -n '__fish_hub_using_command rebase' -s n -l no-stat -d "Don't show diffstat of the rebase"
complete -f -c hub -n '__fish_hub_using_command rebase' -l verify -d "Allow the pre-rebase hook to run"
complete -f -c hub -n '__fish_hub_using_command rebase' -l no-verify -d "Don't allow the pre-rebase hook to run"
complete -f -c hub -n '__fish_hub_using_command rebase' -s f -l force-rebase -d 'Force the rebase'
complete -f -c hub -n '__fish_hub_using_command rebase' -s i -l interactive -d 'Interactive mode'
complete -f -c hub -n '__fish_hub_using_command rebase' -s p -l preserve-merges -d 'Try to recreate merges'
complete -f -c hub -n '__fish_hub_using_command rebase' -l root -d 'Rebase all reachable commits'
complete -f -c hub -n '__fish_hub_using_command rebase' -l autosquash -d 'Automatic squashing'
complete -f -c hub -n '__fish_hub_using_command rebase' -l no-autosquash -d 'No automatic squashing'
complete -f -c hub -n '__fish_hub_using_command rebase' -l no-ff -d 'No fast-forward'

# reset
complete -c hub -n '__fish_hub_needs_command'    -a reset -d 'Reset current HEAD to the specified state'
complete -f -c hub -n '__fish_hub_using_command reset' -l hard -d 'Reset files in working directory'
complete -c hub -n '__fish_hub_using_command reset' -a '(__fish_hub_branches)'
# TODO options

# revert
complete -f -c hub -n '__fish_hub_needs_command' -a revert -d 'Revert an existing commit'
# TODO options

# rm
complete -c hub -n '__fish_hub_needs_command'    -a rm     -d 'Remove files from the working tree and from the index'
complete -c hub -n '__fish_hub_using_command rm' -f
complete -c hub -n '__fish_hub_using_command rm' -l cached -d 'Keep local copies'
complete -c hub -n '__fish_hub_using_command rm' -l ignore-unmatch -d 'Exit with a zero status even if no files matched'
complete -c hub -n '__fish_hub_using_command rm' -s r -d 'Allow recursive removal'
complete -c hub -n '__fish_hub_using_command rm' -s q -l quiet -d 'Be quiet'
complete -c hub -n '__fish_hub_using_command rm' -s f -l force -d 'Override the up-to-date check'
complete -c hub -n '__fish_hub_using_command rm' -s n -l dry-run -d 'Dry run'
# TODO options

# status
complete -f -c hub -n '__fish_hub_needs_command' -a status -d 'Show the working tree status'
complete -f -c hub -n '__fish_hub_using_command status' -s s -l short -d 'Give the output in the short-format'
complete -f -c hub -n '__fish_hub_using_command status' -s b -l branch -d 'Show the branch and tracking info even in short-format'
complete -f -c hub -n '__fish_hub_using_command status'      -l porcelain -d 'Give the output in a stable, easy-to-parse format'
complete -f -c hub -n '__fish_hub_using_command status' -s z -d 'Terminate entries with null character'
complete -f -c hub -n '__fish_hub_using_command status' -s u -l untracked-files -x -a 'no normal all' -d 'The untracked files handling mode'
complete -f -c hub -n '__fish_hub_using_command status' -l ignore-submodules -x -a 'none untracked dirty all' -d 'Ignore changes to submodules'
# TODO options

# tag
complete -f -c hub -n '__fish_hub_needs_command' -a tag -d 'Create, list, delete or verify a tag object signed with GPG'
complete -f -c hub -n '__fish_hub_using_command tag; and __fish_not_contain_opt -s d; and __fish_not_contain_opt -s v; and test (count (commandline -opc | sgrep -v -e \'^-\')) -eq 3' -a '(__fish_hub_branches)' -d 'Branch'
complete -f -c hub -n '__fish_hub_using_command tag' -s a -l annotate -d 'Make an unsigned, annotated tag object'
complete -f -c hub -n '__fish_hub_using_command tag' -s s -l sign -d 'Make a GPG-signed tag'
complete -f -c hub -n '__fish_hub_using_command tag' -s d -l delete -d 'Remove a tag'
complete -f -c hub -n '__fish_hub_using_command tag' -s v -l verify -d 'Verify signature of a tag'
complete -f -c hub -n '__fish_hub_using_command tag' -s f -l force -d 'Force overwriting exising tag'
complete -f -c hub -n '__fish_hub_using_command tag' -s l -l list -d 'List tags'
complete -f -c hub -n '__fish_contains_opt -s d' -a '(__fish_hub_tags)' -d 'Tag'
complete -f -c hub -n '__fish_contains_opt -s v' -a '(__fish_hub_tags)' -d 'Tag'
# TODO options

# stash
complete -c hub -n '__fish_hub_needs_command' -a stash -d 'Stash away changes'
complete -f -c hub -n '__fish_hub_using_command stash' -a list -d 'List stashes'
complete -f -c hub -n '__fish_hub_using_command stash' -a show -d 'Show the changes recorded in the stash'
complete -f -c hub -n '__fish_hub_using_command stash' -a pop -d 'Apply and remove a single stashed state'
complete -f -c hub -n '__fish_hub_using_command stash' -a apply -d 'Apply a single stashed state'
complete -f -c hub -n '__fish_hub_using_command stash' -a clear -d 'Remove all stashed states'
complete -f -c hub -n '__fish_hub_using_command stash' -a drop -d 'Remove a single stashed state from the stash list'
complete -f -c hub -n '__fish_hub_using_command stash' -a create -d 'Create a stash'
complete -f -c hub -n '__fish_hub_using_command stash' -a save -d 'Save a new stash'
complete -f -c hub -n '__fish_hub_using_command stash' -a branch -d 'Create a new branch from a stash'
# TODO other options

# config
complete -f -c hub -n '__fish_hub_needs_command' -a config -d 'Set and read git configuration variables'
# TODO options

# format-patch
complete -f -c hub -n '__fish_hub_needs_command' -a format-patch -d 'Generate patch series to send upstream'
complete -f -c hub -n '__fish_hub_using_command format-patch' -a '(__fish_hub_branches)' -d 'Branch'

## git submodule
complete -f -c hub -n '__fish_hub_needs_command' -a submodule -d 'Initialize, update or inspect submodules'
complete -f -c hub -n '__fish_hub_using_command submodule' -a 'add' -d 'Add a submodule'
complete -f -c hub -n '__fish_hub_using_command submodule' -a 'status' -d 'Show submodule status'
complete -f -c hub -n '__fish_hub_using_command submodule' -a 'init' -d 'Initialize all submodules'
complete -f -c hub -n '__fish_hub_using_command submodule' -a 'update' -d 'Update all submodules'
complete -f -c hub -n '__fish_hub_using_command submodule' -a 'summary' -d 'Show commit summary'
complete -f -c hub -n '__fish_hub_using_command submodule' -a 'foreach' -d 'Run command on each submodule'
complete -f -c hub -n '__fish_hub_using_command submodule' -a 'sync' -d 'Sync submodules\' URL with .gitmodules'

## git whatchanged
complete -f -c hub -n '__fish_hub_needs_command' -a whatchanged -d 'Show logs with difference each commit introduces'


###############
## hub commands
###############

# help
complete -f -c hub -n '__fish_hub_needs_command' -a help -d 'Display enhanced git-help(1)'
complete -f -c hub -n 'not __fish_hub_needs_command' -l help -d 'Display enhanced git-help(1)'
complete -f -c hub -n '__fish_hub_needs_command' -l help -d 'Display enhanced git-help(1)'

# noop
complete -f -c hub -n '__fish_hub_needs_command' -l noop -d 'Shows which command(s) would be run as a result of the current command'

# alias
complete -f -c hub -n '__fish_hub_needs_command' -a alias -d 'Shows shell instructions for wrapping git.'
complete -f -c hub -n '__fish_hub_using_command alias' -s s -d 'Output shell script suitable for eval'

# create
complete -f -c hub -n '__fish_hub_needs_command' -a create -d 'Create repository on Github and add Github as remote'
complete -f -c hub -n '__fish_hub_using_command create' -s p -d 'Create private repository'
complete -f -c hub -n '__fish_hub_using_command create' -s d -d 'Set description of repository'
complete -f -c hub -n '__fish_hub_using_command create' -s h -d 'Set homepage of repository'

# browse
complete -f -c hub -n '__fish_hub_needs_command' -a browse -d 'Open a GitHub page in the default browser'
complete -f -c hub -n '__fish_hub_using_command browse' -s u -d 'Output the URL rather than opening the browser'

# compare
complete -f -c hub -n '__fish_hub_needs_command' -a compare -d 'Open compare page on GitHub'
complete -f -c hub -n '__fish_hub_using_command compare' -s u -d 'Output the URL rather than opening the browser'

# fork
complete -f -c hub -n '__fish_hub_needs_command' -a fork -d 'Fork the original project on GitHub under your username'
complete -f -c hub -n '__fish_hub_using_command fork' -l no-remote -d 'Fork the original project with no remote'

# pull-request
complete -f -c hub -n '__fish_hub_needs_command' -a pull-request -d 'Open a pull request on GitHub'
complete -f -c hub -n '__fish_hub_using_command pull-request' -s o -l browse -d 'Open pull-request page on GitHub'
complete -f -c hub -n '__fish_hub_using_command pull-request' -s f -d 'Skip checking local commits that are not yet pushed'
complete -f -c hub -n '__fish_hub_using_command pull-request' -s m -d 'Message for pull-request'
complete -c hub -n '__fish_hub_using_command pull-request' -s f -d 'Message for pull-request from file'
complete -f -c hub -n '__fish_hub_using_command pull-request' -s i -d 'Provide issue number/issue URL for attaching to an existing pull-request'
complete -f -c hub -n '__fish_hub_using_command pull-request' -s b -d 'Specify BASE for pull-request'
complete -f -c hub -n '__fish_hub_using_command pull-request' -s h -d 'Specify HEAD for pull-request'

# ci-status
complete -f -c hub -n '__fish_hub_needs_command' -a ci-status -d 'Look up the SHA for commit in GitHub Status API and displays the latest status'
complete -f -c hub -n '__fish_hub_using_command ci-status' -s v -d 'Print the URL to CI build results'
