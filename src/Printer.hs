module Printer
(
  printContent,
  printState,
) where

import DirState
import Input
import Shared
import System.Console.ANSI
import System.FilePath.Posix

-- ===============================================================
--                           Printer UTILS
-- ===============================================================

-- // --

-- ===============================================================
--                           Printer EXPORTS
-- ===============================================================

-- takes a state and prints it and its content on the screen
printState :: DirState -> IO DirState
printState state = clearScreen
                >> formatString [SetSwapForegroundBackground True] [SetUnderlining NoUnderline]
                   ("=> " ++ joinPath [getPath state, getSelectionName state])
                >> printContent (getContent state) (getSelectionName state) >> return state

-- a function that prints formatted files and folders to the console
printContent :: [(String, Bool)] -> [Char] -> IO ()
printContent [] _ = return ()
-- printContent (x:xs) = setSGR [SetColor Background Vivid Blue] >> putStr (fst x) >> setSGR [Reset] >> putStrLn "" >> printContent xs
printContent ((name, isFolder):xs) selectedFile | name == selectedFile =
                                                  formatString [SetColor Foreground Vivid Red] [SetUnderlining SingleUnderline] name
                                                  >> printContent xs selectedFile
                                                | isFolder =
                                                  formatString [SetColor Foreground Vivid Blue] [SetUnderlining NoUnderline] name
                                                  >> printContent xs selectedFile
                                                | otherwise =
                                                  formatString [SetColor Foreground Vivid White] [SetUnderlining NoUnderline] name
                                                  >> printContent xs selectedFile