rockbuild
=========

Rockbuild

=== Installing on OSX ===

Get rvm:
\curl -sSL https://get.rvm.io | bash -s stable

Restart your shell or eval .profile again to update your PATH.

Install ruby 2.0:
rvm install ruby-2.0.0

Done. Usage:

Either cd into rockbuild (which has a .ruby-version file that rvm uses) or execute "rvm use ruby-2.0.0".


=== Compiling and running ===

Run bundle install to bootstrap the installation.



=== Known problems/limitations ===

* One thing I don't like is how we're specifying the profile :mac32 or :mac64 or whatever in the entries on DemoProject. I want to make it where it will either use your current host, or you can pass it in on the command line.
IOW, profiles that take parameters?
