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

class TheBinarySearchTree: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        let leaf: BinarySearchTree<Int> = .Leaf
        let five: BinarySearchTree<Int> = .Node(leaf,5,leaf)
        
        print(five.isEmpty)
    }

    

}
