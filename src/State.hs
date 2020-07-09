import System.Directory as Directory
import Utils as Utils
import Printer as Printer

module State
(
  DirState,
  initState,
  updateStateContent,
  printState
) where

data DirState = DirState {
  path :: FilePath,
  content :: [(String, Bool)], -- (file name, isFolder)
  selection :: Int
} deriving (Show)

-- a function that initializes the state
initState :: IO DirState
initState = Directory.getHomeDirectory >>= \dir -> return (DirState dir [] 0)

-- a function that takes a state and replaces the files and folders in it with the actual data from the drive
updateStateContent :: DirState -> IO DirState
updateStateContent state = Utils.getFolderContent (path state) >>= \content -> return (DirState (path state) content (validSelection state content))
  -- validSelection takes the old state and the loaded content of the directory
  -- and checks weather the selection index in the old state is still valid with the new amount of files and folders
  -- if the index would be too large it returns 0
  where validSelection :: DirState -> [(String, Bool)] -> Int
        validSelection state content | (selection state) >= (length (content !! 0)) + (length (content !! 1)) = 0
                                     | otherwise                                                              = (selection state)

-- a function that takes a state and prints it and its content on the screen
printState :: DirState -> IO DirState
printState state = putStrLn (path state) >> Printer.printContent (content state) >> return state