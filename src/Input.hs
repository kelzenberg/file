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

createNewDirectory :: DirState -> IO (DirState)
createNewDirectory state = getUserResponse "Folder Name" >>= (\name -> 
  if name == "" then
    return ()
  else 
    createDirectoryIfMissing False (joinPath [getPath state, name])) >> return (state)

applyAction :: DirState -> [Char] -> IO (DirState, Bool)
applyAction state "q" = return (state, True) -- quit
applyAction state "n" = return (state, False) -- new file
applyAction state "N" = createNewDirectory (state) >>= (\newState -> return (newState, False)) -- new folder
applyAction state "r" = return (state, False) -- rename
applyAction state "d" = return (state, False) -- delete
applyAction state "\ESC[A" = decreaseSelection state >>= returnWithoutExit -- selection up
applyAction state "\ESC[B" = increaseSelection state >>= returnWithoutExit -- selection down
applyAction state "\n" = enterDirectory state >>= returnWithoutExit -- enter directory
applyAction state _ = putStrLn "unknown command" >> return (state, False)

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