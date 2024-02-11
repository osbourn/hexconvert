require('hexpatterns')

HexDecode = {}

function HexDecode.decode_pattern(pattern)
    local angles = pattern.angles
    local pattern = HexPatterns.from_angles(angles)
    if pattern then
        if HexPatterns.is_dynamic(pattern) then
            return pattern.translation..' ('..angles..')'
        else
            return pattern.translation
        end
    end

    if angles:match("^aqaa") or angles:match("^dedd") then
       return 'Numerical Reflection ('..angles..')'
    end

    return 'Unknown ('..angles..')'
end

function HexDecode.decode_nonlist(iota)
    if type(iota) == 'number' then
        return '- '..tostring(iota)
    elseif type(iota) == 'boolean' then
        return '- '..tostring(iota)
    elseif type(iota) == 'string' then
        return '- "'..iota..'"'
    elseif iota.angles then
       return HexDecode.decode_pattern(iota)
    elseif iota.null then
        return "- null"
    elseif iota.garbage then
        return "- garbage"
    elseif iota.x and iota.y and iota.z then
        return '<'..tostring(iota.x)..', '..tostring(iota.y)..', '..tostring(iota.z)..'>'
    elseif iota.uuid then
        return '- garbage // Entities are currently unsupported by the decoder'
    elseif iota.iotaType then
        return '- garbage // Iota Types are currently unsupported by the decoder'
    elseif iota.gate then
        return '- garbate // Gates are currently unsupported by the decoder'
    elseif iota.moteUuid then
        return '- garbage // Motes are currently unsupported by the decoder'
    elseif iota.matrix then
        return '- garbage // Matricies are currently unsuppored by the decoder'
    else
        return '- garbage // Unrecognized Iota Type'
    end
end

function HexDecode.decode_iotas(iotas)
    local lines = {}
    for _,iota in ipairs(iotas) do
        -- Check if iota is a list
        if type(iota) == 'table' and (iota == {} or iota[1]) then
            table.insert(lines, '[')
            for _,line in ipairs(HexDecode.decode_iotas(iota)) do
                table.insert(lines, "    "..line)
            end
            table.insert(lines, ']')
        else
            table.insert(lines, HexDecode.decode_nonlist(iota))
        end
    end
    return lines
end
