module Input
(
  manipulateState,
  getSelectionName,
) where

import DirState
import Shared
import Editor
import System.Directory
import System.FilePath.Posix
import System.Console.ANSI

-- ===============================================================
--                           Input UTILS
-- ===============================================================

showHelp :: [String] -> IO ()
showHelp ["\ESC"] = getKey >>= (\char ->
                      if char == "\ESC" then return () 
                      else putStr "\r      \r" >> showHelp ["\ESC"])
showHelp [] = formatString [] [SetUnderlining NoUnderline] "[ESC] - exit help"
            >> getKey >>= (\char ->
              if char == "\ESC" then return ()
              else putStr "\r      \r" >> showHelp ["\ESC"])
showHelp (x:xs) = formatString [SetSwapForegroundBackground True] [SetUnderlining NoUnderline] x >> showHelp xs

showUnkownCommand :: DirState -> IO (DirState, Bool)
showUnkownCommand state = getUserConfirmation "[ UNKNOWN COMMAND ] See help?"
                        >>= (\help ->
                          if help then applyAction state "h"
                          else return (state, False))

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
createNewDirectory :: DirState -> IO DirState
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
createNewFile :: DirState -> IO DirState
createNewFile state = getUserResponse "Enter new file name"
  >>= (\name -> 
      if name == "" then return ()
      else
        doesFileExist (getPath state)
        >>= \isFile -> if isFile then return ()
        else
          writeFile (joinPath [getPath state, name]) "")
  >> return (state)

-- renames a file to a given name if it exists
renameSelectedFile :: DirState -> String -> IO ()
renameSelectedFile state name = doesFileExist (joinPath [getPath state, name])
                                >>= \exists -> if exists then return ()
                                  else renameFile (joinPath [getPath state, getSelectionName state]) (joinPath [getPath state, name])
                                >> return ()

-- renames the current selection to a given name
renameSelection :: DirState -> IO DirState
renameSelection state | getSelectionName state == ".." = return state
                      | otherwise = getUserResponse ("Enter new name for " ++ getSelectionName state)
                      >>= (\name -> if name == "" then return ()
                          else
                            if isDirectorySelected state then renameSelectedDirectory state name
                            else renameSelectedFile state name
                          )
                      >> return (state)

-- delete the current selection (both, directory and file)
deleteSelection :: DirState -> IO DirState
deleteSelection state | getSelectionName state == ".." = return state
                      | otherwise = getUserConfirmation ("Delete " ++ (getSelectionName state) ++ "?")
                      >>= (\delete -> if delete then deleteNow state else return state)
  where deleteNow :: DirState -> IO DirState
        deleteNow state | isDirectorySelected state = removeDirectoryRecursive (joinPath [getPath state, getSelectionName state]) >> return state
                        | otherwise                 = removeFile               (joinPath [getPath state, getSelectionName state]) >> return state


editSelection :: DirState -> IO DirState
editSelection state | getSelectionName state == ".." = return state
                    | isDirectorySelected state = return state
                    | otherwise                 = openEditor (joinPath [getPath state, getSelectionName state]) >> return state

{- ________________________________ ACTIONS _______________________________ -}

actionDescriptions = [
    "[h] - show help",
    "[Arrow Up] - selection up",
    "[Arrow Down] - selection down",
    "[Enter] - enter directory",
    "[q] - quit application",
    "[n] - new file",
    "[N] - new folder",
    "[r] - rename file/folder",
    "[e] - edit file",
    "[d] - delete file/folder"
  ]

applyAction :: DirState -> [Char] -> IO (DirState, Bool)
applyAction state "q" = return (state, True) -- quit ☑️
applyAction state "n" = createNewFile state >>= \newState -> return (newState, False) -- new file ☑️
applyAction state "N" = createNewDirectory state >>= \newState -> return (newState, False) -- new folder ☑️
applyAction state "r" = renameSelection state >>= \newState -> return (newState, False) -- rename ☑️
applyAction state "d" = deleteSelection state >>= \newState -> return (newState, False) -- delete ☑️
applyAction state "e" = editSelection state >>= returnWithoutExit -- edit file ☑️
applyAction state "\ESC[A" = decreaseSelection state >>= returnWithoutExit -- selection up ☑️
applyAction state "\ESC[B" = increaseSelection state >>= returnWithoutExit -- selection down ☑️
applyAction state "\n" = enterDirectory state >>= returnWithoutExit -- enter directory ☑️
applyAction state "h" = putStrLn "" >> showHelp actionDescriptions >> returnWithoutExit state -- show help ☑️
applyAction state _ = showUnkownCommand state -- unkown command, shows help ☑️

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