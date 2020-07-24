module DirState
(
  DirState,
  increaseSelection,
  decreaseSelection,
  initState,
  updateStateContent,
  printState,
  enterDirectory,
) where
  
import System.Directory
import Shared
import Printer
import System.Console.ANSI

-- ===============================================================
--                           DirState UTILS
-- ===============================================================

data DirState = DirState {
  path :: FilePath,            -- complete file/folder path
  content :: [(String, Bool)], -- list with (file/folder name, isFolder bool) tupels
  selectionIdx :: Int          -- current user-selected index
} deriving (Show)

-- fixSelectionIdx takes a selectionIndex and makes shure that it is in the bounds of the content
fixSelectionIdx :: Int -> [(String, Bool)] -> Int
fixSelectionIdx selectionIdx content = selectionIdx `mod` (length content)

getSelectionName :: DirState -> String --
getSelectionName state = fst ((content state) !! (selectionIdx state))

changeSelection :: DirState -> (Int -> Int) -> IO DirState
changeSelection state x = return (DirState (path state) (content state) (fixSelectionIdx (x (selectionIdx state)) (content state)))


-- ===============================================================
--                           DirState EXPORTS
-- ===============================================================

{- ________________________________ STATE _______________________________ -}

-- initializes the state
initState :: IO DirState
initState = getHomeDirectory >>= \dir -> return (DirState dir [] 0)

-- takes a state and replaces the files and folders in it with the actual data from the drive
updateStateContent :: DirState -> IO DirState
updateStateContent state = getFolderContent (path state) >>= \content -> return (DirState (path state) content (fixSelectionIdx (selectionIdx state) content))

-- takes a state and prints it and its content on the screen
printState :: DirState -> IO DirState
printState state = clearScreen
                >> formatString [SetSwapForegroundBackground True] ("=> " ++ path state ++ " (" ++ show (selectionIdx state) ++ ")")
                >> printContent (content state) (getSelectionName state) >> return state


{- ________________________________ SELECTION _______________________________ -}

-- increases the selection index by one (down ↓)
increaseSelection :: DirState -> IO DirState
increaseSelection state = changeSelection state (+1)

-- decreases the selection index by one (up ↑)
decreaseSelection :: DirState -> IO DirState
decreaseSelection state = changeSelection state (subtract 1) --  -1 or 1- would not work

-- enters the directory that is selected
-- if no directory is selection nothing happens
enterDirectory :: DirState -> IO DirState
enterDirectory state = return state