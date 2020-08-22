module Shared
(
  getFolderContent,
  getKey,
  getUserInput,
  getUserResponse,
  getUserConfirmation,
  formatString
) where

import System.Directory
import System.FilePath.Posix
import System.Console.ANSI
import System.IO (stdin, hReady)
import Data.List

-- ===============================================================
--                           Shared EXPORTS
-- ===============================================================

-- a function that formats strings
formatString :: [SGR] -> [SGR] -> String -> IO ()
formatString format1 format2 name = setSGR format1 >> setSGR format2 >> putStr name >> setSGR [Reset] >> putStrLn ""

-- a function that takes a folder path and returns all files and folders with a isDirectory boolean flag
getFolderContent :: FilePath -> IO [(String, Bool)]
getFolderContent path = listDirectory path
                      >>= \contents -> return (filter (\x -> x /= ".") contents)
                      >>= mapM (\fileName -> 
                                  doesDirectoryExist (joinPath [path, fileName])
                                  >>= (\isDir -> return (fileName, isDir))
                               )
                      >>= \contents -> return (sort contents)
{-
FYI: doesDirectoryExist path did NOT deliver the correct boolean for folders
(returned always False, except for .. and .) because listDirectory strips the path
to just the file/folder name. That's why we need to concat the path with the filePath again.
We also do not need the identity "." folder, hence the filter.
-}

{-
"getKey" function
written by Evi1M4chine and Chris Stryczynski
shared on https://stackoverflow.com/a/38553473
-}
getKey :: IO [Char]
getKey = reverse <$> getKey' ""
  where getKey' chars = do
          char <- getChar
          more <- hReady stdin
          (if more then getKey' else return) (char:chars)
  -- EXAMPLE:
  -- Simple menu controller
  -- main = do
  --   key <- getKey
  --   when (key /= "\ESC") $ do
  --     case key of
  --       "\ESC[A" -> putStr "↑"
  --       "\ESC[B" -> putStr "↓"
  --       "\ESC[C" -> putStr "→"
  --       "\ESC[D" -> putStr "←"
  --       _        -> return ()
  --     main

-- like getLine but it ignores the arrow keys and allows backspace to be used
getUserInput :: IO String
getUserInput = getUserInputWithText ""

-- not used outside of getUserInput
getUserInputWithText :: String -> IO String
getUserInputWithText text = getKey >>= (\char ->
                    if char == ['\n'] then -- enter
                      return text
                    else if char == "\DEL" then -- backspace
                      -- additionally to the character we need to delete we also erase the "^?" that has been printed on the command line
                      backSpaceCommandLine >> backSpaceCommandLine >> backSpaceCommandLine >> getUserInputWithText (init text)
                    else if (char == "\ESC[A") || (char == "\ESC[B") || (char == "\ESC[C") || (char == "\ESC[D") then
                      -- this removes the characters that have been printed on the command line
                      -- this does not work when the arrow keys are pressed too rapidly
                      backSpaceCommandLine >> backSpaceCommandLine >> backSpaceCommandLine >> backSpaceCommandLine >> getUserInputWithText text
                    else
                      getUserInputWithText (text ++ char)
                    )

backSpaceCommandLine :: IO ()
backSpaceCommandLine = putStr "\ESC[D \ESC[D" -- go back, print space, go back

getUserResponse :: String -> IO String
getUserResponse label = putStr (label ++ ": ") >> getUserInput

getUserConfirmation :: String -> IO Bool
getUserConfirmation label = putStr ("\r" ++ label ++ " [y/n]")
                          >> getKey
                          >>= (\key ->
                            if (key == "y") || (key == "Y") then
                              putStrLn "" >> return True
                            else if (key == "n") || (key == "N") then
                              putStrLn "" >> return False
                            else
                              getUserConfirmation label
                          )