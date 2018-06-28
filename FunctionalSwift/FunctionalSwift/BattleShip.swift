//
//  BattleShip.swift
//  FunctionalSwift
//
//  Created by 李一平 on 2018/6/28.
//  Copyright © 2018年 qingfengiOS. All rights reserved.
//
//高阶函数 把函数当做一种类型
import UIKit

typealias Distance = Double
typealias Region = (Position) -> Bool//从现在开始，Region 类型将指代把 Position 转化为 Bool 的函数。严格来说这不是必须的，但是它可以让我们更容易理解在接下来即将看到的一些类型。

//我们使用一个能判断给定点是否在区域内的函数来代表一个区域，而不是定义一个对象或结构体来表示它。如果你不习惯函数式编程，这可能看起来会很奇怪，但是记住：在 Swift 中函数是一等值！我们有意识地选择了 Region 作为这个类型的名字，而非 CheckInRegion 或 RegionBlock 这种字里行间暗示着它们代表一种函数类型的名字。函数式编程的核心理念就是函数是值，它和结构体、整型或是布尔型没有什么区别 —— 对函数使用另外一套命名规则会违背这一理念。

struct Position {//1. 位于原点的船舶射程范围内的点
    var x: Double
    var y: Double
}


extension Position {//2. 允许船有它自己的位置
    func inRange(range: Distance) -> Bool {//1. 位于原点的船舶射程范围内的点
        return sqrt(x * x + y * y) <= range
    }
    
    func minus(_ p: Position) -> Position {
        return Position(x: x - p.x, y: y - p.y)
    }
    
    var length: Double {
        return sqrt(x * x + y * y)
    }
    
    
    /**
     我们定义的第一个区域是以原点为圆心的圆 (circle)：
     */
    func circle(radius: Distance) -> Region {
        return { position in position.length <= radius }
    }
    
    /**
     当然，并不是所有圆的圆心都是原点。我们可以给 circle 函数添加更多的参数来解决这个问题。要得到一个圆心是任意定点的圆，我们只需要添加另一个代表圆心的参数，并确保在计算新区域时将这个参数考虑进去：
     */
    func circle2(radius: Distance, center: Position) -> Region {
        return { point in point.minus(center).length <= radius }
    }
    
    /**
     然而，如果我们想对更多的图形组件(例如，想象我们不仅有圆，还有矩形或其它形状)做出同样的改变，可能需要重复这些代码。更加函数式的方式是写一个区域变换函数。这个函数按一定的偏移量移动一个区域：
     */
    func shift(region: @escaping Region, offset: Position) -> Region {
        return { point in region(point.minus(offset)) }
    }
}


struct Ship {//船只
    var position: Position
    
    var firingRange: Distance/*火力覆盖范围*/
    var unsafeRange: Distance/*安全范围*/
}

extension Ship {
    //    我们向结构体 Ship 中添加一个 canEngageShip(_:) 函数对其进行扩展，这个函数允许我们检验是否有另一艘船在范围内，不论我们是位于原点还是其它任何位置
    func canEngageShip(target: Ship) -> Bool {
        let dx = target.position.x - position.x
        let dy = target.position.y - position.y
        let targetDistance = sqrt(dx * dx + dy * dy)
        return targetDistance < firingRange
    }
    
    //3. 避免与过近的敌方船舶交战
    //    我们需要再一次修改代码，使 unsafeRange 属性能够发挥作用：
    func canSafelyEngageShip(target: Ship) -> Bool {
        let dx = target.position.x - position.x
        let dy = target.position.y - position.y
        let targetDistance = sqrt(dx * dx + dy * dy)
        return targetDistance <= firingRange && targetDistance > unsafeRange
    }
    
    func canSafelyEngageShip1(target: Ship, friendly: Ship) -> Bool {//“4. 避免敌方过于接近友方船舶”
        let dx = target.position.x - position.x
        let dy = target.position.y - position.y
        let targetDistance = sqrt(dx * dx + dy * dy)
        
        let friendlyDx = friendly.position.x - target.position.x
        let friendlyDy = friendly.position.y - target.position.y
        let friendlyDistance = sqrt(friendlyDx * friendlyDx +
            friendlyDy * friendlyDy)
        
        return targetDistance <= firingRange && targetDistance > unsafeRange && friendlyDistance > unsafeRange
    }
    
    //随着代码的发展，它变得越来越难维护。这个函数包含了一大段复杂的计算的代码。我们可以在 Position 中添加两个负责几何运算的辅助函数让这段代码变得清晰易懂一些；添加了辅助函数之后，函数变成了下面这样：
    func canSafelyEngageShip2(target: Ship, friendly: Ship) -> Bool {
        let targetDistance = target.position.minus(position).length
        let friendlyDistance = friendly.position.minus(target.position).length
        return targetDistance <= firingRange && targetDistance > unsafeRange && friendlyDistance > unsafeRange
    }
}

class BattleShip: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let position: Position = Position(x: 3, y: 3)
        let res = position.inRange(range: 2)
        print(res)
    }
}
