# rubocop:disable Metrics/ClassLength
# create a node class
class Node
  include Comparable
  attr_accessor :data, :left, :right

  def initialize(data = nil)
    @data = data
    @left = nil
    @right = nil
  end

  def <=>(other)
    data <=> other.data
  end

  def promote_single_child
    if left.nil?
      right
    elsif right.nil?
      left
    end
  end
end

# tree class
class Tree
  attr_accessor :root

  def initialize(array)
    @root = build_tree(array)
  end

  def build_tree(array)
    return nil if array.empty?

    array = array.uniq.sort
    mid = array.size / 2
    root = Node.new(array[mid])
    root.left = build_tree(array[0...mid])
    root.right = build_tree(array[(mid + 1)..(array.size - 1)])
    root
  end

  def insert(value)
    @root = insertion(@root, Node.new(value))
  end

  def insertion(node, new_node)
    return new_node if node.nil?

    return node if node == new_node

    if new_node < node
      node.left = insertion(node.left, new_node)
    else
      node.right = insertion(node.right, new_node)
    end
    node
  end

  def delete(value)
    @root = deletion(@root, Node.new(value))
  end

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def deletion(node, deleteable)
    return node if node.nil?

    if deleteable < node
      node.left = deletion(node.left, deleteable)
    elsif deleteable > node
      node.right = deletion(node.right, deleteable)
    else
      return node.promote_single_child if node.left.nil? || node.right.nil?

      temp = min_node(node.right)
      node.data = temp.data
      node.right = deletion(node.right, temp)
    end
    node
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize

  def min_node(node)
    current = node
    return current if current.left.nil?

    current = current.left until current.left.nil?
    current
  end

  def find(value, current = @root)
    loop do
      return false if current.nil?

      return current if value == current.data

      current = value < current.data ? current.left : current.right
    end
  end

  def level_order(values = [], queue = [@root])
    return if queue.empty?

    node = queue.shift
    queue = queue.push(node.left, node.right).compact
    values << node.data
    level_order(values, queue)
    values
  end

  def inorder(node = @root, values = [])
    return if node.nil?

    inorder(node.left, values)
    values << node.data
    inorder(node.right, values)
    values
  end

  def preorder(node = @root, values = [])
    return if node.nil?

    values << node.data if node == @root

    preorder(node.left, values)
    values << node.data
    preorder(node.right, values)
    values
  end

  def postorder(node = @root, values = [])
    return if node.nil?

    postorder(node.left, values)
    values << node.data
    postorder(node.right, values)
    values << node.data if node == @root
  end

  def height(node = @root)
    return -1 if node.nil?

    lheight = height(node.left)
    rheight = height(node.right)
    return lheight + 1 if lheight > rheight

    rheight + 1
  end

  def depth(node, current = @root)
    return 0 if current == node

    depth = node < current ? depth(node, current.left) : depth(node, current.right)
    depth + 1
  end

  def balanced?(node = @root, array = [])
    return if node.left.nil? || node.right.nil?

    balanced?(node.left, array)
    array << (height(node.left) - height(node.right)).abs
    balanced?(node.right, array)
    array.none? { |i| i > 1 }
  end

  def rebalance
    nodes = level_order
    @root = build_tree(nodes)
  end

  # rubocop:disable Style/OptionalBooleanParameter
  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
  # rubocop:enable Style/OptionalBooleanParameter
end
# rubocop:enable Metrics/ClassLength
