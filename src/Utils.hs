import System.Directory as Directory
import System.FilePath.Posix as Path

module Utils
(
  getFolderContent,
) where

-- a function that takes a folder path and returns files and folders
--                                  folders  files
getFolderContent :: FilePath -> IO [(String, Bool)]
getFolderContent path = Directory.listDirectory path
                      >>= \content -> return (sort
                      $ map (\fileName -> (fileName, isDirectory path))
                      $ map Path.takeFileName content)