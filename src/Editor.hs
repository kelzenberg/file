module Editor
(
  openEditor,
) where

import System.Process
import System.IO
import System.Exit

openEditor :: String -> IO ()
openEditor filePath = runFullCommand "nano" [filePath]

-- run the command with the supplied args and pipe stdin, stdout and stderr
runFullCommand :: String -> [String] -> IO ()
runFullCommand cmd args =
    do
        (_, _, _, ph) <- createProcess (proc cmd args)
            { std_in  = UseHandle stdin
            , std_err = UseHandle stderr
            , std_out = UseHandle stdout
            }
        waitForProcess ph >> return ()
