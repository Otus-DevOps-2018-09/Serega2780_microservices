.PHONY: all make_images push_images
all: make_images push_images
USER_NAME = 270580
make_images:
		for i in ui post-py comment; do \
			cd src/$$i; \
			echo `git show --format="%h" HEAD | head -1` > build_info.txt; \
			echo `git rev-parse --abbrev-ref HEAD` >> build_info.txt; \
			docker build -t $(USER_NAME)/$$i .; \
			cd -; \
		done
		cd ./monitoring/prometheus; \
		docker build -t $(USER_NAME)/prometheus .; \
		cd -; cd ./monitoring/alertmanager; \
		docker build -t $(USER_NAME)/alertmanager .; cd -;


push_images:
		docker tag $(USER_NAME)/post-py $(USER_NAME)/post
		docker rmi $(USER_NAME)/post-py
		docker push $(USER_NAME)/ui
		docker push $(USER_NAME)/comment
		docker push $(USER_NAME)/post
		docker push $(USER_NAME)/prometheus
		docker push $(USER_NAME)/alertmanager		  

