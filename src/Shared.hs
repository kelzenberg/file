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

-- a function that returns True if the given path is a directory
isDirectory :: FilePath -> IO Bool
isDirectory path = doesDirectoryExist path


-- ===============================================================
--                           Shared EXPORTS
-- ===============================================================

-- a function that takes a folder path and returns files and folders
--                                  folders  files
getFolderContent :: FilePath -> IO [(String, Bool)]
getFolderContent path = getDirectoryContents path 
                      >>= (\content -> restructureContentMonads (map (\(n, d) -> (takeFileName n, d)) $ map (\fileName -> (fileName, isDirectory fileName)) content))
                      >>= (\content -> return (sort content))


restructureContentMonads :: [(String, IO Bool)] -> IO [(String, Bool)]
restructureContentMonads [] = return []
restructureContentMonads ((name, isDirIO):xs) = isDirIO >>= \isDir -> (
    restructureContentMonads xs >>= \rest ->
    return ([(name, isDir)] ++ rest)
  )

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