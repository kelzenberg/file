# F.I.L.E

**F**iles **i**n **L**ambda **E**xpressions – a Haskell written humble file explorer

(UNIX-based OS only)

## features

- start in "~/" directory

- [x] list directories in current folder
- [x] list files in current folder
- [x] show help for commands

##### directories

- [x] go directory tree up (parent folder)
  - _constraint:_ no folder above
- [x] go directory tree down (child folders)

##### folders

- [x] create & name folder
- [x] rename folder
  - _constraint:_ no empty names
- [x] delete folder
  - [x] with "do you really want to delete?"-question

##### files

- [x] create & name file
  - _constraint:_ no content, just file creation
- [x] rename file
  - _constraint:_ no empty names
- [x] delete file
  - [x] with "do you really want to delete?"-question

##### optional

- [x] edit files
- [ ] move files
- [ ] move folders

## Project Setup

##### Requirements

- Docker Desktop

##### Commands

_Reset all docker containers._
--- Recommended for first install.

```sh
make reset
```

_Remove stopped docker containers._
--- Use this to get rid of dangling containers from old images from this project

```sh
make clean
```

_Build docker container & Haskell project in the virtual environment._
--- Use this to run `ghc Main.hs` inside docker.

```sh
make
```

_Run GHCI inside docker container._
--- Use this to run `ghci` inside docker. Do not forget to load the project with `:load Main.hs`.

```sh
make run
```
