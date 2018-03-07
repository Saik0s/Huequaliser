$currentSwiftVersion = "4.0.3"
$companyIdentifier = "com.24coms"
$testSuffix = "Tests"
$testSuffixUI = "UI" + $testSuffix
$developmentTeamId = "GCP5GN46PY"

project.name = "Huequaliser"
project.class_prefix = ""
project.organization = "24coms"

project.all_configurations.each do |configuration|

    configuration.settings["ENABLE_BITCODE"] = "NO"

    configuration.settings["SDKROOT"] = "iphoneos"
    configuration.settings["GCC_DYNAMIC_NO_PIC"] = "NO"
    configuration.settings["OTHER_CFLAGS"] = "$(inherited) -DNS_BLOCK_ASSERTIONS=1"
    configuration.settings["GCC_C_LANGUAGE_STANDARD"] = "gnu99"
    configuration.settings["CLANG_ENABLE_MODULES"] = "YES"
    configuration.settings["CLANG_ENABLE_OBJC_ARC"] = "YES"
    configuration.settings["ENABLE_NS_ASSERTIONS"] = "NO"
    configuration.settings["ENABLE_STRICT_OBJC_MSGSEND"] = "YES"
    configuration.settings["CLANG_WARN_EMPTY_BODY"] = "YES"
    configuration.settings["CLANG_WARN_BOOL_CONVERSION"] = "YES"
    configuration.settings["CLANG_WARN_CONSTANT_CONVERSION"] = "YES"
    configuration.settings["GCC_WARN_64_TO_32_BIT_CONVERSION"] = "YES"
    configuration.settings["CLANG_WARN_INT_CONVERSION"] = "YES"
    configuration.settings["GCC_WARN_ABOUT_RETURN_TYPE"] = "YES_ERROR"
    configuration.settings["GCC_WARN_UNINITIALIZED_AUTOS"] = "YES_AGGRESSIVE"
    configuration.settings["CLANG_WARN_UNREACHABLE_CODE"] = "YES"
    configuration.settings["GCC_WARN_UNUSED_FUNCTION"] = "YES"
    configuration.settings["GCC_WARN_UNUSED_VARIABLE"] = "YES"
    configuration.settings["CLANG_WARN_DIRECT_OBJC_ISA_USAGE"] = "YES_ERROR"
    configuration.settings["CLANG_WARN__DUPLICATE_METHOD_MATCH"] = "YES"
    configuration.settings["GCC_WARN_UNDECLARED_SELECTOR"] = "YES"
    configuration.settings["CLANG_WARN_OBJC_ROOT_CLASS"] = "YES_ERROR"

    configuration.settings["CURRENT_PROJECT_VERSION"] = "1" # just default non-empty value

    configuration.settings["DEFINES_MODULE"] = "YES" # http://stackoverflow.com/a/27251979

    configuration.settings["SWIFT_OPTIMIZATION_LEVEL"] = "-Onone"

    configuration.settings["CLANG_WARN_INFINITE_RECURSION"] = "YES" # Xcode 8
    configuration.settings["CLANG_WARN_SUSPICIOUS_MOVE"] = "YES" # Xcode 8
    configuration.settings["ENABLE_STRICT_OBJC_MSGSEND"] = "YES" # Xcode 8
    configuration.settings["GCC_NO_COMMON_BLOCKS"] = "YES"
    configuration.settings["ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES"] = "$(inherited)" # "YES"

    configuration.settings["SWIFT_VERSION"] = $currentSwiftVersion

    #===

    if configuration.name == "Release"
        configuration.settings["DEBUG_INFORMATION_FORMAT"] = "dwarf-with-dsym"
        configuration.settings["SWIFT_OPTIMIZATION_LEVEL"] = "-Owholemodule" # Xcode 8
    end
end

def carthage_copy_basic_frameworks(target)
    target.shell_script_build_phase 'Copy Carthage Frameworks', <<-SCRIPT
        export SCRIPT_INPUT_FILE_COUNT=8
        export SCRIPT_INPUT_FILE_0=${SRCROOT}/Frameworks/Action.framework
        export SCRIPT_INPUT_FILE_1=${SRCROOT}/Frameworks/AsyncDisplayKit.framework
        export SCRIPT_INPUT_FILE_2=${SRCROOT}/Frameworks/IGListKit.framework
        export SCRIPT_INPUT_FILE_3=${SRCROOT}/Frameworks/NSObject_Rx.framework
        export SCRIPT_INPUT_FILE_4=${SRCROOT}/Frameworks/RxCocoa.framework
        export SCRIPT_INPUT_FILE_5=${SRCROOT}/Frameworks/RxOptional.framework
        export SCRIPT_INPUT_FILE_6=${SRCROOT}/Frameworks/RxSwift.framework
        export SCRIPT_INPUT_FILE_7=${SRCROOT}/Frameworks/HueSDK.framework
        carthage copy-frameworks
    SCRIPT
end

def carthage_copy_test_frameworks(target)
    target.shell_script_build_phase 'Copy Carthage Frameworks', <<-SCRIPT
        export SCRIPT_INPUT_FILE_COUNT=5
        export SCRIPT_INPUT_FILE_0=${SRCROOT}/Frameworks/RxTest.framework
        export SCRIPT_INPUT_FILE_1=${SRCROOT}/Frameworks/Nimble.framework
        export SCRIPT_INPUT_FILE_2=${SRCROOT}/Frameworks/RxBlocking.framework
        export SCRIPT_INPUT_FILE_3=${SRCROOT}/Frameworks/RxNimble.framework
        export SCRIPT_INPUT_FILE_4=${SRCROOT}/Frameworks/Quick.framework
        carthage copy-frameworks
    SCRIPT
end

def basic_target(name, type)
    target do |target|
        target.name = name
        target.language = :swift
        target.type = type
        target.platform = :ios
        target.deployment_target = 9.0

        #target.include_files << "Huequaliser/Sources/**/*.*"
        #target.include_files << "Huequaliser/Resources/**/*.*"
        target.exclude_files << target.name + "/" + $testSuffix + "/**/*.*"
        target.exclude_files << target.name + "/" + $testSuffixUI + "/**/*.*"

        target.all_configurations.each do |configuration|

            #=== Build Settings - Core

            configuration.product_bundle_identifier = $companyIdentifier + "." + target.name
            configuration.supported_devices = :iphone_only
            configuration.settings["INFOPLIST_FILE"] = "Assets/InfoPlists/" + target.name + "Info.plist"
            configuration.settings["PRODUCT_NAME"] = "$(TARGET_NAME)"

            configuration.settings["FRAMEWORK_SEARCH_PATHS"] = "$(inherited) $(SRCROOT)/Frameworks/**"
            configuration.settings["ASSETCATALOG_COMPILER_APPICON_NAME"] = "AppIcon"
            # configuration.settings["ASSETCATALOG_COMPILER_LAUNCHIMAGE_NAME"] = "Brand Assets"
            # configuration.settings["OTHER_LDFLAGS"] = "$(inherited) -ObjC"

            # Xcode 8 automati c signing support
            configuration.settings["CODE_SIGN_IDENTITY[sdk=iphoneos*]"] = "iPhone Developer"
            configuration.settings["DEVELOPMENT_TEAM"] = $developmentTeamId
        end

        target.system_frameworks = ['Foundation']
        target.system_frameworks << 'UIKit'

        target.include_files << 'Frameworks/HueSDK.framework'
        target.include_files << 'Frameworks/Action.framework'
        target.include_files << 'Frameworks/AsyncDisplayKit.framework'
        target.include_files << 'Frameworks/IGListKit.framework'
        target.include_files << 'Frameworks/NSObject_Rx.framework'
        target.include_files << 'Frameworks/RxCocoa.framework'
        target.include_files << 'Frameworks/RxOptional.framework'
        target.include_files << 'Frameworks/RxSwift.framework'

        target.shell_script_build_phase 'Hue Framework replace', <<-SCRIPT
            BASE_DIR="${PROJECT_DIR}/Dependencies/HueSDK"

            if [ ${PLATFORM_NAME} = "iphonesimulator" ]
            then
                ln -sF "${BASE_DIR}/simulator/HueSDK.framework" "${PROJECT_DIR}/Frameworks/HueSDK.framework"
            else
                ln -sF "${BASE_DIR}/device/HueSDK.framework" "${PROJECT_DIR}/Frameworks/HueSDK.framework"
            fi
        SCRIPT

        target.shell_script_build_phase 'Sources formatter', <<-SCRIPT
            ${SRCROOT}/Scripts/formatter
        SCRIPT

        target.shell_script_build_phase 'CopyPaste Detection', <<-SCRIPT
            ${SRCROOT}/Scripts/cpd
        SCRIPT

        carthage_copy_basic_frameworks(target)

        #=== Unit Tests

        unit_tests_for target do |test_target|
            test_target.name = target.name + $testSuffix

            test_target.all_configurations.each do |configuration|
                configuration.product_bundle_identifier = $companyIdentifier + "." + test_target.name
                configuration.settings["INFOPLIST_FILE"] = "Assets/InfoPlists/" + test_target.name + "Info.plist"
                configuration.settings["DEVELOPMENT_TEAM"] = $developmentTeamId
                configuration.settings["FRAMEWORK_SEARCH_PATHS"] = "$(inherited) $(SRCROOT)/Frameworks/**"
            end

            test_target.include_files = [target.name + "/" + $testSuffix + "/**/*.*"] # we set array with 1 element here!

            test_target.include_files << 'Frameworks/Action.framework'
            test_target.include_files << 'Frameworks/AsyncDisplayKit.framework'
            test_target.include_files << 'Frameworks/IGListKit.framework'
            test_target.include_files << 'Frameworks/NSObject_Rx.framework'
            test_target.include_files << 'Frameworks/RxCocoa.framework'
            test_target.include_files << 'Frameworks/RxOptional.framework'
            test_target.include_files << 'Frameworks/RxSwift.framework'

            test_target.include_files << 'Frameworks/RxTest.framework'
            test_target.include_files << 'Frameworks/Nimble.framework'
            test_target.include_files << 'Frameworks/RxBlocking.framework'
            test_target.include_files << 'Frameworks/RxNimble.framework'
            test_target.include_files << 'Frameworks/Quick.framework'
            
            carthage_copy_basic_frameworks(test_target)
            carthage_copy_test_frameworks(test_target)
        end

        #=== UI Tests

        ui_tests_for target do |test_target|
            test_target.name = target.name + $testSuffixUI

            test_target.all_configurations.each do |configuration|
                configuration.product_bundle_identifier = $companyIdentifier + "." + test_target.name
                configuration.settings["INFOPLIST_FILE"] = "Assets/InfoPlists/" + test_target.name + "Info.plist"
                configuration.settings["DEVELOPMENT_TEAM"] = $developmentTeamId
                configuration.settings["FRAMEWORK_SEARCH_PATHS"] = "$(inherited) $(SRCROOT)/Frameworks/**"
            end

            test_target.include_files = [target.name + "/" + $testSuffixUI + "/**/*.*"] # we set array with 1 element here!

            test_target.include_files << 'Frameworks/Action.framework'
            test_target.include_files << 'Frameworks/AsyncDisplayKit.framework'
            test_target.include_files << 'Frameworks/IGListKit.framework'
            test_target.include_files << 'Frameworks/NSObject_Rx.framework'
            test_target.include_files << 'Frameworks/RxCocoa.framework'
            test_target.include_files << 'Frameworks/RxOptional.framework'
            test_target.include_files << 'Frameworks/RxSwift.framework'

            test_target.include_files << 'Frameworks/RxTest.framework'
            test_target.include_files << 'Frameworks/Nimble.framework'
            test_target.include_files << 'Frameworks/RxBlocking.framework'
            test_target.include_files << 'Frameworks/RxNimble.framework'
            test_target.include_files << 'Frameworks/Quick.framework'

            carthage_copy_basic_frameworks(test_target)
            carthage_copy_test_frameworks(test_target)
        end
    end
end

enra = basic_target("Huequaliser", :application)
