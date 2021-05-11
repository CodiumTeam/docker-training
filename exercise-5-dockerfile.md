# Exercise 5: how to build your own image

## TBD

Crear un Dockerfile sencillo. Darles las características.
Explicar que bajo flask-example hay una aplicación de Python que puede correr en nativo. Queremos "dockerizarla".
El objetivo es poder correr el programa con `docker run -d -p 9091:9091 my-python-app` y acceder a http://localho

- Crear un fichero Dockerfile
- The base image should be a Python official image with version `3.9`
- Copia el fichero server.py a xxx
- Finalmente, ejecuta el comando
- Construye una imagen con nombre `my-python-app`

## TBD

- Usar `-P` para montar el puerto automáticamente. Poner el `EXPOSE`
- Cambiar el puerto expuesto: pasar argumento para definir el puerto con el docker build y que lo exponga

## Exponer volumen donde escribimos los logs

xxxx

## Parámetros del docker run

E.g. con FLASK_DEBUG o FLASK_ENV https://flask.palletsprojects.com/en/1.1.x/cli/

## Bonus track

- Working directory.

### ENTRYPOINT vs CMD

- For better understanding the difference between ENTRYPOINT and CMD, you can build and run the image under the folder `entrypoint-cmd`:
  - `docker build -t entrypoint-cmd-example .`
  - `docker run entrypoint-cmd-example`
  - Remark how CMD is the argument passed to the binary command defined as ENTRYPOINT

## Resources

- https://github.com/jessfraz/dockerfiles
- https://hub.docker.com/
- https://yodralopez.dev/docker-cheatsheet-v2.pdf
