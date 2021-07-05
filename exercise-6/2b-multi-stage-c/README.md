# Simple C++ program

There are 3 dockerfiles to compile and run a this simple C++ program

Let's build them all and notice the differences:

```bash
for i in {1..3}
do 
  docker build -t test:$i -f Dockerfile.$i . 
done
```

We can try all three versions too

```bash
for i in {1..3}
do 
  docker run --rm test:$i 24
done
```

But notice the difference in sizes

```bash
docker images test
```

```
REPOSITORY   TAG       IMAGE ID       CREATED         SIZE
test         1         a189947a6186   4 minutes ago   1.23GB
test         2         939330bded01   5 minutes ago   195MB
test         3         aa74076c634f   5 minutes ago   9.58MB
```
