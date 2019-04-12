# Docker SPIRE Automator
## General
This repository contains a Docker Compose file that uses a Gradle image to build a jar of my Java-based repository, and a Selenium WebDriver image that runs the jar. This makes the project more portable and convenient to use, and also isolates all processes in one container.

## Usage
First you must have [Docker](https://www.docker.com/) installed. Docker is software for container virtualization (basically stripped-down virtual machines).

Docker supports Windows with Docker Desktop, which is fine for this use case, but in my experience Docker Desktop tends to use a lot of system resources and runs slowly due to the way Docker Desktop works (creates a Microsoft Hyper-V-based virtual machine running Ubuntu with Docker natively installed).

### Building with Gradle
The project has a prebuilt jar included, so you may skip this step. If there have been major changes to SPIRE, and new commits in the Java repository, you may need to rebuild the jar.
First, delete the existing `spireautomator-portable.jar` in `/jars/` and run the following command in this repository's root directory:
	
	docker-compose up gradle

The Gradle service as defined in the `docker-compose.yml` will pull the most recent commit of the Java repository and use Gradle to build a fat jar (a jar file that contains all library dependencies). This jar may be approximately 10MB.

### Running with Selenium WebDriver
The Selenium service in the `docker-compose.yml` file builds a Docker container based on a Selenium image on Docker Hub. The container includes the browsers and their driver executable files, which you should specify in your environment variable arguments (for example, you will find the parameter `driver=/usr/bin/chromedriver` in the sample file in `envs/`). You can run the container with this command:

	docker-compose up -d selenium

You can follow the behavior of the SPIRE automator with this command:

	docker-compose logs -f selenium

## Configuration

The Docker container is useful mostly for the houser automator because it takes runtime parameters. You need to hard-code your personal course configurations for the enroller automator, because runtime parameters are not yet supported for the enroller. For the enroller, you will then need to build the jar with Gradle (I suggest using a native Gradle wrapper on your machine instead of the Docker container here, unless you modify it). You can then put your own jar into the `jars` folder and run it in the Selenium container.

### Environment Variables

The recommended way to run this container is to define your configurations in the environment variable file. **The value of the SPIRE_ARGS environment variable is the same as the arguments you would use to run the jar of the Java repository without the Docker container.** The sample file included in `envs/` will not run because it lacks some required parameters, like username and password.

### Interactive
Be aware that the `-d` flag in the `docker-compose up` command detaches the container from your command process. This means that if the automator prompts you for user input, it will crash. This is because when starting the container this way, Docker does not allocate an interactive teletype for the container, and when Java tries to create a Scanner, it fails to bind to the container stdin.
To run the container interactively, you need to run the container independently of the Docker Compose file.

	docker-compose build selenium
	docker run -ti --rm spireautomator_selenium_1

In the `docker run` command, the `t` flag tells Docker to allocate a teletype for this container. The `i` flag tells Docker to make this container interactive. The `--rm` parameter tells Docker to delete this container and any issues created during runtime once it stops (a new one will be created if you run the command again).