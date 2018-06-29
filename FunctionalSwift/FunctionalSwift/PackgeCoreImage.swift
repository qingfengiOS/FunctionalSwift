//
//  PackgeCoreImage.swift
//  FunctionalSwift
//
//  Created by qingfengiOS on 2018/6/28.
//  Copyright © 2018年 qingfengiOS. All rights reserved.
//

import UIKit

typealias Filter = (CIImage) -> CIImage//我们将 Filter 类型定义为一个函数，该函数接受一个图像作为参数并返回一个新的图像

class PackgeCoreImage: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let originImageView = UIImageView(frame: CGRect(x: 60, y: 90, width: 200, height: 120))
        self.view.addSubview(originImageView)
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 120))
        imageView.center = self.view.center
        self.view.addSubview(imageView)
  
        
        let url = URL(string: "https://upload-images.jianshu.io/upload_images/1396454-d5825e32264f57fb.png")!
        
        let queue = DispatchQueue(label: "queue")
        queue.async {//耗时操作
            
            let data = NSData.init(contentsOf: url)//url->Data
            
            let image = CIImage(contentsOf: url)
            let blurRadius = 2.0
            let overlayColor = UIColor.red.withAlphaComponent(0.1)
            
            //调用设置高斯滤镜：
//        let blurredImage = blur(radius: blurRadius)(image!)
//        let overlaidImage = colorOverlay(color: overlayColor)(blurredImage)
//        imageView.image = UIImage(ciImage: overlaidImage)
            
            //链式调用：
//            let resultImage = self.colorOverlay(color: overlayColor)(self.blur(radius: blurRadius)(image!))
            
            //复合函数调用
            let myFilter1 = self.composeFilters(filter1: self.blur(radius: blurRadius), self.colorOverlay(color: overlayColor))
            let resultImage = myFilter1(image!)
            
            
            DispatchQueue.main.async {//主线程操作UI
                
                if let originImage = UIImage(data: data! as Data) {
                    originImageView.image = originImage;
                }
                
                imageView.image = UIImage(ciImage: resultImage)
            }
        }
        
        print("add(1)(2) = \(add(1)(2))")
        
    }
    
    /**
     滤镜类型：
     
     CIFilter 是 Core Image 中的核心类之一，用于创建图像滤镜。当实例化一个 CIFilter 对象时，你 (几乎) 总是通过 kCIInputImageKey 键提供输入图像，再通过 kCIOutputImageKey 键取回处理后的图像。取回的结果可以作为下一个滤镜的输入值。
     */
    
    //MARK:-1构建滤镜
    //MARK:-1.1模糊
    //定义第一个简单的滤镜 —— 高斯模糊滤镜。定义它只需要模糊半径这一个参数：
    func blur(radius: Double) -> Filter {
        return { image in
            let parameters = [
                kCIInputImageKey: image,
                kCIInputRadiusKey: radius
                ] as [String : Any]
            
            guard let filter = CIFilter(name: "CIGaussianBlur", withInputParameters: parameters) else {
                fatalError()
            }
            
            guard let outputImage = filter.outputImage else {
                fatalError()
            }
            return outputImage
        }
        /*
         blur 函数返回一个新函数，新函数接受一个 CIImage 类型的参数 image，并返回一个新图像 (return filter.outputImage)。因此，blur 函数的返回值满足我们之前定义的 (CIImage) -> CIImage，也就是 Filter 类型。
         
         这个例子仅仅只是对 Core Image 中一个已经存在的滤镜进行的简单封装。我们可以反复使用相同的模式来创建自己的滤镜函数。
         */
    }
    
    //MARK:-1.2颜色叠层
    /*
     现在让我们来定义一个能够在图像上覆盖纯色叠层的滤镜。Core Image 默认不包含这样一个滤镜，但是我们完全可以用已经存在的滤镜来组成它。
     
     我们将使用的两个基础组件：颜色生成滤镜 (CIConstantColorGenerator) 和图像覆盖合成滤镜 (CISourceOverCompositing)。首先让我们来定义一个生成固定颜色的滤镜：
     */
    func colorGenerator(color: UIColor) -> Filter {

        return { _ in

            let c = CIColor(color: color)
            let paramters = [kCIInputColorKey: c]
            guard let filter = CIFilter(name: "CIConstantColorGenerator", withInputParameters: paramters) else {
                fatalError()
            }
            guard let outputImage = filter.outputImage else {
                fatalError()
            }
            return outputImage
        }
        /*
         这段代码看起来和我们用来定义模糊滤镜的代码非常相似，但是有一个显著的区别：颜色生成滤镜不检查输入图像。因此，我们不需要给返回函数中的图像参数命名。取而代之，我们使用一个匿名参数 _ 来强调滤镜的输入图像参数是被忽略的。
         */
    }
    
    //定义合成滤镜：
    func composeteSourceOver(overlay: CIImage) -> Filter {
        
        return { image in
            let patamters = [
                kCIInputBackgroundImageKey: image,
                kCIInputImageKey: overlay
            ] as [String : Any]
            guard let filter = CIFilter(name: "CISourceOverCompositing", withInputParameters: patamters) else {
                fatalError()
            }
            guard let outputImage = filter.outputImage else {
                fatalError()
            }
            let cropRect = image.extent
            
            return outputImage.cropped(to: cropRect)
        }
        /*
         在这里我们将输出图像剪裁为与输入图像一致的尺寸。严格来说，这不是必须的，而完全取决于我们希望滤镜如何工作。不过，这个选择在我们即将涉及的例子中效果很好。
         */
    }
    
    //最后，我们通过结合两个滤镜来创建颜色叠层滤镜：
    func colorOverlay(color: UIColor) -> Filter {
        return { image in
            let overlay = self.colorGenerator(color: color)(image)
            return self.composeteSourceOver(overlay: overlay)(image)
        }
    }
    
    
    
    //MARK:-复合函数
    /**
     //链式调用：
     let resultImage = self.colorOverlay(color: overlayColor)(self.blur(radius: blurRadius)(image!))
     
     然而，由于括号错综复杂，这些代码很快失去了可读性。更好的解决方式是自定义一个运算符来组合滤镜。为了定义该运算符，首先我们要定义一个用于组合滤镜的函数：
     */
    func composeFilters(filter1: @escaping Filter, _ filter2: @escaping Filter) -> Filter {
        return { image in
            filter2(filter1(image))
        }
        /**
         composeFilters 函数接受两个 Filter 类型的参数，并返回一个新定义的滤镜。这个复合滤镜接受一个 CIImage 类型的图像参数，然后将该参数传递给 filter1，取得返回值之后再传递给 filter2。我们可以使用复合函数来定义复合滤镜，就像下面这样：
         
         */
        
    }
    
    
    //MARK:-柯里化
    func add(_ x: Int) -> (Int) -> Int {
        return { y in
            x + y
        }
    }
    
}
