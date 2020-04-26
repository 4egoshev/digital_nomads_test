# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def reactivePods
    pod 'ReactiveSwift', '~> 5.0'
    pod 'ReactiveCocoa', '~> 9.0'
end

def network
    pod 'Alamofire', '~> 4.8.1'
    pod 'AlamofireImage', '~> 3.5'
    pod 'SwiftyJSON', '~> 4.0'
end

def dataBase
   pod 'RealmSwift', '~> 3.18.0'
end

def utils
    pod 'SwiftUtilites', '~> 0.1.9'
    pod 'ErrorDispatcher/ReactiveSwift', '~> 0.1.5'
end

def pods
    reactivePods
    network
    dataBase
    utils
end

target 'digital_nomads_test' do
  use_frameworks!
  pods
end
