-- https://github.com/dan200/ComputerCraft/blob/master/src/main/resources/assets/computercraft/lua/rom/programs/http/wget.lua
local function get( sUrl )
    write( "Connecting to " .. sUrl .. "... " )

    local ok, err = http.checkURL( sUrl )
    if not ok then
        print( "Failed." )
        if err then
            printError( err )
        end
        return nil
    end

    local response = http.get( sUrl , nil , true )
    if not response then
        print( "Failed." )
        return nil
    end

    print( "Success." )

    local sResponse = response.readAll()
    response.close()
    return sResponse
end

function wget(url, path)
    local cont = get(url)
    if cont then
        fp = fs.open(path, "wb")
        fp.write(cont)
        fp.close()
    end
end

function main(cfg)
    wget("https://raw.githubusercontent.com/Baidicoot/switchcraft-stuff/master/utils.lua", "utils")
    wget("https://raw.githubusercontent.com/Baidicoot/switchcraft-stuff/master/bos.lua", "bos")
    wget("https://raw.githubusercontent.com/Baidicoot/switchcraft-stuff/master/startup.lua", "startup")

    local bos = require "bos"
    bos.main(cfg)
end