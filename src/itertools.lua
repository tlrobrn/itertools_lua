local M = {}

-- count(start, [step])
local function count_iter(state)
  state.pos = state.pos + state.step
  return state.pos
end

function M.count(start, step)
  step = step or 1
  return count_iter, { pos = start - step, step = step }
end

-- cycle(...)
local function cycle_iter(state)
  state.pos = state.pos + 1
  if state.pos > #state.array then
    state.pos = 1
  end
  return state.array[state.pos]
end

function M.cycle(...)
  return cycle_iter, { pos = 0, array = { ... } }
end

-- zip(...)
local function min_length(arrays)
  local length = nil

  for _, array in ipairs(arrays) do
    local array_len = #array
    if not length or array_len < length then
      length = array_len
    end
  end

  return length
end

local function nth_values(n, arrays)
  local values = {}
  for i, array in ipairs(arrays) do
    values[i] = array[n]
  end

  return values
end

local function zip_iter(state)
  if state.pos > state.max then
    return nil
  end

  local values = nth_values(state.pos, state.arrays)
  state.pos = state.pos + 1

  return table.unpack(values)
end

function M.zip(...)
  local arrays = { ... }
  return zip_iter, { arrays = arrays, pos = 1, max = min_length(arrays) }
end

-- map(fn, ...)
local function map_iter(state)
  if state.pos > state.max then
    return nil
  end

  local args = nth_values(state.pos, state.arrays)
  state.pos = state.pos + 1

  return state.fn(table.unpack(args))
end

function M.map(fn, ...)
  local arrays = { ... }
  return map_iter, { fn = fn, arrays = arrays, pos = 1, max = min_length(arrays) }
end

return M
