import System.Directory as Directory
import System.FilePath.Posix as Path
import Data.List as List
import System.Console.ANSI as Console

{-
folderpath -> getDirectoryContent
     \_________________/
             V
           State

printState

awaitUserAction State
    // perform operation on state
    // return new state
    // repeat loop
-}

data State = State {
  path :: FilePath,
  content :: [(String, Bool)], -- (file name, isFolder)
  selection :: Int
} deriving (Show)

-- a function that initializes the state
initState :: IO State
initState = Directory.getHomeDirectory >>= \dir -> return (State dir [] 0)

-- a function that takes a folder path and returns files and folders
--                                  folders   files
getFolderContent :: FilePath -> IO [(String, Bool)]
getFolderContent path = Directory.listDirectory path >>= \content -> return (sort $ map (\fileName -> (fileName, False)) $ map Path.takeFileName content)

-- a function that takes a state and replaces the files and folders in it with the actual data from the drive
updateStateContent :: State -> IO State
updateStateContent state = getFolderContent (path state) >>= \content -> return (State (path state) content (validSelection state content))
  -- validSelection takes the old state and the loaded content of the directory
  -- and checks weather the selection index in the old state is still valid with the new amount of files and folders
  -- if the index would be too large it returns 0
  where validSelection :: State -> [(String, Bool)] -> Int
        validSelection state content | (selection state) >= (length (content !! 0)) + (length (content !! 1)) = 0
                                     | otherwise                                                              = (selection state)

-- a function that takes a state and prints in on the screen
printState :: State -> IO State
printState state = putStrLn (path state) >> contentPrinter (content state) >> return state
  where
    -- todo print files and folder differently
    contentPrinter :: [(String, Bool)] -> IO ()
    contentPrinter [] = return ()
    -- contentPrinter (x:xs) = setSGR [SetColor Background Vivid Blue] >> putStr (fst x) >> setSGR [Reset] >> putStrLn "" >> contentPrinter xs
    contentPrinter ((name, isFolder):xs) | isFolder  = printFormatted [Console.SetColor Foreground Vivid Blue] name >> contentPrinter xs
                                         | otherwise = printFormatted [Console.SetColor Foreground Vivid Red] name >> contentPrinter xs
    printFormatted :: [Console.SGR] -> String -> IO ()
    printFormatted format name = Console.setSGR format >> putStr name >> Console.setSGR [Reset] >> putStrLn ""

-- a function that waits for a user action and performs that action on the state and on the drive

main = initState >>= updateStateContent >>= mainLoop

mainLoop :: State -> IO ()
mainLoop state = printState state >> return () -- >>= mainLoop state