role: plugins/lookup/pass/lookup_plugins/pass.py
	mkdir -p tests/roles
	rm -f tests/roles/gcoop-libre.mysqldump
	cd tests/roles && ln -s ../../. gcoop-libre.mysqldump
	cd ..
	ansible-playbook -vv -i tests/inventory tests/test.yml

plugins/lookup/pass/lookup_plugins/pass.py:
	mkdir -p plugins/lookup
	git clone https://github.com/gcoop-libre/ansible-lookup-plugin-pass.git plugins/lookup/pass

