{-# LANGUAGE OverloadedStrings #-}

module CSVImport
    ( importCSVs
    ) where

import Turtle
import Prelude hiding (FilePath, putStrLn)
import Data.Text.IO (putStrLn)
import Common

importCSVs :: FilePath -> IO ()
importCSVs baseDir = do
  echo "BEGIN: importCSVs"
  sh $ importBanks $ validDirs $ ls (baseDir </> "import")
  echo "END: importCSVs"

importBanks :: Shell FilePath -> Shell ()
importBanks bankDirs = do
  echoShell "BEGIN: importBanks"
  view bankDirs
  bd <- bankDirs
  case (textToLine $ format fp $ basename bd) of
    Nothing -> die $ format ("Unable to determine bank name from path: "%fp%"\n") bd
    Just bankName -> importAccounts bankName $ ls bd
  echoShell "END: importBanks"

importAccounts :: Line -> Shell FilePath -> Shell ()
importAccounts bankName accountDirs = do
  echoShell $ "BEGIN: importAccounts"
  printShell bankName

  view accountDirs
  echoShell $ "END: importAccounts"
