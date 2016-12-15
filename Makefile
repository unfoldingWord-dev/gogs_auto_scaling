stat:
	git status -s

test:
	find ./ -name '*.pp' -print -exec puppet parser validate {} \;

apply:
	puppet apply /etc/puppet/manifests/site.pp --summarize

commit: stat
	git diff >/tmp/git-diff.out 2>&1
	git commit -a
	git pull --no-edit origin master
	git push origin master

deploy:
	puppet apply /etc/puppet/manifests/site.pp -e 'include gogs' --summarize
