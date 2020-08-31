# F.I.L.E

**F**iles **i**n **L**ambda **E**xpressions – a Haskell-written humble visual file explorer

(UNIX-based OS' only)

## Features

Program starts in the root directory

- [x] show help for commands
- [x] list directories in current folder
- [x] list files in current folder
- [x] ascend directory tree (parent folder)
- [x] descend directory tree (child folders)

##### folders

- [x] create & name folder
- [x] rename folder
  - _constraints:_ no empty names
- [x] delete folder
  - [x] with "do you really want to delete?"-question

##### files

- [x] create & name file
  - _constraints:_ no content, just file creation
- [x] rename file
  - _constraints:_ no empty names
- [x] edit file (with nano)
- [x] delete file
  - [x] with "do you really want to delete?"-question

##### future extensions

- [ ] move files
- [ ] move folders

## Project Setup

##### Requirements

- Docker Desktop `version > v19.x`

##### Commands

_Reset all docker containers._
--- Recommended for first install or when Docker image was modified.

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
--- Use this to run `ghci` inside docker. Do not forget to load the project with `:load Main.hs` afterwards.

```sh
make run
```

###### F.I.L.E Commands

- `h` - show help
- `Arrow Up` - selection up
- `Arrow Down` - selection down
- `Enter` - enter directory
- `q` - quit application
- `n` - new file
- `N` - new folder
- `r` - rename file/folder
- `e` - edit file
- `d` - delete file/folder
- `ESC` - exit help
