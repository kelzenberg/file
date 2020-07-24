module Printer
(
  printContent,
  formatString,
) where

import System.Console.ANSI

-- ===============================================================
--                           Printer UTILS
-- ===============================================================


-- ===============================================================
--                           Printer EXPORTS
-- ===============================================================

-- a function that formats strings
formatString :: [SGR] -> String -> IO ()
formatString format name = setSGR format >> putStr name >> setSGR [Reset] >> putStrLn ""

-- a function that prints formatted files and folders to the console
printContent :: [(String, Bool)] -> [Char] -> IO ()
printContent [] _ = return ()
-- printContent (x:xs) = setSGR [SetColor Background Vivid Blue] >> putStr (fst x) >> setSGR [Reset] >> putStrLn "" >> printContent xs
printContent ((name, isFolder):xs) selectedFile | name == selectedFile = formatString [SetColor Foreground Vivid Red] name
                                                  >> printContent xs selectedFile
                                                | isFolder          = formatString [SetColor Foreground Vivid Blue] name
                                                  >> printContent xs selectedFile
                                                | otherwise         = formatString [SetColor Foreground Vivid White] name
                                                  >> printContent xs selectedFile