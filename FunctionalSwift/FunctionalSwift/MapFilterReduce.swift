//
//  MapFilterReduce.swift
//  FunctionalSwift
//
//  Created by qingfengiOS on 2018/6/29.
//  Copyright © 2018年 qingfengiOS. All rights reserved.
//

import UIKit

//实际上，比起定义一个顶层 map 函数，按照 Swift 的惯例将 map 定义为 Array 的扩展会更合适：
extension Array {
    func map<T>(_ transform: (Element) -> T) -> [T] {
        var res: [T] = []
        for x in self {
            res.append(transform(x))
        }
        return res
    }
    
    /*
     作为 map(xs, transform) 的替代，我们现在可以通过 xs.map(transform) 来调用 Array 的 map 函数：
     */
    func genericComputerArray<T>(xs: [Int], transform: (Int) -> T) -> [T] {
        return xs.map(transform)
    }
}

extension Array {
    func filter(_ isIncluded: (Element) -> Bool) -> [Element] {
        var result: [Element] = []
        for x in self where isIncluded(x) {
            result.append(x)
        }
        return result
    }
    /*
     filter 函数接受一个函数作为参数。filter 函数的类型是 Element -> Bool —— 对于数组中的所有元素，此函数都会判定它是否应该被包含在结果中
     */
}



class MapFilterReduce: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let res = map(xs: [1,2,3]) { x in
            print(x)
        }
        print("res = \(res)")
        
        let array = [1, 2]
        let res2 = array.genericComputerArray(xs: array) { (x) in
            print(x)
        }
        print(res2)
        
        let exampleFiles = ["README.md", "HelloWorld.swift", "FlappyBird.swift"]
        let res3 = getSwiftFiles(files: exampleFiles)
        print("res3 = \(res3)")
        
        let res4 = getSwiftFiles2(files: exampleFiles)
        print("res4 = \(res4)")
        
        print(sum(xs: [1, 2, 3, 4]))
        print(prettyPrintArray(xs: ["one", "two", "three"]))
        
        print(sumUsingReduce(xs: [1, 2, 3, 4]))
        print(prettyPrintArrayUsingReduce(xs: ["one", "two", "three"]))
        
    }
    
    //MARK:-Map
    func map<Element, T>(xs:[Element], transform:(Element) -> T) -> [T] {
        var result: [T] = []
        for x in xs {
            result.append(transform(x))
        }
        return result
        
        /*
         这里我们写了一个 map 函数，它在两个维度都是通用的：对于任何 Element 的数组和 transform: Element -> T 函数，它都会生成一个 T 的新数组
         */
    }
    

    //MARK:-Filter
    /*
     假设我们有一个由字符串组成的数组，代表文件夹的内容:
     let exampleFiles = ["README.md", "HelloWorld.swift", "FlappyBird.swift"]
     
     现在如果我们想要一个包含所有 .swift 文件的数组，可以很容易通过简单的循环得到：
     */
    func getSwiftFiles(files: [String]) -> [String] {
        var res: [String] = []
        for file in files {
            if file.hasSuffix(".swift") {
                res.append(file)
            }
        }
        return res
    }
    
    //根据 filter 能很容易地定义 getSwiftFiles
    func getSwiftFiles2(files: [String]) -> [String] {
        return files.filter({ (file) in
            file.hasSuffix(".swift")
        })
    }
    
    //MARK:-Reduce
    func sum(xs: [Int]) -> Int {
        var result: Int = 0
        for x in xs {
            result += x
        }
        return result
    }
    
    func prettyPrintArray(xs: [String]) -> String {
        var result: String = "Entries in the array xs:\n"
        for x in xs {
            result = " " + result + x + "\n"
        }
        return result
    }
    
    
    //使用reduce定义上面的函数
    func sumUsingReduce(xs: [Int]) -> Int {
        return xs.reduce(initial: 0, combine: { (result, x) in
            result + x
        })
    }
    
    func prettyPrintArrayUsingReduce(xs: [String]) -> String {
        return xs.reduce(initial: " Entries in the array xs:\n", combine:{ (result, x) in
            " " + result + x + "\n"
        })
    }
}

/*
 sum:, prettyPrintArray: 这些函数有什么共同点呢？它们都将变量 result 初始化为某个值。随后对输入数组 xs 的每一项进行遍历，最后以某种方式更新结果。为了定义一个可以体现所需类型的泛型函数，我们需要对两份信息进行抽象：赋给 result 变量的初始值，和用于在每一次循环中更新 result 的函数:
 */
extension Array {
    func reduce<T>(initial: T, combine:(T, Element) -> T) -> T {
        var result = initial
        for x in self {
            result = combine(result, x)
        }
        return result
    }
    /*
     这个函数的泛型体现在两个方面：对于任意 [Element] 类型的输入数组来说，它会计算一个类型为 T 的返回值。这么做的前提是，首先需要一个 T 类型的初始值 (赋给 result 变量)，以及一个用于更新 for 循环中变量值的函数 combine: (T, Element) -> T。在一些像 OCaml 和 Haskell 一样的函数式语言中，reduce 函数被称为 fold 或 fold_left
     */
    
}




