Dependencies:
bash, sed, cat, grep, cut, ssh, docker

To start:

0) decide which distro version you are building for. Currently supported: buster
1) set up docker on your machine (hope it's running linux, this is untested anywhere else)
2) make a directory which will hold source repos with their debian-specifc build files for
   for any packages you want to build
3) copy the file settings.txt.sample to settings.txt and edit it appropriately,
   including adding the path to the directory you created above
4) run:
   bash ./build_image.sh buster
5) assuming that ran successfully, run:
   bash ./create_container.sh buster
6) assuming that succeeded, run:
   ./ssh-to-instance.sh buster
   and supply the password "testing" to get in as root
7) test building your package; if you have a successful build, you will find the packages in a subdirectory
   under the scratch build directory you specified
8) when you are done with all work, destroy the container, leaving the image intact, and you'll be ready
   for the next time
