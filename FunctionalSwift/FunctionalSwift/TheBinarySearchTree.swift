//
//  TheBinarySearchTree.swift
//  FunctionalSwift
//
//  Created by qingfeng on 2018/7/10.
//  Copyright © 2018年 qingfengiOS. All rights reserved.
//

import UIKit

indirect enum BinarySearchTree<Element: Comparable> {
    case Leaf//叶子节点
    case Node(BinarySearchTree<Element>, Element, BinarySearchTree<Element>)//左子树 根节点 右子树
}

/**
 leaf 树是空的；five 树在节点上存了值 5，但两棵子树都为空。我们可以编写两个构造方法来生成这两种树：一个会创建一棵空树，而另一个则创建含有某个单独值的树：
 */
extension BinarySearchTree {
    init() {
        self = .Leaf
    }
    
    init(_ value: Element) {
        self = .Node(.Leaf, value, .Leaf)
    }
    
    var count: Int {//count属性，算一棵树中存值的个数
        switch self {
        case .Leaf:
            return 0
        case let .Node(left, _, right):
            return 1 + left.count + right.count
        }
    }
    
    var elements: [Element] {//elements 属性，用于计算树中所有元素组成的数组
    
        switch self {
        case .Leaf:
            return []
        case let .Node(left, x, right):
            return left.elements + [x] + right.elements
        }
    }
    
    var isEmpty: Bool {//检查一棵树是否为空
        if case .Leaf = self {
            return true
        }
        return false
    }
}

extension BinarySearchTree where Element: Comparable {
    
    /// 判断一棵树是否是二叉搜索树
    var isBinarySearchTree: Bool {
        switch self {
        case .Leaf:
            return true
        case let .Node(left, x, right):
            return self.smaller(key: x, array: left.elements)
                && self.bigger(key: x , array: left.elements)
                && left.isBinarySearchTree
                && right.isBinarySearchTree
            
        }
    }
    
    func smaller(key: Element, array: Array<Element>) -> Bool {
        for x in array {
            if x > key {
                return false
            }
        }
        return true
    }
    
    func bigger(key: Element, array: Array<Element>) -> Bool {
        for x in array {
            if x < key {
                return false
            }
        }
        return true
    }
}

extension BinarySearchTree {
    
    /// 判断一个二叉树是否包含某元素
    ///
    /// - Parameter x: 目标元素
    /// - Returns: 是否包含
    func contains(x: Element) -> Bool {
        switch self {
        case .Leaf:
            return false
        case let .Node(_, y, _) where x == y:
            return true
        case let .Node(left, y, _) where x < y:
            return left.contains(x: x)
        case let .Node(_, y, right) where x > y:
            return right.contains(x: x)
        default:
            fatalError("The impossible occurred")
        }
        
        /*
         contains 函数现在被分为四种可能的情况：
         
         1.如果树是空的，则 x 不在树中，返回 false。
         
         2.如果树不为空，且储存在根节点的值与 x 相等，返回 true。
         
         3.如果树不为空，且储存在根节点的值大于 x，那么如果 x 在树中的话，它一定是在左子树中，所以，我们在左子树中递归搜索 x。
         
         4.类似地，如果根节点的值小于 x，我们就在右子树中继续搜索。
         */
    }
}

extension BinarySearchTree {
    
    /// 插入值到二叉树
    ///
    /// - Parameter x: 插入的值
    mutating func insert(_ x: Element) {
        switch self {
        case .Leaf:
            self = BinarySearchTree(x)
        case .Node(var left, let y, var right):
            if x < y { left.insert(x) }
            if x > y { right.insert(x) }
            self = .Node(left, y, right)
        }
    }
}


class TheBinarySearchTree: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        let leaf: BinarySearchTree<Int> = .Leaf
        let five: BinarySearchTree<Int> = .Node(leaf,5,leaf)
        
        print(five.isEmpty)
        print(five.elements)
        print(five.count)
        print(five.isBinarySearchTree)
        print(five.contains(x: 6))
        print("--------------------")
        let myTree: BinarySearchTree<Int> = BinarySearchTree()
        var copied = myTree
        copied.insert(5)
        print("myTree = \(myTree)\ncopied = \(copied)")
        
    }

    

}
