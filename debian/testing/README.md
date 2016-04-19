![](http://carlchenet.files.wordpress.com/2013/05/proposed-debian-logo.png)

## Tag available
* latest, jessie, 8 [(Dockerfile)](https://github.com/xataz/dockerfiles/tree/master/debian/jessie/Dockerfile)
* testing [(Dockerfile)](https://github.com/xataz/dockerfiles/tree/master/debian/testing/Dockerfile)
* sid [(Dockerfile)](https://github.com/xataz/dockerfiles/tree/master/debian/sid/Dockerfile)

## Description
What is [Debian](https://www.debian.org)?

Debian is a free operating system (OS) for your computer. An operating system is the set of basic programs and utilities that make your computer run.

The Debian Project is an association of individuals who have made common cause to create a free operating system. This operating system that we have created is called Debian.

An operating system is the set of basic programs and utilities that make your computer run. At the core of an operating system is the kernel. The kernel is the most fundamental program on the computer and does all the basic housekeeping and lets you start other programs.

Debian systems currently use the Linux kernel or the FreeBSD kernel. Linux is a piece of software started by Linus Torvalds and supported by thousands of programmers worldwide. FreeBSD is an operating system including a kernel and other software.

However, work is in progress to provide Debian for other kernels, primarily for the Hurd. The Hurd is a collection of servers that run on top of a microkernel (such as Mach) to implement different features. The Hurd is free software produced by the GNU project.

A large part of the basic tools that fill out the operating system come from the GNU project; hence the names: GNU/Linux, GNU/kFreeBSD, and GNU/Hurd. These tools are also free.

Of course, the thing that people want is application software: programs to help them get what they want to do done, from editing documents to running a business to playing games to writing more software. Debian comes with over 43000 packages (precompiled software that is bundled up in a nice format for easy installation on your machine), a package manager (APT), and other utilities that make it possible to manage thousands of packages on thousands of computers as easily as installing a single application. All of it free.

It's a bit like a tower. At the base is the kernel. On top of that are all the basic tools. Next is all the software that you run on the computer. At the top of the tower is Debian — carefully organizing and fitting everything so it all works together.

## Build Image
```shell
docker build -t xataz/alpine:3.3 github.com/xataz/dockerfiles.git#master:debian/jessie
```

## Usage
### Simple launch
```shell
docker run -ti xataz/debian:jessie bash
```
### For create an image
```shell
FROM xataz/debian:jessie

RUN apt-get update \
    && apt-get install nginx

CMD ["tini", "--", "nginx", "-g", "daemon off;"]
```

