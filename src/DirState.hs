module DirState
(
  DirState (..),
  initState,
  updateStateContent,
  fixSelectionIdx,
) where
  
import Shared
import System.Directory
import System.Console.ANSI
import System.FilePath.Posix

data DirState = DirState {
  getPath :: FilePath,            -- complete file/folder path
  getContent :: [(String, Bool)], -- list with (file/folder name, isFolder bool) tupels
  getSelectionIdx :: Int          -- current user-selected index
} deriving (Show)

-- ===============================================================
--                           DirState UTILS
-- ===============================================================

-- // --

-- ===============================================================
--                           DirState EXPORTS
-- ===============================================================

-- initializes the state
initState :: IO DirState
initState = getHomeDirectory >>= \dir -> return (DirState dir [] 0)

-- takes a state and replaces the files and folders in it with the actual data from the drive
updateStateContent :: DirState -> IO DirState
updateStateContent state = getFolderContent (getPath state)
          >>= \content -> return (if getPath state == "/" then content else ([("..", True)] ++ content))
          >>= \content -> return (DirState (getPath state) content (fixSelectionIdx (getSelectionIdx state) content))

-- fixSelectionIdx takes a selectionIndex and makes shure that it is in the bounds of the content
fixSelectionIdx :: Int -> [(String, Bool)] -> Int
fixSelectionIdx selectionIdx content = selectionIdx `mod` (length content)