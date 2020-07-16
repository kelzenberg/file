# F.I.L.E

**F**iles **i**n **L**ambda **E**xpressions – a Haskell written humble file explorer

(UNIX-based OS only)

## features

- start in "~/" directory

- [x] list directories in current folder
- [x] list files in current folder

##### directories

- [ ] go directory tree up (parent folder)
  - _constraint:_ no folder above
- [ ] go directory tree down (child folders)

##### folders

- [ ] create & name folder
- [ ] rename folder
  - _constraint:_ no empty names
- [ ] delete folder
  - [ ] with "do you really want to delete?"-question

##### files

- [ ] create & name file
  - _constraint:_ no content, just file creation
- [ ] rename file
  - _constraint:_ no empty names
- [ ] delete file
  - [ ] with "do you really want to delete?"-question

##### optional

- [ ] move files
- [ ] move folders
- [ ] on create file, open editor to edit content

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
