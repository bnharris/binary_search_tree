$LOAD_PATH << '.'
require 'binary_tree'

arr = Array.new(15) { rand(100) }
tree = Tree.new(arr)
p tree.balanced?
tree.pretty_print
arr = Array.new(10) { rand(100..500) }
arr.each { |i| tree.insert(i) }
p tree.balanced?
tree.pretty_print
tree.rebalance
p tree.balanced?
tree.pretty_print
