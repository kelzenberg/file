module Input
(
  manipulateState,
  getSelectionName,
) where

import DirState
import Shared
import System.Directory
import System.FilePath.Posix

-- ===============================================================
--                           Input UTILS
-- ===============================================================

{- ________________________________ SELECTION _______________________________ -}

-- changes the selection index with a change function
changeSelectionIdx :: DirState -> (Int -> Int) -> IO DirState
changeSelectionIdx state changeFunc = return (DirState (getPath state) (getContent state) (fixSelectionIdx (changeFunc (getSelectionIdx state)) (getContent state)))

-- increases the selection index by one (down ↓)
increaseSelection :: DirState -> IO DirState
increaseSelection state = changeSelectionIdx state (+1)

-- decreases the selection index by one (up ↑)
decreaseSelection :: DirState -> IO DirState
decreaseSelection state = changeSelectionIdx state (subtract 1) --  -1 or 1- would not work

-- checks if a directory (true) or file (false) is selected
isDirectorySelected :: DirState -> Bool
isDirectorySelected state = snd ((getContent state) !! (getSelectionIdx state))


{- ________________________________ DIRECTORY & FILE _______________________________ -}

-- no-Op function for user input
returnWithoutExit :: DirState -> IO (DirState, Bool)
returnWithoutExit state = return (state, False)

-- enters the directory that is selected
-- if no directory is selection nothing happens
enterDirectory :: DirState -> IO DirState
enterDirectory state | (getSelectionName state) == ".." = return (DirState (takeDirectory (getPath state)) [] 0)
                     | isDirectorySelected state = return (DirState (joinPath [(getPath state), (getSelectionName state)]) [] 0)
                     | otherwise = return state

-- creates a new directory with a given name if it does not exist yet
createNewDirectory :: DirState -> IO (DirState)
createNewDirectory state = getUserResponse "Enter new folder name"
  >>= (\name -> 
      if name == "" then return ()
      else 
        createDirectoryIfMissing False (joinPath [getPath state, name]))
  >> return (state)

-- renames a directory to a given name if it exists
renameSelectedDirectory :: DirState -> String -> IO ()
renameSelectedDirectory state name = doesDirectoryExist (joinPath [getPath state, name])
                                    >>= \exists -> if exists then return ()
                                      else renameDirectory (joinPath [getPath state, getSelectionName state]) (joinPath [getPath state, name])
                                    >> return ()

-- creates a new file with a given name if it does not exist yet
createNewFile :: DirState -> IO (DirState)
createNewFile state = getUserResponse "Enter new file name"
  >>= (\name -> 
      if name == "" then return ()
      else
        doesFileExist (getPath state)
        >>= \isFile -> if isFile then return ()
        else
          writeFile (joinPath [getPath state, name]) "this is debug content")
  >> return (state)

-- renames a file to a given name if it exists
renameSelectedFile :: DirState -> String -> IO ()
renameSelectedFile state name = doesFileExist (joinPath [getPath state, name])
                                >>= \exists -> if exists then return ()
                                  else renameFile (joinPath [getPath state, getSelectionName state]) (joinPath [getPath state, name])
                                >> return ()

-- renames the current selection to a given name
renameSelection :: DirState -> IO (DirState)
renameSelection state | getSelectionName state == ".." = return state
                      | otherwise = getUserResponse ("Enter new name for " ++ getSelectionName state)
                      >>= (\name -> if name == "" then return ()
                          else
                            if isDirectorySelected state then renameSelectedDirectory state name
                            else renameSelectedFile state name
                          )
                      >> return (state)

-- delete the current selection (both, directory and file)
deleteSelection :: DirState -> IO (DirState)
deleteSelection state = getUserConfirmation ("Delete " ++ (getSelectionName state) ++ "?") >>= (\delete -> if delete then deleteNow state else return state)
  where deleteNow :: DirState -> IO (DirState)
        deleteNow state | isDirectorySelected state = removeDirectoryRecursive (joinPath [getPath state, getSelectionName state]) >> return state
                        | otherwise                 = removeFile               (joinPath [getPath state, getSelectionName state]) >> return state


{- ________________________________ ACTIONS _______________________________ -}

applyAction :: DirState -> [Char] -> IO (DirState, Bool)
applyAction state "q" = return (state, True) -- quit ☑️
applyAction state "n" = createNewFile state >>= \newState -> return (newState, False) -- new file ☑️
applyAction state "N" = createNewDirectory state >>= \newState -> return (newState, False) -- new folder ☑️
applyAction state "r" = renameSelection state >>= \newState -> return (newState, False) -- rename ☑️
applyAction state "d" = deleteSelection state >>= \newState -> return (newState, False) -- delete ☑️
applyAction state "\ESC[A" = decreaseSelection state >>= returnWithoutExit -- selection up ☑️
applyAction state "\ESC[B" = increaseSelection state >>= returnWithoutExit -- selection down ☑️
applyAction state "\n" = enterDirectory state >>= returnWithoutExit -- enter directory ☑️
applyAction state "h" = return (state, False) -- show help ❌
applyAction state _ = putStrLn "unknown command" >> return (state, False) -- unkown command, shows help ❌

-- ===============================================================
--                           Input EXPORTS
-- ===============================================================

-- wait for the user to press a key and apply that action to the state
-- returns the new state and a bool that indicates if the program should exit
manipulateState :: DirState -> IO (DirState, Bool)
manipulateState state = getKey >>= (\char -> putStr "\r     \r" >> applyAction state char)

-- gets the name of the directory/file which is currently selected
getSelectionName :: DirState -> String
getSelectionName state = fst ((getContent state) !! (getSelectionIdx state))