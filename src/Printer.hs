module Src.Printer
(
  printContent,
) where

import System.Console.ANSI

-- a function that formats strings
formatString :: [SGR] -> String -> IO ()
formatString format name = setSGR format >> putStr name >> setSGR [Reset] >> putStrLn ""

-- a function that prints formatted files and folders to the console
printContent :: [(String, Bool)] -> IO ()
printContent [] = return ()
-- printContent (x:xs) = setSGR [SetColor Background Vivid Blue] >> putStr (fst x) >> setSGR [Reset] >> putStrLn "" >> printContent xs
printContent ((name, isFolder):xs)  | isFolder  = formatString [SetColor Foreground Vivid Blue] name
                                                  >> printContent xs
                                      | otherwise = formatString [SetColor Foreground Vivid Red] name
                                                  >> printContent xs