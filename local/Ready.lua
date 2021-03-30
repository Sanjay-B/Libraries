--[[
    MIT License

    Copyright (c) 2018 EmeraldSlash

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
]]--

local DEFAULT_TIMEOUT = 1 -- Length of time where no descendants have been added to consider the object loaded

-- @author EmeraldSlash
-- @repository https://github.com/EmeraldSlash/RbxReady
-- @rostrap Can be loaded using the Rostrap library manager

local Ready = {}

function Ready:Wait(Object, Timeout)
	if not Timeout then Timeout = DEFAULT_TIMEOUT end		
	
	local Timestamp = tick()
	local LastDescendant

	Object.DescendantAdded:Connect(function(Descendant)
		Timestamp = tick()
		LastDescendant = Descendant
	end)	
	
	repeat wait() until (tick() - Timestamp) > Timeout
	return LastDescendant
end

function Ready:Connect(Object, Function, Timeout)
	if not Timeout then Timeout = DEFAULT_TIMEOUT end	
	
	local Timestamp = tick()
	local Connection

	local function LogDescendant(Descendant)
		local LocalTimestamp = tick()
		Timestamp = LocalTimestamp
		
		wait(Timeout)
		if Timestamp == LocalTimestamp and Connection.Connected then
			Connection:Disconnect()
			Function(Descendant)			
		end
	end

	coroutine.resume(coroutine.create(LogDescendant))
	Connection = Object.DescendantAdded:Connect(LogDescendant)
	
	return Connection
end

return Ready
