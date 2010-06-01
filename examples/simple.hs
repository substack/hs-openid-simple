import qualified Network.OpenID.Simple as ID
import System.Environment (getArgs)

main = do
    -- ident is the string the user would usually type in a textbox themselves
    -- returnTo is the uri the user will be forwarded to after authentication
    [ident,returnTo] <- getArgs
    
    -- authenticate with the remote provider and collect the information
    -- necessary to verify the identity
    session <- ID.authenticate ident returnTo
    
    -- At this point, session data can be written to a file or a database as a
    -- string with show and read back later once the user arrives back at the
    -- forwarded page. The Session type derives Read and Show.
    
    -- The session has records for the normalized identity and provider strings.
    putStrLn $ "Normalized Ident: " ++ ID.identity session
    putStrLn $ "Provider: " ++ ID.provider session
    
    -- Forward the user along to the authentication uri, or else just copy/paste
    -- this link in this command-line demonstration.
    putStrLn $ "Forward: " ++ ID.authURI session
    
    -- Use the uri the user landed back at for the verify step.
    -- In a real web application, you'd read this from something like the
    -- environment's REQUEST_URI.
    putStrLn "Paste the uri you were returned to:"
    uri <- getLine
    
    -- Verify the credentials. The query parameters from the uri are parsed to
    -- make sure everything checks out.
    -- This step will fail by calling the config's verifyError if the user can't
    -- be verified.
    ok <- ID.verify session uri
    
    case ok of
        Nothing -> -- success
            putStrLn $ "Verified as '" ++ ID.identity session ++ "'!"
        Just err -> -- failure
            putStrLn $ "Failed to verify authentication: " ++ err
