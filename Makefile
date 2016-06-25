role:
	mkdir -p tests/roles
	rm -f tests/roles/gcoop.mysqldump
	cd tests/roles && ln -s ../../. gcoop.mysqldump
	cd ..
	ansible-playbook -vv -i tests/inventory tests/test.yml
