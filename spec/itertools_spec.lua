local itertools = require("itertools")

local function collect_results(iter, args, target_iterations)
  local i = 1
  local received = {}
  for x in iter(table.unpack(args)) do
    received[i] = x
    i = i + 1
    if target_iterations and i > target_iterations then
      return received
    end
  end

  return received
end

describe("#itertools", function()
  describe("count", function()
    it("uses a default step of 1", function()
      local received = collect_results(itertools.count, { 10 }, 3)
      assert.are.same({ 10, 11, 12 }, received)
    end)

    it("handles negative step values", function()
      local received = collect_results(itertools.count, { 5, -2 }, 4)
      assert.are.same({ 5, 3, 1, -1 }, received)
    end)
  end)

  describe("cycle", function()
    it("cycles through the given arguments in order", function()
      local received = collect_results(itertools.cycle, { 1, 2, 3 }, 6)
      assert.are.same({ 1, 2, 3, 1, 2, 3 }, received)
    end)
  end)

  describe("zip", function()
    it("returns one element from each array on each iteration", function()
      local numbers = { 1, 2, 3 }
      local letters = { "a", "b", "c" }
      local pos = 1

      for number, letter in itertools.zip(numbers, letters) do
        assert.are.equal(numbers[pos], number)
        assert.are.equal(letters[pos], letter)
        pos = pos + 1
      end
    end)

    it("only goes until the end of the shortest list", function()
      local shortlist = { 1, 2 }
      local longlist = { 1, 2, 3 }
      local received = collect_results(itertools.zip, { shortlist, longlist })

      assert.are.equal(#shortlist, #received)
    end)
  end)

  describe("map", function()
    it("applies the given function to each element in the sequence", function()
      local received = collect_results(itertools.map, { math.abs, { -2, 1, 3 } })
      assert.are.same({ 2, 1, 3 }, received)
    end)

    it("accepts multiple arrays for multiple argument functions", function()
      local function add(x, y)
        return x + y
      end
      local received = collect_results(itertools.map, { add, { 1, 2 }, { 3, 4 } })
      assert.are.same({ 4, 6 }, received)
    end)
  end)
end)
