module Input
(
  manipulateState,
) where

import DirState
import Shared
import System.Directory
import System.FilePath.Posix

-- ===============================================================
--                           Input UTILS
-- ===============================================================

returnWithoutExit :: DirState -> IO (DirState, Bool)
returnWithoutExit state = return (state, False)

createNewFile :: DirState -> IO (DirState)
createNewFile state = getUserResponse "Enter File Name"
  >>= (\name -> 
      if name == "" then return ()
      else
        doesFileExist (getPath state)
        >>= \isFile -> if isFile then return ()
        else
          writeFile (joinPath [getPath state, name]) "this is debug content")
  >> return (state)

createNewDirectory :: DirState -> IO (DirState)
createNewDirectory state = getUserResponse "Enter Folder Name"
  >>= (\name -> 
      if name == "" then return ()
      else 
        createDirectoryIfMissing False (joinPath [getPath state, name]))
  >> return (state)

deleteSelectedFile :: DirState -> IO (DirState)
deleteSelectedFile state = removeFile (joinPath [getPath state, getSelectionName state]) >> return state

renameSelectedFile :: DirState -> IO (DirState)
renameSelectedFile state = getUserResponse "Enter New Name"
  >>= (\name -> 
      if name == "" then return ()
      else
        doesFileExist (joinPath [getPath state, name])
        >>= (\exists -> 
          if exists then return ()
          else
            renameFile (joinPath [getPath state, getSelectionName state]) (joinPath [getPath state, name])))
      >> return (state)
        

applyAction :: DirState -> [Char] -> IO (DirState, Bool)
applyAction state "q" = return (state, True) -- quit ☑️
applyAction state "n" = createNewFile state >>= returnWithoutExit -- new file ❌
applyAction state "N" = createNewDirectory state >>= \newState -> return (newState, False) -- new folder ☑️
applyAction state "r" = renameSelectedFile state >>= returnWithoutExit -- rename ❌
applyAction state "d" = deleteSelectedFile state >>= returnWithoutExit -- delete ❌
applyAction state "\ESC[A" = decreaseSelection state >>= returnWithoutExit -- selection up ☑️
applyAction state "\ESC[B" = increaseSelection state >>= returnWithoutExit -- selection down ☑️
applyAction state "\n" = enterDirectory state >>= returnWithoutExit -- enter directory ☑️
applyAction state _ = putStrLn "unknown command" >> return (state, False) -- unkown command ❌

-- ===============================================================
--                           Input EXPORTS
-- ===============================================================

-- wait for the user to press a key and apply that action to the state
-- returns the new state and a bool that indicates if the program should exit
manipulateState :: DirState -> IO (DirState, Bool)
manipulateState state = getKey >>= (\char -> putStr "\r     \r" >> applyAction state char)

-- fetchUserInput :: String -> IO String
-- fetchUserInput prompt = printInputPromp prompt
--                       >> getLine
--                       >>= (\input ->
--                             if length input == 0
--                             then (fetchUserInput (prompt ++ " (no empty lines)"))
--                             else return input)