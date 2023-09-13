# Linux shell 101

Creating a Dockerfile requires a little knowledge of the linux CLI. This document covers some minimum knowlede needed
to successfully create simple Dockerfiles.

## 1. Environment variables

Environment variables are settings that are passed from a process to any process it creates, this means, every command
you run receives the environment variables from the shell where it was run from.

Environment values look like key value pairs, and are usually defined with the name in uppercase. You can see the current
environment for your shell running the `env` command.

Environment variables can be persisted or not, lets see three different ways of using them:

### 1.1 One-time environment variables
You can set one-time environment variables for a command by setting the key and the value before the command in the
shell.

Try setting a variable like this before a command:

```
MY_AWESOME_VAR=hello env
```

Can you see `MY_AWESOME_VAR=hello` at the end of the output?

Now run again `env`, the `MY_AWESOME_VAR=hello` is no longer there, because it was not persisted.

Note: you can add multiple key value pairs before a command

### 1.2 Persisting an environment variable for the shell life-time

You can also configure environment variables in the shell, so they are going to be passed down to any future commands.
This is going to persist the variable only for the life of the shell in use, once you close the shell the configuration
will be lost, also, if you open another shell, the settings will not be there unless you set it again.

Try persisting a variable for the shell lifetime:

```
export MY_SHELL_CONFIG=hello
```

Now check with `env` to see the variable.

### 1.3 Persisting an environment variable in your shell config

If you want to have an environment value defined always in your shell, you can use the config file of the shell to
configure them, you will probably be using BASH or ZSH (running `echo $SHELL` will tell you the name of your shell).

For BASH the config file is `~/.bashrc` and for ZSH the config file is `~/.zshrc`.

Open the config file and append lines at the end exporting the keys and values you want as we did in the section above.

Keep in mind that this settings will only affect new shells after saving the file, any shell you already had opened will
not see this changes, even the one you used to edit the file if you edited from the shell itself.


## 2. Environment variable substitution, $FOO or ${FOO}

During the examples on this training you will that sometimes we use one syntax or the other.

In the more simple cases they are the same, the format with curly braces has the advantage of denoting better the
boundaries of the variable name when concatenating strings.

Also, there are some modifiers you can use when using curly braces, like defining default values:

try this:

```
$ echo $BUSINESS_NAME
$ echo ${BUSINESS_NAME:-codium}
$ export BUSINESS_NAME=Acme
$ echo ${BUSINESS_NAME:-codium}
```

## 3. Exit status

Any command you execute terminates with an exit status or exit code. This is used to indicate if the program was 
successful or not to the parent process, which can be the shell, a script or a calling program.

All programs when terminate successfully will have an exit code of zero. Any non-zero exit code means that something
has happened. There is no standard meaning for non-zero exit code, each program may define the possible codes and their
meaning in their manual.

To check for the exit status of the last command run `echo $?`

Try this:

```
$ true
$ echo $?
```

Now try this:

```
$ false
$ echo $?
$ echo $?
```

What happened when you run the `echo $?` command for the second time? Why did the value change?

## 4. Running multiple commands in a single line 

You can run multiple commands in a single line, you may see on the examples or the web different things of doing apparently the same.

For example, to create a file and list it you may see it in any of the different three forms:

 * `touch hello.txt; ls`
 * `touch hello.txt && ls`
 * `touch hello.txt & ls`

Let's discuss them:

### 4.1 Using a semicolon

This format will run all commands in order, if a command fails it will ignore the error and keep running the commands.

### 4.2 Using a double &

This format means that the command on the right of the `&&` will only run if the command on the left had an exit status of zero.
In case a command fails, the command chain stops.

### 4.3 Using a single &

This has a very different meaning from the previous two, and should not be used unless you know exactly what are you doing.

A single `&` at the end of a command means to run this command detached from the shell, that means that the program may not
be able to write output to the shell, and the next command will run inmediatly after starting the first one, without waiting
for it to terminate. So you cannot asume that the second command will se the result of the first one.

## 5. Installing packages

TODO