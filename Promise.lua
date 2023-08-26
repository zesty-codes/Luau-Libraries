local Promise = {}
if setreadonly then
    local old = setreadonly
    getgenv().setreadonly = function(a, b)
        if a == Promise then return nil else return old(a, b) end
    end
end

function Promise.new(f)
	local promiseId;
	promiseId = tostring(("%d%d%d"):format(math.random(1000, 2999), math.random(1000, 2999), math.random(1000, 2999)))
	local self = {}
	local val;
	
	local function resolve(self)
		val = self
	end
	
	local function reject(self)
		warn(`Promise within the ID of {promiseId} has been rejected and failed to run.`)
	end
	
	local suc, err = pcall(function()
		return f(resolve, reject)
	end)
	
	function self.delay(d)
		local waitForSeconds = tonumber(string.format("%s", tostring(d)))
		task.wait(waitForSeconds)
		return self
	end
	
	function self.andThen(f)
		f(val)
		return self
	end
	
	function self.await(r)
		repeat task.wait(1 / 9e9) until r
		return self
	end
	
	return self
end

function Promise.delay(d)
	local waitForSeconds = tonumber(string.format("%s", tostring(d)))
	task.wait(waitForSeconds)
	return Promise
end

function Promise.executeAsync(f)
	Promise.new(f)
	return Promise
end

function Promise.await(r)
	repeat task.wait(1 / 9e9) until r
	return Promise
end

table.freeze(Promise)

return Promise
