import DirState
import Input

{-
folderpath -> getDirectoryContent
     \_________________/
             V
           DirState

printing state

awaitUserAction DirState
    // perform operation on state
    // return new state
    // repeat loop
-}


-- enables recurring inputs from the user and reacts accordingly
mainLoop :: DirState -> IO ()
mainLoop state = printState state >>= manipulateState >>= (\(newState, exit) -> if exit then return () else mainLoop newState)

-- waits for a user action and performs that action on the state and on the drive
main = initState >>= updateStateContent >>= mainLoop