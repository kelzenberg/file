module Input
(
  manipulateState,
) where

import DirState
import Shared

-- ===============================================================
--                           Input UTILS
-- ===============================================================

applyAction :: DirState -> [Char] -> IO (DirState, Bool)
applyAction state "q" = return (state, True) -- quit
applyAction state "n" = return (state, False) -- new file
applyAction state "N" = return (state, False) -- new folder
applyAction state "r" = return (state, False) -- rename
applyAction state "d" = return (state, False) -- delete
applyAction state "\ESC[A" = decreaseSelection state >>= \state -> return (state, False) -- selection up
applyAction state "\ESC[B" = increaseSelection state >>= \state -> return (state, False) -- selection down
applyAction state "\n" = enterDirectory state >>= \state -> return (state, False) -- selection down
applyAction state _ = putStrLn "unknown command" >> return (state, False)

-- ===============================================================
--                           Input EXPORTS
-- ===============================================================

-- wait for the user to press a key and apply that action to the state
-- returns the new state and a bool that indicates if the program should exit
manipulateState :: DirState -> IO (DirState, Bool)
manipulateState state = getKey >>= (\char -> putStrLn "" >> applyAction state char)

-- fetchUserInput :: String -> IO String
-- fetchUserInput prompt = printInputPromp prompt
--                       >> getLine
--                       >>= (\input ->
--                             if length input == 0
--                             then (fetchUserInput (prompt ++ " (no empty lines)"))
--                             else return input)