module Shared
(
  getFolderContent,
  getKey,
) where

import System.Directory
import System.FilePath.Posix
import Data.List
import System.IO (stdin, hReady)

-- ===============================================================
--                           Shared UTILS
-- ===============================================================

-- a function that returns True if the given path is a directory
isDirectory :: FilePath -> IO Bool
isDirectory path = doesDirectoryExist path


-- ===============================================================
--                           Shared EXPORTS
-- ===============================================================

-- a function that takes a folder path and returns files and folders
--                                  folders  files
getFolderContent :: FilePath -> IO [(String, Bool)]
getFolderContent path = isDirectory path
                      >>= \isDir -> listDirectory path
                      >>= \content -> return (sort
                      $ map (\fileName -> (fileName, isDir))
                      $ map takeFileName content)

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