module Shared
(
  getFolderContent,
  getKey,
  getUserResponse,
) where

import System.Directory
import System.FilePath.Posix
import Data.List
import System.IO (stdin, hReady)

-- ===============================================================
--                           Shared UTILS
-- ===============================================================

-- // --

-- ===============================================================
--                           Shared EXPORTS
-- ===============================================================

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

getUserResponse :: String -> IO String
getUserResponse label = putStr (label ++ ": ") >> getLine