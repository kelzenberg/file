module Utils
(
  getFolderContent,
) where

import System.Directory
import System.FilePath.Posix
import Data.List

-- a function that returns True if the given path is a directory
isDirectory :: FilePath -> IO Bool
isDirectory path = doesDirectoryExist path

-- a function that takes a folder path and returns files and folders
--                                  folders  files
getFolderContent :: FilePath -> IO [(String, Bool)]
getFolderContent path = isDirectory path
                      >>= \isDir -> listDirectory path
                      >>= \content -> return (sort
                      $ map (\fileName -> (fileName, isDir))
                      $ map takeFileName content)