# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

inhibit_all_warnings!

def rx_swift
  pod 'RxSwift'
end

def rx_cocoa
    pod 'RxCocoa'
end

def rx_data_sources
  pod 'RxDataSources'
end

def network_pods
  pod 'Alamofire'
end

def dev_pods
  pod 'SwiftLint'
end

def util_pods
    pod 'SVProgressHUD'    
    #Network
    pod 'Kingfisher'
    #Util
    pod 'netfox'
    pod 'PureLayout'
    #Genral
    pod 'IQKeyboardManagerSwift'
end

target 'Currency' do
  use_frameworks!
  rx_swift
  rx_cocoa
  rx_data_sources
  network_pods
  dev_pods
  util_pods

  target 'CurrencyTests' do
    inherit! :search_paths
    rx_swift
    dev_pods
  end
end
