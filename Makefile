build:
		protoc -I. --go_out=plugins=micro:. proto/vessel/vessel.proto
		go mod vendor
		git add --all
		git diff-index --quiet HEAD || git commit -a -m 'fix'
		git push origin master

registry:
		docker build -t eu.gcr.io/my-project-tattoor/vessel-service:latest .
		gcloud docker -- push eu.gcr.io/my-project-tattoor/vessel-service:latest

deploy:
	protoc -I. --go_out=plugins=micro:. proto/vessel/vessel.proto
	sed "s/{{ UPDATED_AT }}/$(shell date)/g" ./deployments/deployment.tmpl > ./deployments/deployment.yml
	go mod vendor
	git add --all
	git diff-index --quiet HEAD || git commit -a -m 'fix'
	git push origin master
	docker build -t eu.gcr.io/my-project-tattoor/vessel-service:latest .
	gcloud docker -- push eu.gcr.io/my-project-tattoor/vessel-service:latest
	kubectl replace -f ./deployments/deployment.yml