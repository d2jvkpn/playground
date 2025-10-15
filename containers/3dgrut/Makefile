build:
	bash build.sh

run:
	docker run -d --name 3dgrut --net=host --ipc=host --gpus=all --runtime=nvidia \
	  -v $PWD/data:/workspace/data -e DISPLAY local/3dgrut: sleep infinity

exec:
	docker exec -it 3dgrut bash
