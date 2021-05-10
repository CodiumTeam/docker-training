# Codium Docker training

## Requirements

You need Docker and Docker Compose. For that, you have several options:

1. Install Docker in your local machine (recommended)

   - https://docs.docker.com/get-docker/
   - On a Linux system, you need to manually install Docker Compose: https://docs.docker.com/compose/install/

2. Use an online Docker playground
   - Navigate to https://labs.play-with-docker.com/
   - You need to Login with a Docker Hub account. If you don't have one, you can create it easily from [here](https://hub.docker.com/signup)
   - Click on "Start"
   - Click on "Add new instance" (the instance will be alive for 4 hours)
   - There you can write any Docker or Docker Compose command as you would do it from you local machine.
   - You can upload any file or folder from your local machine to your playground instance:
     - To copy a file: `scp [your-filename] [your-instance-id]@direct.labs.play-with-docker.com:/root`
     - To copy a folder recursively: `scp -r [your-folder] [your-instance-id]@direct.labs.play-with-docker.com:/root`
   - We would recommend you to upload this repository to you playground instance as a zip file and then unzip it:
     - On the GitHub website (https://github.com/CodiumTeam/docker-training), click on the green "Code" button and then click on "Download ZIP"
     - `scp docker-training-master.zip [your-instance-id]@direct.labs.play-with-docker.com:/root`
     - From the playground instance: `unzip docker-training-master.zip`

## Exercises

- [Exercise 1: hello world](exercise-1-hello-world.md)
- [Exercise 2: basic commands](exercise-2-basic-commands.md)
- [Exercise 3: ports, envs and volumes](exercise-3-ports-envs-volumes.md)
- [Exercise 4: Docker Compose](exercise-4-docker-compose.md)
- [Exercise N: clean up the system](exercise-n-clean-up.md)
- [Exercise N: build your own image](exercise-n-dockerfile.md)

## Interesting resources

### Docker Compose

- https://github.com/docker/awesome-compose
- https://jvns.ca/blog/2021/01/04/docker-compose-is-nice/

### Tools for troubleshooting and monitoring

- https://github.com/bcicen/ctop
- https://github.com/jesseduffield/lazydocker

### Best practices

- TBD
