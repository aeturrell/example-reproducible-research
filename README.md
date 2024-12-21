# example-reproducible-research

An example repo to demonstrate some principles of reproducible research, including that operations should form a directed acyclic graph, that packages should be pinned (and their dependencies specified), and that the computational environment should be reproducible too.

The project acquires some data, runs a regression, makes a plot, and puts both regression and plot in an automatically generated PDF report.

Make is used to execute the reproducible analytical pipeline, and is part of the Dockerfile. The DAG is

![DAG for this example repo](https://github.com/aeturrell/example-reproducible-research/raw/main/assets/out.png)

The DAG was generated using `make -Bnd | make2graph | dot -Tpng -o assets/out.png` (NB `make2graph` is not contained in the Dockerfile).

To execute the DAG, install Docker, git clone this repo, and then

1. `docker build -t repro .` to build an image from the Dockerfile
2. `docker run -t -d --name repro_run repro` to run the image
3. `docker exec -i -t repro_run /bin/bash` to jump into the image on the command line, or use Visual Studio Code's remote: attach to container option.
4. To (re-run) the analysis within the container, open the `app/` directory (you will need to go up one directory level) and then run `uv run make clean` followed by `uv run make`.

The final output of the project, `report.pdf`, is saved in the outputs folder.

To export the final report out of the docker container and to your current directory, use the following command on your computer (not in the container)

```bash
docker cp repro_run:app/output/report.pdf .
```

To exit a running Docker command line terminal, use ctrl + c, ctrl + d. To remove the image and stop it running, use `docker rm repro_run --force`
