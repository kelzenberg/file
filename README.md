# F.I.L.E

**F**iles **i**n **L**ambda **E**xpressions – a Haskell written humble file explorer

(UNIX-based OS only)

## features

- start in "~/" directory

- [x] list directories in current folder
- [x] list files in current folder
- [ ] show help for commands

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

- [ ] move files
- [ ] move folders
- [x] edit files

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

_Build docker container & Haskell project._
--- **Use this to run `ghc Main.hs`**.

```sh
make
```

_Run GHCI inside docker container._
--- **Use this to run `ghci`**. Do not forget to add `:load Main.hs` manually.

```sh
make run
```
