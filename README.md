# Workerd Docker Image

Supported Architectures: `amd64`, `arm64`

This minimalist Docker image allows you to run a Cloudflare Worker inside a Docker container, offering a simple solution for deploying and testing your worker on your infrastructure.

- [Docker Hub](https://hub.docker.com/r/jacoblincool/workerd)
- [GitHub Repository](https://github.com/JacobLinCool/workerd-docker)

## Quick Start Guide

### Selflare

The fastest way to get your Cloudflare Worker running as a Docker container is to use [Selflare](https://github.com/JacobLinCool/selflare), which also supports KV, D1, R2, DO, and Cache API out of the box.

```bash
npm i -g selflare  # Install Selflare
selflare compile   # Compile yours worker to Cap'n Proto
selflare docker    # Generate Dockerfile and docker-compose.yml
docker compose up  # Run the worker
```

You can now access your worker at `http://localhost:8080`!

### Manual Setup

If you prefer to set up the Cap'n Proto manually, follow the steps below.

#### 1. Prepare Your Worker

First, build your worker with Wrangler by running the following command in your project directory:

```sh
wrangler deploy --dry-run --outdir .wrangler/dist
```

This command compiles your worker and outputs the result script to `.wrangler/dist/index.js`.

#### 2. Configure `worker.capnp`

Next, create a `worker.capnp` file in the same directory as your `wrangler.toml`. This file is used to configure the Workerd runtime. Below is a template you can start with:

```capnp
using Workerd = import "/workerd/workerd.capnp";

const config :Workerd.Config = (
    services = [
        (name = "main", worker = .worker),
    ],
    sockets = [
        (service = "main", name = "http", address = "*:8080", http = ()),
    ]
);

const worker :Workerd.Worker = (
    modules = [
        (name = "worker", esModule = embed ".wrangler/dist/index.js"),
    ],
    compatibilityDate = "2024-02-19",
);
```

For detailed information on configuring `worker.capnp`, refer to the [Workerd Repository](https://github.com/cloudflare/workerd/tree/main?tab=readme-ov-file#configuring-workerd).

#### 3. Run the Docker Image

With your worker built and configured, you're ready to run it inside a Docker container. Execute the following command:

```sh
docker run -v $(pwd):/worker -p 8080:8080 jacoblincool/workerd
```

This command mounts your current directory to the `/worker` directory inside the container and forwards port 8080 to your local machine.

#### Accessing Your Worker

After starting the Docker container, your worker will be accessible at `http://localhost:8080`.

## Use as a Base Image

You can also use this image as a base image for your own worker. Below is an example `Dockerfile`:

```Dockerfile
FROM jacoblincool/workerd

COPY worker.capnp worker.capnp
COPY other-file-like-your-worker.js other-file-like-your-worker.js
```
