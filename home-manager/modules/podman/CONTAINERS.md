# Local Container Routing

Containers on this machine get nice `.localhost` URLs automatically via Traefik.
No port publishing to the host, no port conflicts between projects.

## What this gives you

Any container is reachable from your browser at:

    http://<containername>.localhost

Traefik watches the podman socket for new containers and routes by hostname.
The Traefik dashboard is at http://localhost:8080.

Browsers resolve `*.localhost` to `127.0.0.1` automatically (RFC 6761).
For CLI tools like `curl`, you may need dnsmasq or an `/etc/hosts` entry.

## Single-port containers (zero config)

If a container exposes one port, Traefik auto-detects it. Nothing to configure.

    # Example: container "myapp-web-1" exposing port 3000
    http://myapp-web-1.localhost  ->  container port 3000

If multiple ports are exposed, Traefik picks the lowest one.

## Multi-port containers (labels required)

For additional ports, add Traefik labels in your `docker-compose.yml`.
Use `${COMPOSE_PROJECT_NAME}` to keep names dynamic (compose sets this to the
directory name by default; override via `.env` or `-p <name>`).

Each extra port needs three labels: a router rule, a router-to-service binding,
and the service port.

```yaml
services:
  app:
    # Port 3000 is the lowest exposed port, routed automatically.
    # No labels needed for it.

    labels:
      # API on port 8080
      traefik.http.routers.${COMPOSE_PROJECT_NAME}-api.rule: >-
        Host(`api.${COMPOSE_PROJECT_NAME}.localhost`)
      traefik.http.routers.${COMPOSE_PROJECT_NAME}-api.service: >-
        ${COMPOSE_PROJECT_NAME}-api
      traefik.http.services.${COMPOSE_PROJECT_NAME}-api.loadbalancer.server.port: "8080"

      # Debug inspector on port 9229
      traefik.http.routers.${COMPOSE_PROJECT_NAME}-debug.rule: >-
        Host(`debug.${COMPOSE_PROJECT_NAME}.localhost`)
      traefik.http.routers.${COMPOSE_PROJECT_NAME}-debug.service: >-
        ${COMPOSE_PROJECT_NAME}-debug
      traefik.http.services.${COMPOSE_PROJECT_NAME}-debug.loadbalancer.server.port: "9229"
```

For a project in a directory called `myapp`, this produces:

    http://myapp-app-1.localhost        ->  port 3000 (auto)
    http://api.myapp.localhost          ->  port 8080 (label)
    http://debug.myapp.localhost        ->  port 9229 (label)

Router and service names must be globally unique across all running containers,
so always prefix with `${COMPOSE_PROJECT_NAME}`.

## Key files

- `home-manager/modules/traefik/default.nix` -- Traefik systemd user service
- `home-manager/modules/podman/default.nix` -- podman-bridged, podman-compose,
  and devcontainer wrappers
- `modules/podman/default.nix` -- system-level podman config (socket, DNS,
  docker compat)
