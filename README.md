# Docker with Node quick-start tutorial
This is a quick-start tutorial for Docker using a node express web-server.


## Running the project itself
Project comes with a minimal setup for express, running a hello world webserver exposed on port `8000`.  
Run project by running `npm start`.

## Docker

Project comes with a minimal docker setup.  
The `Dockerfile` specifies the setup of the image, containing installation of required modules,  
adding of the project files and running of the app.
 
- #### Installation
    To install `docker` and the later used `docker-compose` when using mac, the most straight forward way is installing
    [Docker Desktop](https://docs.docker.com/docker-for-mac/install/). It comes with a useful GUI to control docker preferences.
    
- #### Build the container by running:
    ```bash
    ❯ docker build -t node-quickstart .               
    Sending build context to Docker daemon  135.2kB
    Step 1/5 : FROM node:14
     ---> a511eb5c14ec
    Step 2/5 : COPY package*.json ./
     ---> f813b94104f8
    Step 3/5 : RUN npm install
     ---> Running in 688a5686e89d
    added 50 packages from 37 contributors and audited 126 packages in 1.734s
    found 0 vulnerabilities
    
    Removing intermediate container 688a5686e89d
     ---> 1f518419cd22
    Step 4/5 : COPY ./ ./
     ---> 11802f3b0e25
    Step 5/5 : CMD ["npm", "start"]
     ---> Running in 80e3bd397021
    Removing intermediate container 80e3bd397021
     ---> c65b8a5c0c55
    Successfully built c65b8a5c0c55
    Successfully tagged node-quickstart:latest
    ```
    `-t` specifies the tag of the image and can be freely chosen.  

- #### Run the container with:
    ```bash
    ❯ docker run node-quickstart                                                                                                                                                                                                      19:12:49
    > docker-node-quickstart@1.0.0 start /
    > node app.js
    
    Example app listening at http://localhost:8000
    ```

- #### Access the app inside the container
    You will see the app start up just like being started without using docker.
    However, when accessing the server, you will receive a `Connection Refuse` error.
    ```bash
    ❯ curl http://localhost:8000
    curl: (7) Failed to connect to localhost port 8000: Connection refused
    ```
 
    This is because currently the app is running on the docker container localhost and is not exposed to the host machine yet.  
    To expose a port from inside the container to the host machine, start the container with:
    ```bash
    ❯ docker run -p 8000:8000 node-quickstart.v1                                                                                                                                                                                      19:13:06
    > docker-node-quickstart@1.0.0 start /
    > node app.js
    
    Example app listening at http://localhost:8000
    ```  
    Now the host local port `8000` will redirect to the docker container port `8000` and accessing  
    `http://localhost:8000` will now succeed.
    ```bash
    ❯ curl http://localhost:8000          
    Hello World!    
    ```

### Additional useful commands
- #### Run container in the background (`-d flag`)
    ```bash
    ❯ docker run -p 8000:8000 -d --name node node-quickstart                                                                                                                                                                                      18:21:48
    c1bbff027182c57a1e8869dd5a3fe783f633fee6da7360987deca4d58f379ae9
    ```
    The `--name` flag lets you assign a name to the container, which lets you easily reference it with docker commands.

- #### List containers
    > stopped / exited containers will not show
    ```bash
    ❯ docker ps                                                                                                                                                                                                                       18:28:06
    CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS              PORTS                    NAMES
    c944e5e2f8ef        node-quickstart     "docker-entrypoint.s…"   About a minute ago   Up About a minute   0.0.0.0:8000->8000/tcp   node
    ```
- #### Stop the container
    ```bash
    ❯ docker stop node                                                                                                                                                                                                                18:29:12
    node
    ```
- #### List all containers
    ```bash
    ❯ docker ps -a                                                                                                                                                                                                                    18:29:52
    CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                      PORTS               NAMES
    c944e5e2f8ef        node-quickstart     "docker-entrypoint.s…"   2 minutes ago       Exited (0) 24 seconds ago                       node
    ```
- #### Remove container
    ```bash
    ❯ docker rm node                                                                                                                                                                                                                  18:30:16
    node
    ```
- #### Execute shell inside the container (SSH into container)
    ```bash
    ❯ docker run -p 8000:8000 -d --name node node-quickstart
    5f3395d687558c0c2cffd61bf0d1f519b7902de64eb07e8daa7ed2090084e044
    
    ❯ docker exec -it node /bin/bash                                                                                                                                                                                                  18:34:06
    root@9828c2358b52:/# ls
    Dockerfile  LICENSE  README.md  app.js  bin  boot  dev  etc  home  lib  lib64  media  mnt  node_modules  opt  package-lock.json  package.json  proc  root  run  sbin  srv  sys  tmp  usr  var
    root@9828c2358b52:/#
    ```
This provides you with the foundational commands to run your current project containerized.  

### Next steps:
- [Quick-start article](https://medium.com/faun/quick-start-guide-to-docker-fa646e0f3f2d) covering the idea's and inner workings of docker
- [Reference](https://docs.docker.com/engine/reference/builder/) for the `Dockerfile` configuration
- Additional [docker commands](https://docs.docker.com/engine/reference/commandline/docker/)

<hr>

### That's all very nice, but what if I want more?
You might notice that managing multiple containers, for let's say your frontend and backend will become painful.
I.e. you would have to build the image for frontend and backend and run the containers separately.  
Fear not, `docker-compose` is here for the rescue 🎉🎉.

## Docker Compose
`Docker-compose` is taking care of building your images and running and configuring your containers.  
It provides and yaml based configuration to programmatically define the behaviour of your containers  
and replaces the need to use standalone `docker` commands all-together.  
The project comes with a basic `docker-compose.yml` configuration to start our web-server.
- #### Start the container using `docker-compose`
    ```bash
    ❯ docker-compose up                                                                                                                                                                                                               19:05:01
    Starting node-2 ... done
    Starting node   ... done
    Attaching to node, node-2
    node      | 
    node      | > docker-node-quickstart@1.0.0 start /
    node      | > node app.js
    node      | 
    node-2    | 
    node-2    | > docker-node-quickstart@1.0.0 start /
    node-2    | > node app.js
    node-2    | 
    node      | Example app listening at http://localhost:8000
    node-2    | Example app listening at http://localhost:8000
    ```
    You will notice that two containers started, without the need to specify any arguments.  
    Additionally, docker-compose will build any images that are not already built.  
    Both express servers are exposed to the host following the configuration (on port 8000 and port 9000)
    ```bash
    ❯ curl http://localhost:8000                                                                                                                                                                 19:54:37
    Hello World!
    
    ❯ curl http://localhost:9000                                                                                                                                                                                                      19:54:48
    Hello World!
    ```

- #### Run your containers in the background (`-d flag`)
    ```bash
    ❯ docker-compose up -d                                                                                                                                                                                                            19:41:36
    Creating node-2 ... done
    Creating node   ... done
    ```
- #### Check container status
    ```bash
    ❯ docker-compose ps                                                                                                                                                                                                               19:41:56
     Name               Command               State           Ports         
    ------------------------------------------------------------------------
    node     docker-entrypoint.sh npm start   Up      0.0.0.0:8000->8000/tcp
    node-2   docker-entrypoint.sh npm start   Up      0.0.0.0:9000->8000/tcp
    ``` 
- #### Stop your containers
    ```bash
    ❯ docker-compose stop                                                                                                                                                                                                             19:42:08
    Stopping node   ... done
    Stopping node-2 ... done
    ```
 
### Next Steps:
- [Reference](https://docs.docker.com/compose/compose-file/) for the `docker-compose.yml` configuration
- Additional [docker-compose commands](https://docs.docker.com/compose/reference/)


## What's missing?
This quick-start does not cover docker volumes.
> What are volumes?

Volumes let you share data with your containers and give you the possibility to persist data created inside the container.  
- [Volumes explanation](https://blog.container-solutions.com/understanding-volumes-docker).
- [Volumes docker documentation](https://docs.docker.com/storage/volumes/).
