# Exercise 6: building more efficient images

## Using caching efficiently

In order to leverage more efficiently the caching mechanism Docker uses when building images, it is important to order commands in your `Dockerfile` so that the commands whose output changes more frequently are executed last. Let's take the `Dockerfile` from a simple Python app (which you created previously, or otherwise you can find it in the resources for this exercise) as an example.

1. Build the image once.
1. Build the image again, notice that the second time it was very quick and it was saying `---> Using cache` after each instruction.
1. Now modify the `server.py` file. Simply change one of th strings.
1. Build the image once more. Notice that it had to install the requirements again, even thought they had not changed. This step of installing dependencies can be time consuming and typically changes much less frequently than your code. That is why best practice dictates that you should install dependencies first before copying your actual source code.
1. Modify the `Dockerfile` to copy the `requirements.txt` file (but not the `server.py`), install the dependencies, and then copy the actual application code.
1. As before, try building the image, then change the code in `server.py` and building the image again. Notice how this time, the dependencies are retrieved from cache.


