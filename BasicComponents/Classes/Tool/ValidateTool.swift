
import Foundation

/*
 *  正则匹配校验
 */
public enum ValidateTool {
    /// 邮箱校验
    case email(_: String)
    /// 手机号校验
    case phoneNum(_: String)
    /// 银行卡号验证
    case carNum(_: String)
    /// 用户名校验
    case username(_: String)
    /// 密码校验
    case password(_: String)
    /// 昵称校验
    case nickname(_: String)
    /// 短信验格式校验
    case verifyCode(_: String)
    
    
    public var isRight: Bool {
        var predicateStr:String!
        var currObject:String!
        switch self {
            case let .email(str):
                predicateStr = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
                currObject = str
            case let .phoneNum(str):
                predicateStr = "^1\\d{10}$"
                currObject = str
            case let .carNum(str):
                predicateStr = "^[A-Za-z]{1}[A-Za-z_0-9]{5}$"
                currObject = str
            case let .username(str):
                predicateStr = "^[A-Za-z0-9]{6,20}+$"
                currObject = str
            case let .password(str):
                predicateStr = "^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{8,20}"
                currObject = str
            case let .nickname(str):
                predicateStr = "^[\\u4e00-\\u9fa5]{4,8}$"
                currObject = str
            case let .verifyCode(str):
                predicateStr = "^\\w{4,8}$"
                currObject = str
        }
        
        let predicate = NSPredicate(format: "SELF MATCHES %@", predicateStr)
        return predicate.evaluate(with: currObject)
    }
}
