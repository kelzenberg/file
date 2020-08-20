module DirState
(
  DirState (..),
  getSelectionName,
  increaseSelection,
  decreaseSelection,
  initState,
  updateStateContent,
  enterDirectory,
) where
  
import System.Directory
import Shared
import System.Console.ANSI
import System.FilePath.Posix

-- ===============================================================
--                           DirState UTILS
-- ===============================================================

data DirState = DirState {
  getPath :: FilePath,            -- complete file/folder path
  getContent :: [(String, Bool)], -- list with (file/folder name, isFolder bool) tupels
  getSelectionIdx :: Int          -- current user-selected index
} deriving (Show)

-- fixSelectionIdx takes a selectionIndex and makes shure that it is in the bounds of the content
fixSelectionIdx :: Int -> [(String, Bool)] -> Int
fixSelectionIdx selectionIdx content = selectionIdx `mod` (length content)

getSelectionName :: DirState -> String --
getSelectionName state = fst ((getContent state) !! (getSelectionIdx state))

changeSelection :: DirState -> (Int -> Int) -> IO DirState
changeSelection state x = return (DirState (getPath state) (getContent state) (fixSelectionIdx (x (getSelectionIdx state)) (getContent state)))

isDirectorySelected :: DirState -> Bool
isDirectorySelected state = snd ((getContent state) !! (getSelectionIdx state))

-- ===============================================================
--                           DirState EXPORTS
-- ===============================================================

{- ________________________________ STATE _______________________________ -}

-- initializes the state
initState :: IO DirState
initState = getHomeDirectory >>= \dir -> return (DirState dir [] 0)

-- takes a state and replaces the files and folders in it with the actual data from the drive
updateStateContent :: DirState -> IO DirState
updateStateContent state = getFolderContent (getPath state) >>= \content -> return (DirState (getPath state) content (fixSelectionIdx (getSelectionIdx state) content))


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
enterDirectory state | isDirectorySelected state = return (DirState (joinPath [(getPath state), (getSelectionName state)]) [] 0)
                     | otherwise = return state