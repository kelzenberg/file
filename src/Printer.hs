import System.Console.ANSI as Console

module Printer
(
  printContent,
) where

-- a function that formats strings
formatString :: [Console.SGR] -> String -> IO ()
formatString format name = Console.setSGR format >> putStr name >> Console.setSGR [Reset] >> putStrLn ""

-- a function that prints formatted files and folders to the console
printContent :: [(String, Bool)] -> IO ()
printContent [] = return ()
-- printContent (x:xs) = setSGR [SetColor Background Vivid Blue] >> putStr (fst x) >> setSGR [Reset] >> putStrLn "" >> printContent xs
printContent ((name, isFolder):xs)  | isFolder  = formatString [Console.SetColor Foreground Vivid Blue] name
                                                  >> printContent xs
                                      | otherwise = formatString [Console.SetColor Foreground Vivid Red] name
                                                  >> printContent xs