//
//  FacialDetectorManager.swift
//  verification
//
//  Created by Tyrant on 2025/7/18.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa

class FacialDetectorManager: NSObject {
    
    
    let image = MutableProperty<UIImage?>(nil)
    
    func getVC() -> LiveDetectController {
        var liveVc = LiveDetectController()
        
        liveVc.signKey = "HISP1YFG44LQ29W0"
        
        liveVc.actionList = [2,1]
        
        return liveVc
//        liveVc.
        // 设置动作随机, 提高攻击者难度. 注意: 必须包含注视动作且要放在最后.
//        var randomActions = [self randomArray:@[@2,@3,@4,@5] withRandomNum:2];
//        [randomActions addObject:@1];
//        liveVc.randomActions = [randomActions copy];
//        liveVc.modalPresentationStyle = UIModalPresentationFullScreen;
//        [self presentViewController:liveVc animated:YES completion:nil];
//
//        #pragma mark -
//        #pragma mark LiveDetectControllerDelegate
//
//        - (void)onFailed:(int)code withMessage:(NSString *)message{
//            [self.view makeToast:message];
//        }
//        - (void)onCompleted:(BOOL)live withData:(NSData *)imageData rect:(CGRect)faceRect{
//            if (live){
//                // 获取活体照片加密字符串数据
//                UIImage *liveImage = [UIImage imageWithData:imageData];
//                // 注意, 得到的是密文数据且无法显示
//                ...
//            }
//        }
    }
    
    let net = VerificationBaseNetProvider<VerifyNet>()
        
    lazy var verifyThreeAction: Action<VerifyNet, VerifyThreeResponse, AnvilNetError> = {
        return Action { [unowned self] model in
            return self.net.detach(model, VerifyThreeResponse.self)
        }
    }()
    
    var data = ThreeVerifyData()
}


