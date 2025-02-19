IMAGE_NAME=imshakil/flask-app
KUBE_NAMESPACE=default

all: build push deploy

build:
	docker build -t $(IMAGE_NAME) .
push:
	docker push $(IMAGE_NAME)
deploy:
	kubectl apply -f deployment.yml --namespace $(KUBE_NAMESPACE)
clean:
	kubectl delete -f deployment.yml --namespace $(KUBE_NAMESPACE)
.PHONY: all build push deploy clean
