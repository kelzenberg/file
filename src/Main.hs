import DirState

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


-- a function that enables recurring inputs from the user and reacts accordingly
mainLoop :: DirState -> IO ()
mainLoop state = printState state >> return () -- >>= mainLoop state

-- a function that waits for a user action and performs that action on the state and on the drive
main = initState >>= updateStateContent >>= mainLoop