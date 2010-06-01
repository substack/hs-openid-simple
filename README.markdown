Reall simple OpenID authentication in haskell.

Synopsis
========

    import qualified Network.OpenID.Simple as ID

    main = do
        -- authenticate via substack.myopenid.com and return to http://substack.net/
        session <- ID.authenticate "substack.myopenid.com" "http://substack.net/"
        
        -- user is forwarded here:
        putStrLn $ "Location: " ++ ID.authURI session
        
        -- user was returned to this page:
        uri <- getLine
        
        ok <- ID.verify session uri
        
        putStrLn $ case ok of
            Nothing -> "Verified as " ++ ID.identity session
            Just err -> "Failed to verify authentication: " ++ err
